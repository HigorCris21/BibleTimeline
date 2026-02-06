//
//  ReferenceRange.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation


struct ReferenceRange: Hashable, Codable {
    let book: String
    let chapter: Int
    let verseStart: Int?
    let verseEnd: Int?
}

