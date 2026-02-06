//
//  ChronologyItem.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

struct ChronologyItem: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let references: [ReferenceRange]
}
