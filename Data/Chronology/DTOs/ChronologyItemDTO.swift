//
//  ChronologyItemDTO.swift
//  BibleTimeline
//
//  Created by Higor Lo Castro on 10/02/26.
//

import Foundation

struct ChronologyItemDTO: Decodable, Hashable {
    let id: String
    let section: String
    let order: Int
    let title: String
    let references: [ReferenceRangeDTO]
}
