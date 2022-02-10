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
    @OptionalCodableValue var anotherDTO: AnotherDTO?
    
    // Case 4:
    @OptionalLossyArray var tags: [LoyaltyTagDto]

}
```

Define all properties except arrays optional. Array must not be optional as they can always be empty.

- Case 1: Basic types (Int, Bool, String) are represented as optional properties and wrapped as @OptionalLosslessValue. Mind that types with a string representation like ISO8601 dates are mapped as strings at this layer, too. Conversion to Date objects is done at higher layer. Parse errors (or the absence of the value's key) yield nil values.

- Case 2: Arrays of basic types are non-optional and wrapped as @OptionalLosslessArray. Any element that cannot be parsed will be skipped. The resulting array can be empty.

- Case 3: Complex types like custom DTOs are mapped as @OptionalCodableValue. Parse errors (or the absence of the value's key) yield nil values.

- Case 4: Arrays of complex types like custom DTOs are non-optional and wrapped as @OptionalLossyArray. Any element that cannot be parsed will be skipped. The resulting array can be empty.

## Attribution

This project is licensed under MIT.
