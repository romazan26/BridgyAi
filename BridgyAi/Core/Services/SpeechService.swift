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

class SpeechService: NSObject, SpeechServiceProtocol, ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private lazy var audioEngine: AVAudioEngine = {
        let engine = AVAudioEngine()
        return engine
    }()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    @Published var isListening = false
    
    override init() {
        super.init()
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
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            
            self.synthesizer.speak(utterance)
            promise(.success(()))
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
        
        // Останавливаем предыдущую сессию, если она есть
        self.stopListening()
        
        // Настраиваем аудио сессию
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
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
            self.stopListening()
            promise(.failure(error))
            return
        }
        
        self.recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                if result.isFinal {
                    self.stopListening()
                    promise(.success(transcript))
                }
            } else if let error = error {
                self.stopListening()
                // Не отправляем ошибку, если это просто отмена
                let nsError = error as NSError
                if nsError.code != 216 && nsError.code != 1700 {
                    promise(.failure(error))
                }
            }
        }
    }
    
    func stopListening() {
        guard isListening else { return }
        
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
    }
}

enum SpeechServiceError: Error {
    case synthesizerUnavailable
    case recognizerUnavailable
    case authorizationDenied
}

