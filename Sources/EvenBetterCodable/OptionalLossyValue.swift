//
//  OptionalLossyValue.swift
//
//
//  Created by apploft GmbH on 02.02.22.
//


import Foundation

@propertyWrapper
public struct OptionalLossyValue<T> {
    public enum NilValueEncodingStrategy {
        case omitKey
        case encodeKeyWithNullValue
    }

    public var wrappedValue: T?
    public var nilValueEncodingStrategy: NilValueEncodingStrategy

    public init(wrappedValue: T, nilValueEncodingStrategy: NilValueEncodingStrategy = .omitKey) {
        self.wrappedValue = wrappedValue
        self.nilValueEncodingStrategy = nilValueEncodingStrategy
    }

    public init(wrappedValue: T?, nilValueEncodingStrategy: NilValueEncodingStrategy = .omitKey) {
        self.wrappedValue = wrappedValue
        self.nilValueEncodingStrategy = nilValueEncodingStrategy
    }
}

extension OptionalLossyValue: Decodable where T: Decodable  {
    public init(from decoder: Decoder) {
        self.nilValueEncodingStrategy = .omitKey

        
        do {
            self.wrappedValue = try T.init(from: decoder)
        } catch let error {
            print("Error decoding: \(String(describing: error))")
            self.wrappedValue = nil
            return
        }
    }
}

extension OptionalLossyValue: Encodable where T: Encodable  {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue?.encode(to: encoder)
    }
}

/// Handles decoding a key that is not present. Instead of throwing an error, a nil value is produced.
extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ type: OptionalLossyValue<T>.Type, forKey key: Key) throws -> OptionalLossyValue<T> {
        (try? decodeIfPresent(type, forKey: key)) ?? OptionalLossyValue<T>(wrappedValue: nil)
    }

}

/// Implements the selected NilValueEncodingStrategy
extension KeyedEncodingContainer {
    public mutating func encode<T: Encodable>(_ value: OptionalLossyValue<T>, forKey key: Key) throws {
        if value.wrappedValue != nil {
            try encodeIfPresent(value, forKey: key)
        } else {
            switch value.nilValueEncodingStrategy {
            case .omitKey:
                break

            case .encodeKeyWithNullValue:
                try encodeNil(forKey: key)
            }
        }
    }
}
