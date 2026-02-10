//
//  ReferenceRange.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

struct ReferenceRange: Hashable, Codable {
    let book: String      // agora deve ser USFM (ex.: "MRK")
    let chapter: Int
    let verseStart: Int?
    let verseEnd: Int?
}
