# EvenBetterCodable

Resilient JSON parsing for an application's DTO layer. Extends [marksands' BetterCodable](https://github.com/marksands/BetterCodable)

## Usage

For maximum robustness, define your DTO as follows:

```Swift
struct MyDTO: Codable {
    // Case 1:
    @OptionalLosslessValue var someString: String?
    @OptionalLosslessValue var someInteger: Int?
    
    // Case 2:
    @OptionalLosslessArray var someArray: [Int]

    // Case 3:
    @OptionalLossyValue var anotherDTO: AnotherDTO?
    
    // Case 4:
    @OptionalLossyArray var examples: [ExampleDTO]

}
```

Define all properties except arrays optional. Array must not be optional as they can always be empty.

- Case 1: Basic types (Int, Bool, String) are represented as optional properties and wrapped as @OptionalLosslessValue. Mind that types with a string representation like ISO8601 dates are mapped as strings at this layer, too. Conversion to Date objects is the responsibility of higher layers. Parse errors (or the absence of the value's key) yield nil values.

- Case 2: Arrays of basic types are non-optional and wrapped as @OptionalLosslessArray. Any element that cannot be parsed will be skipped. The resulting array can be empty.

- Case 3: Complex types like custom DTOs are mapped as @OptionalLossyValue. Parse errors (or the absence of the value's key) yield nil values.

- Case 4: Arrays of complex types like custom DTOs are non-optional and wrapped as @OptionalLossyArray. Any element that cannot be parsed will be skipped. The resulting array can be empty.

### Encoding

By convention, nil values (or empty array) are not encoded to JSON and the property's corresponding key is omitted from the JSON output (read: as if the property was not there).
You can change the behavior as follows:

```Swift
struct MyDTO: Codable {
    @OptionalLosslessValue var willBeMissingInJSON: Bool? = nil // JSON: {}
    @OptionalLosslessValue(nilValueEncodingStrategy: .encodeKeyWithNullValue) var willBeNullInJSON: Bool? = nil // JSON: {"willBeNullInJSON": null}
    @OptionalLosslessArray var arrayWillBeMissingInJSON: [String] = [] // JSON: {}
    @OptionalLosslessArray(emptyArrayEncodingStrategy: .encodeKeyWithNullValue) var arrayWillBeNullInJSON: [String] = [] // JSON: {"arrayWillBeNullInJSON": null}
    @OptionalLosslessArray(emptyArrayEncodingStrategy: .encodeKeyWithEmptyArray) var arrayWillBeEmptyInJSON: [String] = [] // JSON: {"arrayWillBeEmptyInJSON": []}
}
```

Mind that, due to current limitatings in the Swift language, you _have_ to provide a default value (= nil, = []) when specifying the _nilValueEncodingStrategy_ or _emptyArrayEncodingStrategy_ in the property wrapper.

## Attribution

This project is licensed under MIT.
