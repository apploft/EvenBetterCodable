//
//  OptionalLosslessValue.swift
//
//
//  Created by apploft GmbH on 01.10.21.
//

import XCTest
import EvenBetterCodable


class OptionalLosslessValueTests: XCTestCase {
    struct Fixture: Codable {
        @OptionalLosslessValue var bool: Bool?
        @OptionalLosslessValue var string: String?
        @OptionalLosslessValue var int: Int?
        @OptionalLosslessValue var double: Double?
        @OptionalLosslessValue var nilValue: Int?
        @OptionalLosslessValue var missingKey: Double?
    }

    struct EncodingFixture: Codable {
        @OptionalLosslessValue var aDefaultStrategyIsOmitKey: Bool?
        @OptionalLosslessValue(nilValueEncodingStrategy: .omitKey) var bOmitKeyNoValue: Bool? = nil
        @OptionalLosslessValue(nilValueEncodingStrategy: .encodeKeyWithNullValue) var cEncodeNullNoValue: Bool? = nil
        @OptionalLosslessValue(nilValueEncodingStrategy: .omitKey) var dOmitKeyHasValue: Bool? = true
        @OptionalLosslessValue(nilValueEncodingStrategy: .encodeKeyWithNullValue) var eEncodeKeyHasValue: Bool? = false
    }

    func testDecodingMisalignedTypesFromJSONTraversesCorrectType() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "1", "double": "7.1", "nilValue": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.double, 7.1)
        XCTAssertEqual(fixture.nilValue, nil)
        XCTAssertEqual(fixture.missingKey, nil)
    }

    func testDecodingEncodedMisalignedTypesFromJSONDecodesCorrectTypes() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "7", "double": "7.1", "nilValue": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

        _fixture.bool = false
        _fixture.double = 3.14

        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, false)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 3.14)
        XCTAssertEqual(fixture.nilValue, nil)
        XCTAssertEqual(fixture.missingKey, nil)
    }

    func testEncodingAndDecodedExpectedTypes() throws {
        let jsonData = #"{ "bool": true, "string": "42", "int": 7, "double": 7.1, "nilValue": null }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 7.1)
        XCTAssertEqual(fixture.nilValue, nil)
        XCTAssertEqual(fixture.missingKey, nil)
    }

    func testEncodingStrategies() throws {
        let fixture = EncodingFixture()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys // for testability

        let fixtureData = try encoder.encode(fixture)
        let jsonString = String(data: fixtureData, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"cEncodeNullNoValue\":null,\"dOmitKeyHasValue\":true,\"eEncodeKeyHasValue\":false}")
    }
}
