import Foundation

enum DailyPromptProvider {
    static let prompts: [String] = [
        "Who made you smile today?",
        "What small moment brought you peace?",
        "What are you proud of this week?",
        "Who deserves a thank-you note?",
        "What beauty did you notice outdoors?",
        "What comfort are you grateful for at home?",
        "What skill are you glad you have?",
        "What made you laugh recently?",
        "What food or drink lifted your mood?",
        "What friendship means a lot to you?",
        "What family moment warmed your heart?",
        "What progress did you make on a goal?",
        "What book, song, or show inspired you?",
        "What kindness did you receive?",
        "What kindness did you give?",
        "What part of your health are you thankful for?",
        "What opportunity is ahead of you?",
        "What memory still makes you happy?",
        "What object in your room do you love?",
        "What habit is helping you grow?",
        "What surprised you in a good way?",
        "What lesson did a challenge teach you?",
        "What place do you feel safe in?",
        "What technology made life easier today?",
        "What pet or animal brought you joy?",
        "What weather felt pleasant today?",
        "What rest or sleep are you grateful for?",
        "What freedom do you value?",
        "What creativity did you express?",
        "What future dream excites you?"
    ]

    static var todayPrompt: String {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return prompts[day % prompts.count]
    }
}
