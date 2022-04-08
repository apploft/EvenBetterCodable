//
//  OptionalLossyArray.swift
//
//
//  Created by apploft GmbH on 08.04.22.
//

import XCTest
import EvenBetterCodable

class OptionalLossyArrayTests: XCTestCase {

    struct Fixture: Codable {
        @OptionalLossyArray var aDefaultStrategyIsOmitKey: [String] = []
        @OptionalLossyArray(emptyArrayEncodingStrategy: .omitKey) var bOmitKeyNoValue: [String] = []
        @OptionalLossyArray(emptyArrayEncodingStrategy: .encodeKeyWithNullValue) var cEncodeNullNoValue: [String] = []
        @OptionalLossyArray(emptyArrayEncodingStrategy: .encodeKeyWithEmptyArray) var dEncodeEmptyNoValue: [String] = []

        @OptionalLossyArray(emptyArrayEncodingStrategy: .omitKey) var eOmitKeyHasValue: [String] = ["testing"]
        @OptionalLossyArray(emptyArrayEncodingStrategy: .encodeKeyWithNullValue) var fEncodeNullHasValue: [String] = ["purposes"]
        @OptionalLossyArray(emptyArrayEncodingStrategy: .encodeKeyWithEmptyArray) var gEncodeEmptyHasValue: [String] = ["only"]
    }

    func testEncodingStrategies() throws {
        let fixture = Fixture()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys // for testability

        let fixtureData = try encoder.encode(fixture)
        let jsonString = String(data: fixtureData, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"cEncodeNullNoValue\":null,\"dEncodeEmptyNoValue\":[],\"eOmitKeyHasValue\":[\"testing\"],\"fEncodeNullHasValue\":[\"purposes\"],\"gEncodeEmptyHasValue\":[\"only\"]}")
    }
}

