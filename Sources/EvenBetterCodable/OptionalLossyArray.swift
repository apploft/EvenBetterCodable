//
//  OptionalLossyArray.swift
//
//
//  Created by apploft GmbH on 26.11.21.
//

import Foundation

@propertyWrapper
public struct OptionalLossyArray<T> {
    public enum EmptyArrayEncodingStrategy {
        case omitKey
        case encodeKeyWithNullValue
        case encodeKeyWithEmptyArray
    }

    public var wrappedValue: [T]
    public var emptyArrayEncodingStrategy: EmptyArrayEncodingStrategy

    public init(wrappedValue: [T], emptyArrayEncodingStrategy: EmptyArrayEncodingStrategy = .omitKey) {
        self.wrappedValue = wrappedValue
        self.emptyArrayEncodingStrategy = emptyArrayEncodingStrategy
    }
}

extension OptionalLossyArray: Decodable where T: Decodable {
    private struct AnyDecodableValue: Decodable {}

    public init(from decoder: Decoder) throws {
        self.emptyArrayEncodingStrategy = .omitKey

        do {

            var container = try decoder.unkeyedContainer()

            var elements: [T] = []
            while !container.isAtEnd {
                do {
                    let value = try container.decode(T.self)
                    elements.append(value)
                } catch {
                    _ = try? container.decode(AnyDecodableValue.self)
                }
            }
            self.wrappedValue = elements

        } catch {
            self.wrappedValue = []
        }
    }
}

extension OptionalLossyArray: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}


extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ type: OptionalLossyArray<T>.Type, forKey key: Key) throws -> OptionalLossyArray<T> {
        (try? decodeIfPresent(type, forKey: key)) ?? OptionalLossyArray<T>(wrappedValue: [])
    }
}

/// Implements the selected EmptyArrayEncodingStrategy
extension KeyedEncodingContainer {
    public mutating func encode<T: Encodable>(_ value: OptionalLossyArray<T>, forKey key: Key) throws {
        if !value.wrappedValue.isEmpty {
            try encodeIfPresent(value, forKey: key)
        } else {
            switch value.emptyArrayEncodingStrategy {
            case .omitKey:
                break

            case .encodeKeyWithNullValue:
                try encodeNil(forKey: key)

            case .encodeKeyWithEmptyArray:
                try encodeIfPresent(value, forKey: key)
            }
        }
    }
}

extension OptionalLossyArray: Equatable where T: Equatable { }
extension OptionalLossyArray: Hashable where T: Hashable { }
