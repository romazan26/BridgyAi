# Необходимые разрешения для BridgyAI

Для работы функций распознавания речи и синтеза речи необходимо добавить следующие разрешения в Info.plist проекта:

## Требуемые разрешения:

1. **NSMicrophoneUsageDescription** - для доступа к микрофону
   - Описание: "BridgyAI needs access to your microphone to practice pronunciation and speech recognition."

2. **NSSpeechRecognitionUsageDescription** - для распознавания речи
   - Описание: "BridgyAI needs speech recognition to help you practice speaking English."

## Как добавить в Xcode:

1. Откройте проект в Xcode
2. Выберите Target проекта
3. Перейдите на вкладку "Info"
4. Добавьте следующие ключи:
   - Privacy - Microphone Usage Description
   - Privacy - Speech Recognition Usage Description

## Альтернативный способ (через Info.plist):

Если используется отдельный Info.plist файл, добавьте:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>BridgyAI needs access to your microphone to practice pronunciation and speech recognition.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>BridgyAI needs speech recognition to help you practice speaking English.</string>
```


