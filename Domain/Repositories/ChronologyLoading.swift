//
//  ChronologyLoading.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

protocol ChronologyLoading {
    func loadChronology() async throws -> [ChronologyItem]
}
