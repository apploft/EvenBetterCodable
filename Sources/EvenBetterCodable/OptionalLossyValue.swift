//
//  OptionalLossyValue.swift
//
//
//  Created by apploft GmbH on 02.02.22.
//


import Foundation

@propertyWrapper
public struct OptionalLossyValue<T> {

    public var wrappedValue: T?

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionalLossyValue: Decodable where T: Decodable  {
    public init(from decoder: Decoder) {
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
