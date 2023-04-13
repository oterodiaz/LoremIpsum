//
//  LipsumGenerator.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-20.
//

import Foundation

fileprivate extension String {
    var words: [String] {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .components(separatedBy: " ")
    }

    var endsWithStrongPunctuation: Bool {
        let strongPunctuation = CharacterSet(arrayLiteral: ".", "!", "?")
        return self.endsWith(strongPunctuation)
    }

    var endsWithAnyPunctuation: Bool {
        self.endsWith(.punctuationCharacters)
    }

    private func endsWith(_ set: CharacterSet) -> Bool {
        guard let lastCharacter = self.unicodeScalars.last else {
            return false
        }

        return set.contains(lastCharacter)
    }
}

fileprivate extension Dictionary {
    func contains(key: Key) -> Bool {
        self[key] != nil
    }
}

struct LipsumGenerator: Hashable, Equatable {
    private var dictionary: [Bigram: [String]] = [:]
    var beginWithLoremIpsum = true
    var unit: Unit = .paragraphs { didSet { amount = unit.defaultAmount } }
    @Bound var amount: Int

    init() {
        self.amount = unit.defaultAmount

        let loremIpsum  = Bundle.main.readFile("lorem-ipsum.txt")
        let liberPrimus = Bundle.main.readFile("liber-primus.txt")

        learn(from: loremIpsum)
        learn(from: liberPrimus)
    }

    static func == (lhs: LipsumGenerator, rhs: LipsumGenerator) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(beginWithLoremIpsum)
        hasher.combine(unit)
        hasher.combine(amount)
    }

    @propertyWrapper
    struct Bound {
        private var num = 0

        var wrappedValue: Int {
            get { num }
            set { num = min(max(newValue, Unit.minAmount), Unit.maxAmount) }
        }
    }

    enum Unit: CaseIterable {
        case paragraphs, words

        static let minAmount = 1
        static let maxAmount = 999

        var defaultAmount: Int {
            switch self {
            case .paragraphs:
                return 3
            case .words:
                return 50
            }
        }

        var name: String {
            name(of: self)
        }

        private func name(of variant: Unit) -> String {
            switch self {
            case .paragraphs:
                return "paragraphs"
            case .words:
                return "words"
            }
        }
    }

    private struct Bigram: Hashable {
        let first:  String
        let second: String

        init(_ first: String, _ second: String) {
            self.first  = first
            self.second = second
        }
    }

    mutating func learn(from text: String) {
        let words = text.words.filter { word in
            word.rangeOfCharacter(from: .alphanumerics) == nil ? false : true
        }

        guard words.count >= 3 else {
            return
        }

        for i in 0..<(words.count - 2) {
            let (key, value) = (Bigram(words[i], words[i + 1]), words[i + 2])
            dictionary[key, default: []].append(value)
        }
    }

    func generateText() -> String {
        let firstKey = beginWithLoremIpsum ? LipsumGenerator.Bigram("Lorem", "ipsum") : nil

        switch unit {
        case .words:
            return generateSentence(withWords: amount, beginWith: firstKey)
        case .paragraphs:
            var paragraphs: [String] = []
            var quantity: Int {
                Int.random(in: 30...70)
            }

            for paragraphIndex in 0..<amount {
                let firstKey = paragraphIndex == 0 ? firstKey : nil
                let paragraph = generateSentence(withWords: quantity, beginWith: firstKey)
                paragraphs.append(paragraph)
            }

            return paragraphs.joined(separator: "\n\n")
        }
    }

    private func generateSentence(withWords quantity: Int,
                                  beginWith firstKey: Bigram? = nil
    ) -> String {
        guard !dictionary.isEmpty else {
            fatalError("Not enough data to generate words. Has the dictionary been generated?")
        }

        guard quantity > 0 else {
            fatalError("Cannot generate \(quantity) words.")
        }

        var key = firstKey ?? dictionary.keys.randomElement()!
        var sentence = String()

        for wordIndex in 0..<quantity {
            var (currentWord, nextWord) = (key.first, key.second)
            currentWord = wordIndex == 0 ? currentWord.capitalized : " " + currentWord

            if sentence.endsWithStrongPunctuation {
                sentence.append(currentWord.capitalized)
            } else {
                sentence.append(currentWord)
            }

            if !dictionary.contains(key: key) {
                key = dictionary.keys.randomElement()!
            }

            let wordThatFollowsCurrentBigram = dictionary[key]!.randomElement()!
            key = Bigram(nextWord, wordThatFollowsCurrentBigram)
        }

        if sentence.endsWithAnyPunctuation {
            sentence.removeLast()
        }

        return sentence + "."
    }
}
