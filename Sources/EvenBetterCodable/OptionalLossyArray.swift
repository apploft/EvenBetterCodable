//
//  OptionalLossyArray.swift
//
//
//  Created by apploft GmbH on 26.11.21.
//

import Foundation

@propertyWrapper
public struct OptionalLossyArray<T> {
    public var wrappedValue: [T]

    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionalLossyArray: Decodable where T: Decodable {
    private struct AnyDecodableValue: Decodable {}

    public init(from decoder: Decoder) throws {
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

extension OptionalLossyArray: Equatable where T: Equatable { }
extension OptionalLossyArray: Hashable where T: Hashable { }
