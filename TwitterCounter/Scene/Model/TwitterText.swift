//
//  TwitterText.swift
//  TwitterCounter
//
//  Created by Ali Elsokary on 02/05/2024.
//

import Foundation

struct WeightRange {
    let range: ClosedRange<UInt32>
    let weight: Int
}

struct TwitterText {
    static func lengthOf(tweet: String) -> Int {
        let defaultWeight = 200
        let scale = 100
        let ranges = [
            WeightRange(range: 0...4351, weight: 100),
            WeightRange(range: 8192...8205, weight: 100),
            WeightRange(range: 8208...8223, weight: 100),
            WeightRange(range: 8242...8247, weight: 100)
        ]

        let (cleanText, urlLength) = cleanAndCountURLs(text: tweet)
        var weightedLength = urlLength * scale

        for char in cleanText.unicodeScalars {
            var weight = defaultWeight
            for item in ranges where item.range ~= char.value {
                weight = item.weight
                continue
            }
            weightedLength += weight
        }
        weightedLength /= scale
        return weightedLength
    }

    private static func cleanAndCountURLs(text: String) -> (String, Int) {
        var output = text
        var lenght = 0
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        matches.forEach {
            output = (text as NSString).replacingCharacters(in: $0.range, with: "")
            lenght += 23
        }
        return (output, lenght)
    }
}
