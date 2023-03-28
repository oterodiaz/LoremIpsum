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

class LipsumGenerator {
    private var dictionary = [Bigram: [String]]()

    struct Bigram: Hashable {
        let first:  String
        let second: String

        init(_ first: String, _ second: String) {
            self.first  = first
            self.second = second
        }
    }

    init(learnFrom text: String) {
        learn(from: text)
    }

    init(learnFrom texts: [String]) {
        for text in texts {
            learn(from: text)
        }
    }

    func reset() {
        dictionary.removeAll()
    }

    func learn(from text: String) {
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

    func generateText(withWords quantity: Int, beginWith firstKey: Bigram? = nil) -> String {
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
