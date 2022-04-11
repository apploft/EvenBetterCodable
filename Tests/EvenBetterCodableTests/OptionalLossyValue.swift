//
//  OptionalCodableValue.swift
//  
//
//  Created by apploft GmbH on 08.04.22.
//

import XCTest
import EvenBetterCodable

class OptionalLossyValueTests: XCTestCase {

    struct Fixture: Codable {
        @OptionalLossyValue var aDefaultStrategyIsOmitKey: Bool?
        @OptionalLossyValue(nilValueEncodingStrategy: .omitKey) var bOmitKeyNoValue: Bool? = nil
        @OptionalLossyValue(nilValueEncodingStrategy: .encodeKeyWithNullValue) var cEncodeNullNoValue: Bool? = nil
        @OptionalLossyValue(nilValueEncodingStrategy: .omitKey) var dOmitKeyHasValue: Bool? = true
        @OptionalLossyValue(nilValueEncodingStrategy: .encodeKeyWithNullValue) var eEncodeKeyHasValue: Bool? = false
    }

    func testEncodingStrategies() throws {
        let fixture = Fixture()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys // for testability

        let fixtureData = try encoder.encode(fixture)
        let jsonString = String(data: fixtureData, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"cEncodeNullNoValue\":null,\"dOmitKeyHasValue\":true,\"eEncodeKeyHasValue\":false}")
    }
}

