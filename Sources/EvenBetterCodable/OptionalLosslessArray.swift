//
//  OptionalLosslessArray.swift
//
//
//  Created by apploft GmbH on 13.01.22.
//

import Foundation

// Like OptionalLossyArray, but returns an empty array if some element cannot be decoded.
@propertyWrapper
public struct OptionalLosslessArray<T> {
    public var wrappedValue: [T]

    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionalLosslessArray: Decodable where T: Decodable {
    private struct AnyDecodableValue: Decodable {}

    public init(from decoder: Decoder) throws {
        do {

            var container = try decoder.unkeyedContainer()

            var elements: [T] = []
            while !container.isAtEnd {
                let value = try container.decode(T.self)
                elements.append(value)
            }
            self.wrappedValue = elements

        } catch {
            self.wrappedValue = []
        }


    }
}

extension OptionalLosslessArray: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension OptionalLosslessArray: Equatable where T: Equatable { }
extension OptionalLosslessArray: Hashable where T: Hashable { }


extension KeyedDecodingContainer {

    public func decode<T: Decodable>(_ type: OptionalLosslessArray<T>.Type, forKey key: Key) throws -> OptionalLosslessArray<T> {
        (try? decodeIfPresent(type, forKey: key)) ?? OptionalLosslessArray<T>(wrappedValue: [])
    }

}
