//
//  APIBibleError.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import Foundation

enum APIBibleError: Error, Equatable {
    case missingApiKey
    case missingBibleId
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
}
