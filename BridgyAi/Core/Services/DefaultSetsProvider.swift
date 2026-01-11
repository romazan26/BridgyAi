//
//  DefaultSetsProvider.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

class DefaultSetsProvider {
    static func getDefaultSets() -> [FlashcardSet] {
        return [
            // Бизнес-встречи
            FlashcardSet(
                id: "default_meetings_001",
                title: "Еженедельные стендапы",
                description: "Основные фразы для ежедневных стендап-встреч в IT-компаниях",
                workScenario: .meetings,
                difficulty: .beginner,
                cards: [
                    Flashcard(
                        id: "card_m001",
                        front: "Как сказать, что вы закончите задачу к пятнице?",
                        back: "I'll have it completed by Friday.",
                        phonetic: "aɪl hæv ɪt kəmˈpliːtɪd baɪ ˈfraɪdeɪ",
                        example: "For the Q3 report, I'll have it completed by Friday.",
                        hint: "Используйте Future Perfect для дедлайнов",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["дедлайны", "встречи", "обещания"]
                    ),
                    Flashcard(
                        id: "card_m002",
                        front: "Как сообщить о прогрессе по проекту?",
                        back: "I'm making good progress on the project.",
                        phonetic: "aɪm ˈmeɪkɪŋ ɡʊd ˈprəʊɡres ɒn ðə ˈprɒdʒekt",
                        example: "I'm making good progress on the project. We should finish by next week.",
                        hint: "Используйте Present Continuous для текущих действий",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["прогресс", "встречи", "обновления"]
                    ),
                    Flashcard(
                        id: "card_m003",
                        front: "Как сказать, что вы столкнулись с проблемой?",
                        back: "I'm running into some issues.",
                        phonetic: "aɪm ˈrʌnɪŋ ˈɪntuː sʌm ˈɪʃuːz",
                        example: "I'm running into some issues with the API integration.",
                        hint: "run into = столкнуться с",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["проблемы", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m004",
                        front: "Как предложить обсудить что-то позже?",
                        back: "Let's discuss this offline.",
                        phonetic: "lets dɪˈskʌs ðɪs ɒfˈlaɪn",
                        example: "This is getting too detailed. Let's discuss this offline.",
                        hint: "offline = вне встречи, отдельно",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["встречи", "коммуникация"]
                    ),
                    Flashcard(
                        id: "card_m005",
                        front: "Как сказать, что вам нужна помощь?",
                        back: "I could use some help with this.",
                        phonetic: "aɪ kʊd juːz sʌm help wɪð ðɪs",
                        example: "I could use some help with this task. It's taking longer than expected.",
                        hint: "could use = нужна",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["помощь", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m006",
                        front: "Как сказать, что вы закончили задачу?",
                        back: "I've finished the task.",
                        phonetic: "aɪv ˈfɪnɪʃt ðə tɑːsk",
                        example: "I've finished the task you assigned me yesterday.",
                        hint: "finished = закончил",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["завершение", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m007",
                        front: "Как сказать, что вы работаете над чем-то?",
                        back: "I'm working on it right now.",
                        phonetic: "aɪm ˈwɜːkɪŋ ɒn ɪt raɪt naʊ",
                        example: "I'm working on it right now. I'll send it to you by the end of the day.",
                        hint: "working on = работаю над",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["работа", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m008",
                        front: "Как спросить о статусе проекта?",
                        back: "What's the status of the project?",
                        phonetic: "wɒts ðə ˈsteɪtəs ɒv ðə ˈprɒdʒekt",
                        example: "What's the status of the project? Are we on track?",
                        hint: "status = статус",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["вопросы", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m009",
                        front: "Как сказать, что вы согласны?",
                        back: "I agree with that approach.",
                        phonetic: "aɪ əˈɡriː wɪð ðæt əˈprəʊtʃ",
                        example: "I agree with that approach. It makes sense.",
                        hint: "agree = согласен",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["согласие", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m010",
                        front: "Как предложить встречу?",
                        back: "Let's schedule a meeting for next week.",
                        phonetic: "lets ˈʃedjuːl ə ˈmiːtɪŋ fɔː nekst wiːk",
                        example: "Let's schedule a meeting for next week to discuss this further.",
                        hint: "schedule = назначить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["планирование", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m011",
                        front: "Как сказать, что вы не уверены?",
                        back: "I'm not sure about that.",
                        phonetic: "aɪm nɒt ʃʊə əˈbaʊt ðæt",
                        example: "I'm not sure about that. Let me check and get back to you.",
                        hint: "not sure = не уверен",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["неуверенность", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m012",
                        front: "Как попросить уточнить?",
                        back: "Could you clarify that, please?",
                        phonetic: "kʊd juː ˈklærɪfaɪ ðæt pliːz",
                        example: "Could you clarify that, please? I want to make sure I understand correctly.",
                        hint: "clarify = уточнить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["уточнение", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m013",
                        front: "Как сказать, что вы заняты?",
                        back: "I'm tied up at the moment.",
                        phonetic: "aɪm taɪd ʌp æt ðə ˈməʊmənt",
                        example: "I'm tied up at the moment, but I can help you later.",
                        hint: "tied up = занят",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["занятость", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m014",
                        front: "Как сказать, что нужно больше времени?",
                        back: "I need more time to complete this.",
                        phonetic: "aɪ niːd mɔː taɪm tuː kəmˈpliːt ðɪs",
                        example: "I need more time to complete this. Can we extend the deadline?",
                        hint: "need more time = нужно больше времени",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["время", "встречи"]
                    ),
                    Flashcard(
                        id: "card_m015",
                        front: "Как сказать, что все идет по плану?",
                        back: "Everything is on track.",
                        phonetic: "ˈevrɪθɪŋ ɪz ɒn træk",
                        example: "Everything is on track. We're meeting all our milestones.",
                        hint: "on track = по плану",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["прогресс", "встречи"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 20,
                totalTerms: 15,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            ),
            
            // Email переписка
            FlashcardSet(
                id: "default_emails_001",
                title: "Основы деловой переписки",
                description: "Типичные фразы для профессиональной email-коммуникации",
                workScenario: .emails,
                difficulty: .beginner,
                cards: [
                    Flashcard(
                        id: "card_e001",
                        front: "Как начать формальное письмо?",
                        back: "Dear [Name], I hope this email finds you well.",
                        phonetic: "dɪə neɪm aɪ həʊp ðɪs ˈiːmeɪl faɪndz juː wel",
                        example: "Dear Mr. Smith, I hope this email finds you well.",
                        hint: "Используйте формальное приветствие для деловых писем",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "приветствие", "формальное"]
                    ),
                    Flashcard(
                        id: "card_e002",
                        front: "Как указать цель письма?",
                        back: "I'm writing to follow up on...",
                        phonetic: "aɪm ˈraɪtɪŋ tuː fɒləʊ ʌp ɒn",
                        example: "I'm writing to follow up on our conversation from yesterday.",
                        hint: "follow up = продолжить, уточнить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "цель"]
                    ),
                    Flashcard(
                        id: "card_e003",
                        front: "Как попросить информацию?",
                        back: "Could you please provide more details?",
                        phonetic: "kʊd juː pliːz prəˈvaɪd mɔː ˈdiːteɪlz",
                        example: "Could you please provide more details about the project timeline?",
                        hint: "provide = предоставить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "запрос"]
                    ),
                    Flashcard(
                        id: "card_e004",
                        front: "Как закончить письмо вежливо?",
                        back: "Looking forward to hearing from you.",
                        phonetic: "ˈlʊkɪŋ ˈfɔːwəd tuː ˈhɪərɪŋ frɒm juː",
                        example: "Thank you for your time. Looking forward to hearing from you.",
                        hint: "Стандартная фраза для завершения",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "завершение"]
                    ),
                    Flashcard(
                        id: "card_e005",
                        front: "Как приложить файл в письме?",
                        back: "Please find attached...",
                        phonetic: "pliːz faɪnd əˈtætʃt",
                        example: "Please find attached the report you requested.",
                        hint: "attached = прикрепленный",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "вложения"]
                    ),
                    Flashcard(
                        id: "card_e006",
                        front: "Как ответить на письмо?",
                        back: "Thank you for your email.",
                        phonetic: "θæŋk juː fɔː jɔː ˈiːmeɪl",
                        example: "Thank you for your email. I'll get back to you soon.",
                        hint: "Стандартное начало ответа",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "ответ"]
                    ),
                    Flashcard(
                        id: "card_e007",
                        front: "Как извиниться за задержку ответа?",
                        back: "Sorry for the delayed response.",
                        phonetic: "ˈsɒri fɔː ðə dɪˈlaɪd rɪˈspɒns",
                        example: "Sorry for the delayed response. I've been very busy lately.",
                        hint: "delayed = задержанный",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "извинения"]
                    ),
                    Flashcard(
                        id: "card_e008",
                        front: "Как подтвердить получение письма?",
                        back: "I received your email.",
                        phonetic: "aɪ rɪˈsiːvd jɔː ˈiːmeɪl",
                        example: "I received your email and will review it shortly.",
                        hint: "received = получил",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "подтверждение"]
                    ),
                    Flashcard(
                        id: "card_e009",
                        front: "Как запросить встречу по email?",
                        back: "Would you be available for a meeting?",
                        phonetic: "wʊd juː biː əˈveɪləbəl fɔː ə ˈmiːtɪŋ",
                        example: "Would you be available for a meeting next Tuesday?",
                        hint: "available = доступен",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "встреча"]
                    ),
                    Flashcard(
                        id: "card_e010",
                        front: "Как предложить альтернативу?",
                        back: "Alternatively, we could...",
                        phonetic: "ɔːlˈtɜːnətɪvli wiː kʊd",
                        example: "Alternatively, we could schedule the meeting for next week.",
                        hint: "alternatively = альтернативно",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "предложение"]
                    ),
                    Flashcard(
                        id: "card_e011",
                        front: "Как попросить подтверждение?",
                        back: "Please confirm if this works for you.",
                        phonetic: "pliːz kənˈfɜːm ɪf ðɪs wɜːks fɔː juː",
                        example: "Please confirm if this works for you.",
                        hint: "confirm = подтвердить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "подтверждение"]
                    ),
                    Flashcard(
                        id: "card_e012",
                        front: "Как выразить благодарность в конце письма?",
                        back: "Thank you for your time and consideration.",
                        phonetic: "θæŋk juː fɔː jɔː taɪm ænd kənˌsɪdəˈreɪʃən",
                        example: "Thank you for your time and consideration. Best regards.",
                        hint: "consideration = рассмотрение",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "благодарность"]
                    ),
                    Flashcard(
                        id: "card_e013",
                        front: "Как переслать письмо?",
                        back: "I'm forwarding this email to you.",
                        phonetic: "aɪm ˈfɔːwədɪŋ ðɪs ˈiːmeɪl tuː juː",
                        example: "I'm forwarding this email to you for your review.",
                        hint: "forwarding = пересылаю",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "пересылка"]
                    ),
                    Flashcard(
                        id: "card_e014",
                        front: "Как указать тему письма?",
                        back: "Regarding your inquiry about...",
                        phonetic: "rɪˈɡɑːdɪŋ jɔː ɪnˈkwaɪəri əˈbaʊt",
                        example: "Regarding your inquiry about the project timeline...",
                        hint: "regarding = относительно",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "тема"]
                    ),
                    Flashcard(
                        id: "card_e015",
                        front: "Как предложить помощь?",
                        back: "Please let me know if you need any assistance.",
                        phonetic: "pliːz let miː nəʊ ɪf juː niːd ˈeni əˈsɪstəns",
                        example: "Please let me know if you need any assistance with this matter.",
                        hint: "assistance = помощь",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["email", "помощь"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 25,
                totalTerms: 15,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            ),
            
            // Презентации
            FlashcardSet(
                id: "default_presentations_001",
                title: "Презентации и выступления",
                description: "Фразы для эффективных бизнес-презентаций",
                workScenario: .presentations,
                difficulty: .intermediate,
                cards: [
                    Flashcard(
                        id: "card_p001",
                        front: "Как начать презентацию?",
                        back: "Good morning, everyone. Thank you for being here today.",
                        phonetic: "ɡʊd ˈmɔːnɪŋ ˈevrɪwʌn θæŋk juː fɔː ˈbiːɪŋ hɪə təˈdeɪ",
                        example: "Good morning, everyone. Thank you for being here today. Let's get started.",
                        hint: "Стандартное начало презентации",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "начало"]
                    ),
                    Flashcard(
                        id: "card_p002",
                        front: "Как перейти к следующему слайду?",
                        back: "Moving on to the next slide...",
                        phonetic: "ˈmuːvɪŋ ɒn tuː ðə nekst slaɪd",
                        example: "Moving on to the next slide, I'd like to discuss our sales figures.",
                        hint: "moving on = переходя к",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "переходы"]
                    ),
                    Flashcard(
                        id: "card_p003",
                        front: "Как подчеркнуть важный момент?",
                        back: "I'd like to emphasize that...",
                        phonetic: "aɪd laɪk tuː ˈemfəsaɪz ðæt",
                        example: "I'd like to emphasize that this is our top priority.",
                        hint: "emphasize = подчеркнуть",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "акцент"]
                    ),
                    Flashcard(
                        id: "card_p004",
                        front: "Как ответить на вопрос?",
                        back: "That's a great question. Let me address that.",
                        phonetic: "ðæts ə ɡreɪt ˈkwestʃən let miː əˈdres ðæt",
                        example: "That's a great question. Let me address that point.",
                        hint: "address = рассмотреть, ответить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "вопросы"]
                    ),
                    Flashcard(
                        id: "card_p005",
                        front: "Как завершить презентацию?",
                        back: "To summarize, I'd like to highlight...",
                        phonetic: "tuː ˈsʌməraɪz aɪd laɪk tuː ˈhaɪlaɪt",
                        example: "To summarize, I'd like to highlight three key points.",
                        hint: "summarize = резюмировать",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "завершение"]
                    ),
                    Flashcard(
                        id: "card_p006",
                        front: "Как представить тему презентации?",
                        back: "Today I'd like to talk about...",
                        phonetic: "təˈdeɪ aɪd laɪk tuː tɔːk əˈbaʊt",
                        example: "Today I'd like to talk about our quarterly results.",
                        hint: "talk about = говорить о",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "введение"]
                    ),
                    Flashcard(
                        id: "card_p007",
                        front: "Как показать график или диаграмму?",
                        back: "As you can see on this slide...",
                        phonetic: "æz juː kæn siː ɒn ðɪs slaɪd",
                        example: "As you can see on this slide, our sales have increased by 20%.",
                        hint: "as you can see = как вы видите",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "визуализация"]
                    ),
                    Flashcard(
                        id: "card_p008",
                        front: "Как привлечь внимание?",
                        back: "Let me draw your attention to...",
                        phonetic: "let miː drɔː jɔː əˈtenʃən tuː",
                        example: "Let me draw your attention to this important point.",
                        hint: "draw attention = привлечь внимание",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "акцент"]
                    ),
                    Flashcard(
                        id: "card_p009",
                        front: "Как сказать, что вы не знаете ответа?",
                        back: "That's a good question. Let me get back to you on that.",
                        phonetic: "ðæts ə ɡʊd ˈkwestʃən let miː ɡet bæk tuː juː ɒn ðæt",
                        example: "That's a good question. Let me get back to you on that after the presentation.",
                        hint: "get back to = вернуться к",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "вопросы"]
                    ),
                    Flashcard(
                        id: "card_p010",
                        front: "Как перейти к следующей теме?",
                        back: "Now let's turn to...",
                        phonetic: "naʊ lets tɜːn tuː",
                        example: "Now let's turn to our marketing strategy.",
                        hint: "turn to = перейти к",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "переходы"]
                    ),
                    Flashcard(
                        id: "card_p011",
                        front: "Как сказать, что это важно?",
                        back: "This is crucial for our success.",
                        phonetic: "ðɪs ɪz ˈkruːʃəl fɔː ˈaʊə səkˈses",
                        example: "This is crucial for our success. We need to focus on this.",
                        hint: "crucial = критический",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "важность"]
                    ),
                    Flashcard(
                        id: "card_p012",
                        front: "Как попросить вопросы в конце?",
                        back: "I'd be happy to answer any questions.",
                        phonetic: "aɪd biː ˈhæpi tuː ˈɑːnsə ˈeni ˈkwestʃənz",
                        example: "I'd be happy to answer any questions you might have.",
                        hint: "answer questions = отвечать на вопросы",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "вопросы"]
                    ),
                    Flashcard(
                        id: "card_p013",
                        front: "Как сказать спасибо в конце презентации?",
                        back: "Thank you for your attention.",
                        phonetic: "θæŋk juː fɔː jɔː əˈtenʃən",
                        example: "Thank you for your attention. I'm open to questions.",
                        hint: "attention = внимание",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "завершение"]
                    ),
                    Flashcard(
                        id: "card_p014",
                        front: "Как объяснить сложную концепцию?",
                        back: "Let me break this down for you.",
                        phonetic: "let miː breɪk ðɪs daʊn fɔː juː",
                        example: "Let me break this down for you step by step.",
                        hint: "break down = разбить на части",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["презентации", "объяснение"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 30,
                totalTerms: 14,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            ),
            
            // Собеседования
            FlashcardSet(
                id: "default_interviews_001",
                title: "Собеседования при приеме на работу",
                description: "Ключевые фразы для успешных собеседований",
                workScenario: .jobInterviews,
                difficulty: .intermediate,
                cards: [
                    Flashcard(
                        id: "card_i001",
                        front: "Как представиться на собеседовании?",
                        back: "Thank you for this opportunity. I'm excited to be here.",
                        phonetic: "θæŋk juː fɔː ðɪs ˌɒpəˈtjuːnɪti aɪm ɪkˈsaɪtɪd tuː biː hɪə",
                        example: "Thank you for this opportunity. I'm excited to be here and learn more about the role.",
                        hint: "opportunity = возможность",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "начало"]
                    ),
                    Flashcard(
                        id: "card_i002",
                        front: "Как рассказать о своем опыте?",
                        back: "In my previous role, I was responsible for...",
                        phonetic: "ɪn maɪ ˈpriːviəs rəʊl aɪ wɒz rɪˈspɒnsəbəl fɔː",
                        example: "In my previous role, I was responsible for managing a team of five.",
                        hint: "responsible for = отвечал за",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "опыт"]
                    ),
                    Flashcard(
                        id: "card_i003",
                        front: "Как объяснить причину смены работы?",
                        back: "I'm looking for new challenges and growth opportunities.",
                        phonetic: "aɪm ˈlʊkɪŋ fɔː njuː ˈtʃælɪndʒɪz ænd ɡrəʊθ ˌɒpəˈtjuːnɪtiz",
                        example: "I'm looking for new challenges and growth opportunities in my career.",
                        hint: "challenges = вызовы, задачи",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "мотивация"]
                    ),
                    Flashcard(
                        id: "card_i004",
                        front: "Как спросить о зарплате?",
                        back: "Could you tell me more about the compensation package?",
                        phonetic: "kʊd juː tel miː mɔː əˈbaʊt ðə ˌkɒmpənˈseɪʃən ˈpækɪdʒ",
                        example: "Could you tell me more about the compensation package?",
                        hint: "compensation = компенсация, зарплата",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "зарплата"]
                    ),
                    Flashcard(
                        id: "card_i005",
                        front: "Как завершить собеседование?",
                        back: "Thank you for your time. I look forward to hearing from you.",
                        phonetic: "θæŋk juː fɔː jɔː taɪm aɪ lʊk ˈfɔːwəd tuː ˈhɪərɪŋ frɒm juː",
                        example: "Thank you for your time. I look forward to hearing from you soon.",
                        hint: "Стандартное завершение",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "завершение"]
                    ),
                    Flashcard(
                        id: "card_i006",
                        front: "Как рассказать о своих сильных сторонах?",
                        back: "My strengths include...",
                        phonetic: "maɪ streŋθs ɪnˈkluːd",
                        example: "My strengths include problem-solving and teamwork.",
                        hint: "strengths = сильные стороны",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "сильные стороны"]
                    ),
                    Flashcard(
                        id: "card_i007",
                        front: "Как ответить на вопрос о слабостях?",
                        back: "I'm working on improving my...",
                        phonetic: "aɪm ˈwɜːkɪŋ ɒn ɪmˈpruːvɪŋ maɪ",
                        example: "I'm working on improving my public speaking skills.",
                        hint: "working on = работаю над",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "слабые стороны"]
                    ),
                    Flashcard(
                        id: "card_i008",
                        front: "Как сказать, почему вы хотите эту работу?",
                        back: "I'm interested in this position because...",
                        phonetic: "aɪm ˈɪntrəstɪd ɪn ðɪs pəˈzɪʃən bɪˈkɒz",
                        example: "I'm interested in this position because it aligns with my career goals.",
                        hint: "interested = заинтересован",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "мотивация"]
                    ),
                    Flashcard(
                        id: "card_i009",
                        front: "Как спросить о компании?",
                        back: "What do you like most about working here?",
                        phonetic: "wɒt duː juː laɪk məʊst əˈbaʊt ˈwɜːkɪŋ hɪə",
                        example: "What do you like most about working here?",
                        hint: "like most = нравится больше всего",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "вопросы"]
                    ),
                    Flashcard(
                        id: "card_i010",
                        front: "Как сказать о своих достижениях?",
                        back: "I successfully completed...",
                        phonetic: "aɪ səkˈsesfʊli kəmˈpliːtɪd",
                        example: "I successfully completed several projects that increased sales by 30%.",
                        hint: "successfully = успешно",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "достижения"]
                    ),
                    Flashcard(
                        id: "card_i011",
                        front: "Как сказать о своей команде?",
                        back: "I worked well in a team environment.",
                        phonetic: "aɪ wɜːkt wel ɪn ə tiːm ɪnˈvaɪrənmənt",
                        example: "I worked well in a team environment and collaborated effectively.",
                        hint: "team environment = командная среда",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "команда"]
                    ),
                    Flashcard(
                        id: "card_i012",
                        front: "Как спросить о следующих шагах?",
                        back: "What are the next steps in the hiring process?",
                        phonetic: "wɒt ɑː ðə nekst steps ɪn ðə ˈhaɪərɪŋ ˈprəʊses",
                        example: "What are the next steps in the hiring process?",
                        hint: "next steps = следующие шаги",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "процесс"]
                    ),
                    Flashcard(
                        id: "card_i013",
                        front: "Как сказать о готовности начать?",
                        back: "I'm available to start immediately.",
                        phonetic: "aɪm əˈveɪləbəl tuː stɑːt ɪˈmiːdiətli",
                        example: "I'm available to start immediately if needed.",
                        hint: "available = доступен",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "готовность"]
                    ),
                    Flashcard(
                        id: "card_i014",
                        front: "Как сказать о своих навыках?",
                        back: "I have experience with...",
                        phonetic: "aɪ hæv ɪkˈspɪəriəns wɪð",
                        example: "I have experience with project management and data analysis.",
                        hint: "experience = опыт",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["собеседования", "навыки"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 30,
                totalTerms: 14,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            ),
            
            // Переговоры
            FlashcardSet(
                id: "default_negotiations_001",
                title: "Деловые переговоры",
                description: "Фразы для успешных бизнес-переговоров",
                workScenario: .negotiations,
                difficulty: .advanced,
                cards: [
                    Flashcard(
                        id: "card_n001",
                        front: "Как предложить компромисс?",
                        back: "I think we can find a middle ground here.",
                        phonetic: "aɪ θɪŋk wiː kæn faɪnd ə ˈmɪdəl ɡraʊnd hɪə",
                        example: "I think we can find a middle ground here that works for both parties.",
                        hint: "middle ground = компромисс",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "компромисс"]
                    ),
                    Flashcard(
                        id: "card_n002",
                        front: "Как выразить несогласие вежливо?",
                        back: "I see your point, but I have some concerns.",
                        phonetic: "aɪ siː jɔː pɔɪnt bʌt aɪ hæv sʌm kənˈsɜːnz",
                        example: "I see your point, but I have some concerns about the timeline.",
                        hint: "concerns = опасения",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "несогласие"]
                    ),
                    Flashcard(
                        id: "card_n003",
                        front: "Как запросить время на обдумывание?",
                        back: "I'd like to take some time to consider this.",
                        phonetic: "aɪd laɪk tuː teɪk sʌm taɪm tuː kənˈsɪdə ðɪs",
                        example: "I'd like to take some time to consider this proposal.",
                        hint: "consider = обдумать",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "время"]
                    ),
                    Flashcard(
                        id: "card_n004",
                        front: "Как согласиться на условия?",
                        back: "That sounds reasonable. I can agree to that.",
                        phonetic: "ðæt saʊndz ˈriːzənəbəl aɪ kæn əˈɡriː tuː ðæt",
                        example: "That sounds reasonable. I can agree to those terms.",
                        hint: "reasonable = разумный",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "согласие"]
                    ),
                    Flashcard(
                        id: "card_n005",
                        front: "Как завершить переговоры?",
                        back: "Let's move forward with this agreement.",
                        phonetic: "lets muːv ˈfɔːwəd wɪð ðɪs əˈɡriːmənt",
                        example: "Let's move forward with this agreement. I'll prepare the contract.",
                        hint: "move forward = продвигаться вперед",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "завершение"]
                    ),
                    Flashcard(
                        id: "card_n006",
                        front: "Как предложить встречу для переговоров?",
                        back: "I'd like to schedule a meeting to discuss the terms.",
                        phonetic: "aɪd laɪk tuː ˈʃedjuːl ə ˈmiːtɪŋ tuː dɪˈskʌs ðə tɜːmz",
                        example: "I'd like to schedule a meeting to discuss the terms in detail.",
                        hint: "schedule = назначить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "встреча"]
                    ),
                    Flashcard(
                        id: "card_n007",
                        front: "Как сказать, что цена слишком высокая?",
                        back: "The price seems a bit high.",
                        phonetic: "ðə praɪs siːmz ə bɪt haɪ",
                        example: "The price seems a bit high. Can we negotiate?",
                        hint: "seems = кажется",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "цена"]
                    ),
                    Flashcard(
                        id: "card_n008",
                        front: "Как предложить скидку?",
                        back: "We could offer you a discount.",
                        phonetic: "wiː kʊd ˈɒfə juː ə ˈdɪskaʊnt",
                        example: "We could offer you a discount if you order in bulk.",
                        hint: "discount = скидка",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "скидка"]
                    ),
                    Flashcard(
                        id: "card_n009",
                        front: "Как сказать, что нужно подумать?",
                        back: "I need to think this over.",
                        phonetic: "aɪ niːd tuː θɪŋk ðɪs ˈəʊvə",
                        example: "I need to think this over before making a decision.",
                        hint: "think over = обдумать",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "размышление"]
                    ),
                    Flashcard(
                        id: "card_n010",
                        front: "Как выразить готовность к компромиссу?",
                        back: "I'm willing to meet you halfway.",
                        phonetic: "aɪm ˈwɪlɪŋ tuː miːt juː ˈhɑːfweɪ",
                        example: "I'm willing to meet you halfway on this issue.",
                        hint: "meet halfway = встретиться посередине",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "компромисс"]
                    ),
                    Flashcard(
                        id: "card_n011",
                        front: "Как сказать о своих условиях?",
                        back: "Our terms are...",
                        phonetic: "ˈaʊə tɜːmz ɑː",
                        example: "Our terms are flexible, and we're open to discussion.",
                        hint: "terms = условия",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "условия"]
                    ),
                    Flashcard(
                        id: "card_n012",
                        front: "Как сказать, что предложение не подходит?",
                        back: "I'm afraid that doesn't work for us.",
                        phonetic: "aɪm əˈfreɪd ðæt dʌznt wɜːk fɔː ʌs",
                        example: "I'm afraid that doesn't work for us. Can we find another solution?",
                        hint: "doesn't work = не подходит",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "отказ"]
                    ),
                    Flashcard(
                        id: "card_n013",
                        front: "Как предложить альтернативное решение?",
                        back: "What if we tried a different approach?",
                        phonetic: "wɒt ɪf wiː traɪd ə ˈdɪfərənt əˈprəʊtʃ",
                        example: "What if we tried a different approach? Maybe we could split the cost.",
                        hint: "different approach = другой подход",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "альтернатива"]
                    ),
                    Flashcard(
                        id: "card_n014",
                        front: "Как подтвердить соглашение?",
                        back: "We have a deal.",
                        phonetic: "wiː hæv ə diːl",
                        example: "We have a deal. I'll send you the contract tomorrow.",
                        hint: "deal = сделка",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["переговоры", "соглашение"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 35,
                totalTerms: 14,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            ),
            
            // Small Talk
            FlashcardSet(
                id: "default_smalltalk_001",
                title: "Неформальное общение",
                description: "Фразы для светской беседы в офисе",
                workScenario: .smallTalk,
                difficulty: .beginner,
                cards: [
                    Flashcard(
                        id: "card_s001",
                        front: "Как спросить о выходных?",
                        back: "How was your weekend?",
                        phonetic: "haʊ wɒz jɔː ˈwiːkend",
                        example: "How was your weekend? Did you do anything interesting?",
                        hint: "weekend = выходные",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "выходные"]
                    ),
                    Flashcard(
                        id: "card_s002",
                        front: "Как спросить о планах?",
                        back: "What are you up to this weekend?",
                        phonetic: "wɒt ɑː juː ʌp tuː ðɪs ˈwiːkend",
                        example: "What are you up to this weekend? Any plans?",
                        hint: "up to = заниматься",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "планы"]
                    ),
                    Flashcard(
                        id: "card_s003",
                        front: "Как прокомментировать погоду?",
                        back: "Nice weather today, isn't it?",
                        phonetic: "naɪs ˈweðə təˈdeɪ ˈɪznt ɪt",
                        example: "Nice weather today, isn't it? Perfect for a walk.",
                        hint: "Стандартная фраза о погоде",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "погода"]
                    ),
                    Flashcard(
                        id: "card_s004",
                        front: "Как спросить о самочувствии?",
                        back: "How are things going?",
                        phonetic: "haʊ ɑː θɪŋz ˈɡəʊɪŋ",
                        example: "How are things going? Everything alright?",
                        hint: "things = дела",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "самочувствие"]
                    ),
                    Flashcard(
                        id: "card_s005",
                        front: "Как вежливо закончить разговор?",
                        back: "Well, I should get going. See you later!",
                        phonetic: "wel aɪ ʃʊd ɡet ˈɡəʊɪŋ siː juː ˈleɪtə",
                        example: "Well, I should get going. See you later!",
                        hint: "get going = уходить",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "завершение"]
                    ),
                    Flashcard(
                        id: "card_s006",
                        front: "Как спросить, как дела?",
                        back: "How's everything going?",
                        phonetic: "haʊz ˈevrɪθɪŋ ˈɡəʊɪŋ",
                        example: "How's everything going? Busy week?",
                        hint: "everything = все",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "приветствие"]
                    ),
                    Flashcard(
                        id: "card_s007",
                        front: "Как ответить на вопрос о делах?",
                        back: "Things are going well, thanks.",
                        phonetic: "θɪŋz ɑː ˈɡəʊɪŋ wel θæŋks",
                        example: "Things are going well, thanks. How about you?",
                        hint: "going well = идут хорошо",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "ответ"]
                    ),
                    Flashcard(
                        id: "card_s008",
                        front: "Как спросить о работе?",
                        back: "How's work treating you?",
                        phonetic: "haʊz wɜːk ˈtriːtɪŋ juː",
                        example: "How's work treating you? Still busy?",
                        hint: "treating = обращается",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "работа"]
                    ),
                    Flashcard(
                        id: "card_s009",
                        front: "Как сказать, что вы заняты?",
                        back: "I've been swamped lately.",
                        phonetic: "aɪv biːn swɒmpt ˈleɪtli",
                        example: "I've been swamped lately with deadlines.",
                        hint: "swamped = завален работой",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "занятость"]
                    ),
                    Flashcard(
                        id: "card_s010",
                        front: "Как спросить о планах на вечер?",
                        back: "Any plans for tonight?",
                        phonetic: "ˈeni plænz fɔː təˈnaɪt",
                        example: "Any plans for tonight? Going out?",
                        hint: "plans = планы",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "планы"]
                    ),
                    Flashcard(
                        id: "card_s011",
                        front: "Как сказать, что вы устали?",
                        back: "I'm exhausted after this week.",
                        phonetic: "aɪm ɪɡˈzɔːstɪd ˈɑːftə ðɪs wiːk",
                        example: "I'm exhausted after this week. Need a break.",
                        hint: "exhausted = измотан",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "усталость"]
                    ),
                    Flashcard(
                        id: "card_s012",
                        front: "Как пожелать хорошего дня?",
                        back: "Have a great day!",
                        phonetic: "hæv ə ɡreɪt deɪ",
                        example: "Have a great day! See you tomorrow.",
                        hint: "great day = отличный день",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "прощание"]
                    ),
                    Flashcard(
                        id: "card_s013",
                        front: "Как спросить о здоровье?",
                        back: "How have you been?",
                        phonetic: "haʊ hæv juː biːn",
                        example: "How have you been? Haven't seen you in a while.",
                        hint: "been = был",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "здоровье"]
                    ),
                    Flashcard(
                        id: "card_s014",
                        front: "Как сказать, что рады видеть?",
                        back: "It's good to see you!",
                        phonetic: "ɪts ɡʊd tuː siː juː",
                        example: "It's good to see you! How have you been?",
                        hint: "good to see = хорошо видеть",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["small talk", "приветствие"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 20,
                totalTerms: 14,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            ),
            
            // Базовый словарь деловых терминов
            FlashcardSet(
                id: "default_vocabulary_001",
                title: "Базовый деловой словарь",
                description: "Основные слова и выражения для делового общения",
                workScenario: .projectManagement,
                difficulty: .beginner,
                cards: [
                    Flashcard(
                        id: "card_v001",
                        front: "Как перевести 'дедлайн'?",
                        back: "deadline",
                        phonetic: "ˈdedlaɪn",
                        example: "The deadline for this project is Friday.",
                        hint: "deadline = крайний срок",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "дедлайн"]
                    ),
                    Flashcard(
                        id: "card_v002",
                        front: "Как перевести 'встреча'?",
                        back: "meeting",
                        phonetic: "ˈmiːtɪŋ",
                        example: "We have a meeting at 3 PM.",
                        hint: "meeting = встреча",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "встреча"]
                    ),
                    Flashcard(
                        id: "card_v003",
                        front: "Как перевести 'проект'?",
                        back: "project",
                        phonetic: "ˈprɒdʒekt",
                        example: "This project is very important for our company.",
                        hint: "project = проект",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "проект"]
                    ),
                    Flashcard(
                        id: "card_v004",
                        front: "Как перевести 'задача'?",
                        back: "task",
                        phonetic: "tɑːsk",
                        example: "I need to complete this task by tomorrow.",
                        hint: "task = задача",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "задача"]
                    ),
                    Flashcard(
                        id: "card_v005",
                        front: "Как перевести 'отчет'?",
                        back: "report",
                        phonetic: "rɪˈpɔːt",
                        example: "Please send me the monthly report.",
                        hint: "report = отчет",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "отчет"]
                    ),
                    Flashcard(
                        id: "card_v006",
                        front: "Как перевести 'клиент'?",
                        back: "client",
                        phonetic: "ˈklaɪənt",
                        example: "Our client is very satisfied with the service.",
                        hint: "client = клиент",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "клиент"]
                    ),
                    Flashcard(
                        id: "card_v007",
                        front: "Как перевести 'коллега'?",
                        back: "colleague",
                        phonetic: "ˈkɒliːɡ",
                        example: "My colleague will help you with this.",
                        hint: "colleague = коллега",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "коллега"]
                    ),
                    Flashcard(
                        id: "card_v008",
                        front: "Как перевести 'бюджет'?",
                        back: "budget",
                        phonetic: "ˈbʌdʒɪt",
                        example: "We need to stay within the budget.",
                        hint: "budget = бюджет",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "бюджет"]
                    ),
                    Flashcard(
                        id: "card_v009",
                        front: "Как перевести 'презентация'?",
                        back: "presentation",
                        phonetic: "ˌprezənˈteɪʃən",
                        example: "I'm preparing a presentation for the meeting.",
                        hint: "presentation = презентация",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "презентация"]
                    ),
                    Flashcard(
                        id: "card_v010",
                        front: "Как перевести 'контракт'?",
                        back: "contract",
                        phonetic: "ˈkɒntrækt",
                        example: "We signed a new contract yesterday.",
                        hint: "contract = контракт",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "контракт"]
                    ),
                    Flashcard(
                        id: "card_v011",
                        front: "Как перевести 'переговоры'?",
                        back: "negotiation",
                        phonetic: "nɪˌɡəʊʃiˈeɪʃən",
                        example: "The negotiation was successful.",
                        hint: "negotiation = переговоры",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "переговоры"]
                    ),
                    Flashcard(
                        id: "card_v012",
                        front: "Как перевести 'соглашение'?",
                        back: "agreement",
                        phonetic: "əˈɡriːmənt",
                        example: "We reached an agreement on the terms.",
                        hint: "agreement = соглашение",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "соглашение"]
                    ),
                    Flashcard(
                        id: "card_v013",
                        front: "Как перевести 'встреча один на один'?",
                        back: "one-on-one",
                        phonetic: "wʌn ɒn wʌn",
                        example: "Let's schedule a one-on-one meeting.",
                        hint: "one-on-one = один на один",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "встреча"]
                    ),
                    Flashcard(
                        id: "card_v014",
                        front: "Как перевести 'обратная связь'?",
                        back: "feedback",
                        phonetic: "ˈfiːdbæk",
                        example: "I'd appreciate your feedback on this proposal.",
                        hint: "feedback = обратная связь",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "обратная связь"]
                    ),
                    Flashcard(
                        id: "card_v015",
                        front: "Как перевести 'цель'?",
                        back: "goal",
                        phonetic: "ɡəʊl",
                        example: "Our goal is to increase sales by 20%.",
                        hint: "goal = цель",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "цель"]
                    ),
                    Flashcard(
                        id: "card_v016",
                        front: "Как перевести 'стратегия'?",
                        back: "strategy",
                        phonetic: "ˈstrætədʒi",
                        example: "We need to develop a new marketing strategy.",
                        hint: "strategy = стратегия",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "стратегия"]
                    ),
                    Flashcard(
                        id: "card_v017",
                        front: "Как перевести 'результат'?",
                        back: "result",
                        phonetic: "rɪˈzʌlt",
                        example: "The results exceeded our expectations.",
                        hint: "result = результат",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "результат"]
                    ),
                    Flashcard(
                        id: "card_v018",
                        front: "Как перевести 'достижение'?",
                        back: "achievement",
                        phonetic: "əˈtʃiːvmənt",
                        example: "This is a great achievement for our team.",
                        hint: "achievement = достижение",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "достижение"]
                    ),
                    Flashcard(
                        id: "card_v019",
                        front: "Как перевести 'команда'?",
                        back: "team",
                        phonetic: "tiːm",
                        example: "Our team works very well together.",
                        hint: "team = команда",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "команда"]
                    ),
                    Flashcard(
                        id: "card_v020",
                        front: "Как перевести 'руководитель'?",
                        back: "manager",
                        phonetic: "ˈmænɪdʒə",
                        example: "I need to speak with my manager about this.",
                        hint: "manager = руководитель",
                        audioURL: nil,
                        imageURL: nil,
                        tags: ["словарь", "руководитель"]
                    )
                ],
                author: "BridgyAI",
                isPremium: false,
                averageStudyTime: 25,
                totalTerms: 20,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            )
        ]
    }
}


