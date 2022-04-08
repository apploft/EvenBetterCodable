//
//  OptionalLosslessArray.swift
//
//
//  Created by apploft GmbH on 08.04.22.
//

import XCTest
import EvenBetterCodable

class OptionalLosslessArrayTests: XCTestCase {

    struct Fixture: Codable {
        @OptionalLosslessArray var aDefaultStrategyIsOmitKey: [String] = []
        @OptionalLosslessArray(emptyArrayEncodingStrategy: .omitKey) var bOmitKeyNoValue: [String] = []
        @OptionalLosslessArray(emptyArrayEncodingStrategy: .encodeKeyWithNullValue) var cEncodeNullNoValue: [String] = []
        @OptionalLosslessArray(emptyArrayEncodingStrategy: .encodeKeyWithEmptyArray) var dEncodeEmptyNoValue: [String] = []

        @OptionalLosslessArray(emptyArrayEncodingStrategy: .omitKey) var eOmitKeyHasValue: [String] = ["testing"]
        @OptionalLosslessArray(emptyArrayEncodingStrategy: .encodeKeyWithNullValue) var fEncodeNullHasValue: [String] = ["purposes"]
        @OptionalLosslessArray(emptyArrayEncodingStrategy: .encodeKeyWithEmptyArray) var gEncodeEmptyHasValue: [String] = ["only"]
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

