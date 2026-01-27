//
//  SpeechService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine
import AVFoundation
import Speech

protocol SpeechServiceProtocol {
    func speak(_ text: String) -> AnyPublisher<Void, Error>
    func startListening() -> AnyPublisher<String, Error>
    func stopListening()
    var isListening: Bool { get }
}

class SpeechService: NSObject, SpeechServiceProtocol, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private lazy var audioEngine: AVAudioEngine = {
        let engine = AVAudioEngine()
        return engine
    }()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    private var speakPromise: ((Result<Void, Error>) -> Void)?
    private var listenPromise: ((Result<String, Error>) -> Void)?
    private var currentTranscript: String = ""
    
    @Published var isListening = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
        
        // Инициализируем распознаватель речи безопасно
        // Проверяем доступность перед созданием
        guard SFSpeechRecognizer.authorizationStatus() != .denied else {
            self.authorizationStatus = .denied
            return
        }
        
        if let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")), recognizer.isAvailable {
            self.speechRecognizer = recognizer
        }
        
        // Запрашиваем разрешения асинхронно, не блокируя инициализацию
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.requestAuthorization()
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speakPromise?(.success(()))
        speakPromise = nil
        
        // Деактивируем аудио сессию после завершения
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                print("Error deactivating audio session after speech: \(error)")
            }
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        speakPromise?(.failure(SpeechServiceError.synthesizerUnavailable))
        speakPromise = nil
        
        // Деактивируем аудио сессию после отмены
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                print("Error deactivating audio session after speech cancel: \(error)")
            }
        }
    }
    
    private func requestAuthorization() {
        authorizationStatus = SFSpeechRecognizer.authorizationStatus()
        if authorizationStatus == .notDetermined {
            SFSpeechRecognizer.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    self?.authorizationStatus = status
                }
            }
        }
    }
    
    func speak(_ text: String) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(SpeechServiceError.synthesizerUnavailable))
                return
            }
            
            // Останавливаем запись, если она активна
            if self.isListening {
                self.stopListening()
            }
            
            // Останавливаем предыдущий синтез, если он активен
            if self.synthesizer.isSpeaking {
                self.synthesizer.stopSpeaking(at: .immediate)
                // Вызываем предыдущий promise с ошибкой отмены
                self.speakPromise?(.failure(SpeechServiceError.synthesizerUnavailable))
                self.speakPromise = nil
            }
            
            // Настраиваем аудио сессию для воспроизведения
            do {
                let audioSession = AVAudioSession.sharedInstance()
                // Используем .playback для синтеза речи, чтобы не конфликтовать с записью
                try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                promise(.failure(error))
                return
            }
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            
            // Сохраняем promise для вызова после завершения
            self.speakPromise = promise
            
            self.synthesizer.speak(utterance)
        }
        .eraseToAnyPublisher()
    }
    
    func startListening() -> AnyPublisher<String, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(SpeechServiceError.recognizerUnavailable))
                return
            }
            
            // Проверяем разрешения на микрофон
            let audioSession = AVAudioSession.sharedInstance()
            var hasMicrophonePermission = false
            
            switch audioSession.recordPermission {
            case .granted:
                hasMicrophonePermission = true
            case .denied:
                promise(.failure(SpeechServiceError.authorizationDenied))
                return
            case .undetermined:
                audioSession.requestRecordPermission { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.continueStartListening(promise: promise)
                        }
                    } else {
                        promise(.failure(SpeechServiceError.authorizationDenied))
                    }
                }
                return
            @unknown default:
                promise(.failure(SpeechServiceError.authorizationDenied))
                return
            }
            
            // Проверяем разрешения на распознавание речи
            if self.authorizationStatus != .authorized {
                // Обновляем статус
                self.authorizationStatus = SFSpeechRecognizer.authorizationStatus()
                if self.authorizationStatus != .authorized {
                    promise(.failure(SpeechServiceError.authorizationDenied))
                    return
                }
            }
            
            guard hasMicrophonePermission else {
                promise(.failure(SpeechServiceError.authorizationDenied))
                return
            }
            
            self.continueStartListening(promise: promise)
        }
        .eraseToAnyPublisher()
    }
    
    private func continueStartListening(promise: @escaping (Result<String, Error>) -> Void) {
        guard let recognizer = self.speechRecognizer,
              recognizer.isAvailable else {
            promise(.failure(SpeechServiceError.recognizerUnavailable))
            return
        }
        
        // Останавливаем предыдущую сессию, если она есть (но не очищаем promise, если он уже установлен)
        let wasListening = self.isListening
        if wasListening {
            // Сохраняем старый promise, если он есть
            let oldPromise = self.listenPromise
            self.listenPromise = nil
            self.isListening = false
            
            // Останавливаем старую сессию без вызова promise
            recognitionTask?.cancel()
            recognitionTask = nil
            
            if audioEngine.isRunning {
                audioEngine.stop()
                do {
                    let inputNode = audioEngine.inputNode
                    inputNode.removeTap(onBus: 0)
                } catch {
                    print("Error removing tap: \(error)")
                }
            }
            
            recognitionRequest?.endAudio()
            recognitionRequest = nil
            
            // Отправляем ошибку отмены старому promise
            oldPromise?(.failure(SpeechServiceError.recognizerUnavailable))
        }
        
        // Сохраняем promise для использования при остановке ДО начала записи
        self.listenPromise = promise
        self.currentTranscript = ""
        
        // Настраиваем аудио сессию
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.listenPromise = nil
            promise(.failure(error))
            return
        }
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = request
        
        do {
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak request] buffer, _ in
                request?.append(buffer)
            }
            
            self.audioEngine.prepare()
            try self.audioEngine.start()
            self.isListening = true
        } catch {
            self.listenPromise = nil
            self.stopListening()
            promise(.failure(error))
            return
        }
        
        self.recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                self.currentTranscript = transcript
                print("📝 Промежуточный транскрипт: '\(transcript)' (финальный: \(result.isFinal))")
                
                if result.isFinal {
                    print("✅ Получен финальный результат: '\(transcript)'")
                    // При финальном результате вызываем promise здесь
                    // и очищаем его перед stopListening, чтобы избежать двойного вызова
                    if let promise = self.listenPromise {
                        promise(.success(transcript))
                        self.listenPromise = nil
                    }
                    // Останавливаем запись (но promise уже вызван, поэтому он не будет вызван повторно)
                    self.stopListening()
                }
            } else if let error = error {
                print("❌ Ошибка распознавания: \(error)")
                // Не отправляем ошибку, если это просто отмена
                let nsError = error as NSError
                if nsError.code != 216 && nsError.code != 1700 {
                    // Реальная ошибка - отправляем только если promise еще не выполнен
                    if let promise = self.listenPromise {
                        promise(.failure(error))
                        self.listenPromise = nil
                    }
                } else {
                    // Это отмена (216 или 1700)
                    print("ℹ️ Распознавание отменено (код: \(nsError.code))")
                    // Если promise еще не выполнен и есть транскрипт, отправляем его
                    if let promise = self.listenPromise, !self.currentTranscript.isEmpty {
                        print("✅ Отправляем транскрипт при отмене: '\(self.currentTranscript)'")
                        promise(.success(self.currentTranscript))
                        self.listenPromise = nil
                    } else if let promise = self.listenPromise {
                        // Если транскрипта нет, отправляем ошибку
                        promise(.failure(SpeechServiceError.recognizerUnavailable))
                        self.listenPromise = nil
                    }
                }
                self.stopListening()
            }
        }
    }
    
    func stopListening() {
        let wasListening = isListening
        let hasPromise = listenPromise != nil
        let transcript = currentTranscript
        
        print("🛑 stopListening вызван. isListening: \(wasListening), hasPromise: \(hasPromise), transcript: '\(transcript)'")
        
        // Сначала останавливаем техническую часть записи
        recognitionTask?.cancel()
        recognitionTask = nil
        
        if audioEngine.isRunning {
            audioEngine.stop()
            // Безопасное удаление tap
            do {
                let inputNode = audioEngine.inputNode
                inputNode.removeTap(onBus: 0)
            } catch {
                print("Error removing tap: \(error)")
            }
        }
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        // Деактивируем аудио сессию
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error deactivating audio session: \(error)")
        }
        
        isListening = false
        
        // Теперь отправляем результат через promise, если он есть
        guard hasPromise else {
            print("⚠️ stopListening вызван, но promise отсутствует")
            currentTranscript = ""
            return
        }
        
        if !transcript.isEmpty {
            print("✅ Отправляем транскрипт через promise: '\(transcript)'")
            // Вызываем promise синхронно (Future требует синхронного вызова)
            if let promise = listenPromise {
                promise(.success(transcript))
                listenPromise = nil
                currentTranscript = ""
            } else {
                print("⚠️ Promise был очищен до вызова")
            }
        } else {
            print("⚠️ Транскрипт пустой, отправляем ошибку")
            if let promise = listenPromise {
                promise(.failure(SpeechServiceError.recognizerUnavailable))
                listenPromise = nil
                currentTranscript = ""
            } else {
                print("⚠️ Promise был очищен до вызова")
            }
        }
    }
}

enum SpeechServiceError: Error {
    case synthesizerUnavailable
    case recognizerUnavailable
    case authorizationDenied
}

