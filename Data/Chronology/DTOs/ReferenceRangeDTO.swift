//
//  ReferenceRangeDTO.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

struct ReferenceRangeDTO: Decodable, Hashable {
    let book: String
    let chapter: Int
    let verseStart: Int?
    let verseEnd: Int?
}
