//
//  APIBibleEndpointBuilding.swift
//  BibleTimeline
//

import Foundation

protocol APIBibleEndpointBuilding {
    func makePassageRequest(
        position: ReadingPosition,
        config: APIBibleConfig
    ) throws -> URLRequest

    func makePassageRequestById(
        passageId: String,
        config: APIBibleConfig
    ) throws -> URLRequest
}
