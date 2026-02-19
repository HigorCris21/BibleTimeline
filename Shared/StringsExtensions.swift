//
//  StringsExtensions.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 19/02/26.
//

import Foundation

extension String {
    func strippingVerseNumbers() -> String {
        let pattern = #"\[\d+\]\s*"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return self }
        let range = NSRange(startIndex..., in: self)
        return regex.stringByReplacingMatches(in: self, range: range, withTemplate: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
