/// A pointer for accessing  data of a
/// specific type.
///
/// You use instances of the `UnsafePointer` type to access data of a
/// specific type in memory. The type of data that a pointer can access is the
/// pointer's `Pointee` type. `UnsafePointer` provides no automated
/// memory management or alignment guarantees. You are responsible for
/// handling the life cycle of any memory you work with through unsafe
/// pointers to avoid leaks or undefined behavior.
///
/// Memory that you manually manage can be either *untyped* or *bound* to a
/// specific type. You use the `UnsafePointer` type to access and
/// manage memory that has been bound to a specific type.
///
/// Understanding a Pointer's Memory State
/// ======================================
///
/// The memory referenced by an `UnsafePointer` instance can be in
/// one of several states. Many pointer operations must only be applied to
/// pointers with memory in a specific state---you must keep track of the
/// state of the memory you are working with and understand the changes to
/// that state that different operations perform. Memory can be untyped and
/// uninitialized, bound to a type and uninitialized, or bound to a type and
/// initialized to a value. Finally, memory that was allocated previously may
/// have been deallocated, leaving existing pointers referencing unallocated
/// memory.
///
/// Uninitialized Memory
/// --------------------
///
/// Memory that has just been allocated through a typed pointer or has been
/// deinitialized is in an *uninitialized* state. Uninitialized memory must be
/// initialized before it can be accessed for reading.
///
/// Initialized Memory
/// ------------------
///
/// *Initialized* memory has a value that can be read using a pointer's
/// `pointee` property or through subscript notation. In the following
/// example, `ptr` is a pointer to memory initialized with a value of `23`:
///
///     let ptr: UnsafePointer<Int> = ...
///     // ptr.pointee == 23
///     // ptr[0] == 23
///
/// Accessing a Pointer's Memory as a Different Type
/// ================================================
///
/// When you access memory through an `UnsafePointer` instance, the
/// `Pointee` type must be consistent with the bound type of the memory. If
/// you do need to access memory that is bound to one type as a different
/// type, Swift's pointer types provide type-safe ways to temporarily or
/// permanently change the bound type of the memory, or to load typed
/// instances directly from raw memory.
///
/// An `UnsafePointer<UInt8>` instance allocated with eight bytes of
/// memory, `uint8Pointer`, will be used for the examples below.
///
///     let uint8Pointer: UnsafePointer<UInt8> = fetchEightBytes()
///
/// When you only need to temporarily access a pointer's memory as a different
/// type, use the `withMemoryRebound(to:capacity:)` method. For example, you
/// can use this method to call an API that expects a pointer to a different
/// type that is layout compatible with your pointer's `Pointee`. The following
/// code temporarily rebinds the memory that `uint8Pointer` references from
/// `UInt8` to `Int8` to call the imported C `strlen` function.
///
///     // Imported from C
///     func strlen(_ __s: UnsafePointer<Int8>!) -> UInt
///
///     let length = uint8Pointer.withMemoryRebound(to: Int8.self, capacity: 8) {
///         return strlen($0)
///     }
///     // length == 7
///
/// When you need to permanently rebind memory to a different type, first
/// obtain a raw pointer to the memory and then call the
/// `bindMemory(to:capacity:)` method on the raw pointer. The following
/// example binds the memory referenced by `uint8Pointer` to one instance of
/// the `UInt64` type:
///
///     let uint64Pointer = UnsafeRawPointer(uint8Pointer)
///                               .bindMemory(to: UInt64.self, capacity: 1)
///
/// After rebinding the memory referenced by `uint8Pointer` to `UInt64`,
/// accessing that pointer's referenced memory as a `UInt8` instance is
/// undefined.
///
///     var fullInteger = uint64Pointer.pointee          // OK
///     var firstByte = uint8Pointer.pointee             // undefined
///
/// Alternatively, you can access the same memory as a different type without
/// rebinding through untyped memory access, so long as the bound type and the
/// destination type are trivial types. Convert your pointer to an
/// `UnsafeRawPointer` instance and then use the raw pointer's
/// `load(fromByteOffset:as:)` method to read values.
///
///     let rawPointer = UnsafeRawPointer(uint64Pointer)
///     let fullInteger = rawPointer.load(as: UInt64.self)   // OK
///     let firstByte = rawPointer.load(as: UInt8.self)      // OK
///
/// Performing Typed Pointer Arithmetic
/// ===================================
///
/// Pointer arithmetic with a typed pointer is counted in strides of the
/// pointer's `Pointee` type. When you add to or subtract from an `UnsafePointer`
/// instance, the result is a new pointer of the same type, offset by that
/// number of instances of the `Pointee` type.
///
///     // 'intPointer' points to memory initialized with [10, 20, 30, 40]
///     let intPointer: UnsafePointer<Int> = ...
///
///     // Load the first value in memory
///     let x = intPointer.pointee
///     // x == 10
///
///     // Load the third value in memory
///     let offsetPointer = intPointer + 2
///     let y = offsetPointer.pointee
///     // y == 30
///
/// You can also use subscript notation to access the value in memory at a
/// specific offset.
///
///     let z = intPointer[2]
///     // z == 30
///
/// Implicit Casting and Bridging
/// =============================
///
/// When calling a function or method with an `UnsafePointer` parameter, you can pass
/// an instance of that specific pointer type, pass an instance of a
/// compatible pointer type, or use Swift's implicit bridging to pass a
/// compatible pointer.
///
/// For example, the `printInt(atAddress:)` function in the following code
/// sample expects an `UnsafePointer<Int>` instance as its first parameter:
///
///     func printInt(atAddress p: UnsafePointer<Int>) {
///         print(p.pointee)
///     }
///
/// As is typical in Swift, you can call the `printInt(atAddress:)` function
/// with an `UnsafePointer` instance. This example passes `intPointer`, a pointer to
/// an `Int` value, to `print(address:)`.
///
///     printInt(atAddress: intPointer)
///     // Prints "42"
///
/// Because a mutable typed pointer can be implicitly cast to an immutable
/// pointer with the same `Pointee` type when passed as a parameter, you can
/// also call `printInt(atAddress:)` with an `UnsafeMutablePointer` instance.
///
///     let mutableIntPointer = UnsafeMutablePointer(mutating: intPointer)
///     printInt(atAddress: mutableIntPointer)
///     // Prints "42"
///
/// Alternatively, you can use Swift's *implicit bridging* to pass a pointer to
/// an instance or to the elements of an array. The following example passes a
/// pointer to the `value` variable by using inout syntax:
///
///     var value: Int = 23
///     printInt(atAddress: &value)
///     // Prints "23"
///
/// An immutable pointer to the elements of an array is implicitly created when
/// you pass the array as an argument. This example uses implicit bridging to
/// pass a pointer to the elements of `numbers` when calling
/// `printInt(atAddress:)`.
///
///     let numbers = [5, 10, 15, 20]
///     printInt(atAddress: numbers)
///     // Prints "5"
///
/// You can also use inout syntax to pass a mutable pointer to the elements of
/// an array. Because `printInt(atAddress:)` requires an immutable pointer,
/// although this is syntactically valid, it isn't necessary.
///
///     var mutableNumbers = numbers
///     printInt(atAddress: &mutableNumbers)
///
/// No matter which way you call `printInt(atAddress:)`, Swift's type safety
/// guarantees that you can only pass a pointer to the type required by the
/// function---in this case, a pointer to an `Int`.
///
/// - Important: The pointer created through implicit bridging of an instance
///   or of an array's elements is only valid during the execution of the
///   called function. Escaping the pointer to use after the execution of the
///   function is undefined behavior. In particular, do not use implicit
///   bridging when calling an `UnsafePointer` initializer.
///
///       var number = 5
///       let numberPointer = UnsafePointer<Int>(&number)
///       // Accessing 'numberPointer' is undefined behavior.
@frozen public struct UnsafePointer<Pointee> {

    /// A type that represents the distance between two pointers.
    public typealias Distance = Int

    /// Deallocates the memory block previously allocated at this pointer.
    ///
    /// This pointer must be a pointer to the start of a previously allocated memory
    /// block. The memory must not be initialized or `Pointee` must be a trivial type.
    @inlinable public func deallocate()

    /// Accesses the instance referenced by this pointer.
    ///
    /// When reading from the `pointee` property, the instance referenced by
    /// this pointer must already be initialized.
    @inlinable public var pointee: Pointee { get }

    /// Executes the given closure while temporarily binding the specified number
    /// of instances to the given type.
    ///
    /// Use this method when you have a pointer to memory bound to one type and
    /// you need to access that memory as instances of another type. Accessing
    /// memory as a type `T` requires that the memory be bound to that type. A
    /// memory location may only be bound to one type at a time, so accessing
    /// the same memory as an unrelated type without first rebinding the memory
    /// is undefined.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be initialized.
    ///
    /// The following example temporarily rebinds the memory of a `UInt64`
    /// pointer to `Int64`, then accesses a property on the signed integer.
    ///
    ///     let uint64Pointer: UnsafePointer<UInt64> = fetchValue()
    ///     let isNegative = uint64Pointer.withMemoryRebound(to: Int64.self, capacity: 1) { ptr in
    ///         return ptr.pointee < 0
    ///     }
    ///
    /// Because this pointer's memory is no longer bound to its `Pointee` type
    /// while the `body` closure executes, do not access memory using the
    /// original pointer from within `body`. Instead, use the `body` closure's
    /// pointer argument to access the values in memory as instances of type
    /// `T`.
    ///
    /// After executing `body`, this method rebinds memory back to the original
    /// `Pointee` type.
    ///
    /// - Note: Only use this method to rebind the pointer's memory to a type
    ///   with the same size and stride as the currently bound `Pointee` type.
    ///   To bind a region of memory to a type that is a different size, convert
    ///   the pointer to a raw pointer and use the `bindMemory(to:capacity:)`
    ///   method.
    ///
    /// - Parameters:
    ///   - type: The type to temporarily bind the memory referenced by this
    ///     pointer. The type `T` must be the same size and be layout compatible
    ///     with the pointer's `Pointee` type.
    ///   - count: The number of instances of `Pointee` to bind to `type`.
    ///   - body: A closure that takes a  typed pointer to the
    ///     same memory as this pointer, only bound to type `T`. The closure's
    ///     pointer argument is valid only for the duration of the closure's
    ///     execution. If `body` has a return value, that value is also used as
    ///     the return value for the `withMemoryRebound(to:capacity:_:)` method.
    /// - Returns: The return value, if any, of the `body` closure parameter.
    @inlinable public func withMemoryRebound<T, Result>(to type: T.Type, capacity count: Int, _ body: (UnsafePointer<T>) throws -> Result) rethrows -> Result

    /// Accesses the pointee at the specified offset from this pointer.
    ///
    ///
    /// For a pointer `p`, the memory at `p + i` must be initialized.
    ///
    /// - Parameter i: The offset from this pointer at which to access an
    ///   instance, measured in strides of the pointer's `Pointee` type.
    @inlinable public subscript(i: Int) -> Pointee { get }

    /// A type that represents the distance between two values.
    public typealias Stride = Int

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    public var hashValue: Int { get }

    /// A custom playground Quick Look for this instance.
    ///
    /// If this type has value semantics, the `PlaygroundQuickLook` instance
    /// should be unaffected by subsequent mutations.
    @available(swift, deprecated: 4.2, message: "UnsafePointer.customPlaygroundQuickLook will be removed in a future Swift version")
    public var customPlaygroundQuickLook: PlaygroundQuickLook { get }

    /// Returns a closed range that contains both of its bounds.
    ///
    /// Use the closed range operator (`...`) to create a closed range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `ClosedRange<Character>` from "a" up to, and including, "z".
    ///
    ///     let lowercase = "a"..."z"
    ///     print(lowercase.contains("z"))
    ///     // Prints "true"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ... (minimum: UnsafePointer<Pointee>, maximum: UnsafePointer<Pointee>) -> ClosedRange<UnsafePointer<Pointee>>

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than that of the second argument.
    ///
    /// This is the default implementation of the greater-than operator (`>`) for
    /// any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func > (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is less than or equal to that of the second argument.
    ///
    /// This is the default implementation of the less-than-or-equal-to
    /// operator (`<=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func <= (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than or equal to that of the second argument.
    ///
    /// This is the default implementation of the greater-than-or-equal-to operator
    /// (`>=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs`; otherwise,
    ///   `false`.
    @inlinable public static func >= (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Bool

    public static func != (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Bool

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer.
    public init(_ from: OpaquePointer)

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer. If
    ///   `from` is `nil`, the result of this initializer is `nil`.
    public init?(_ from: OpaquePointer?)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: Int)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: UInt)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init(_ other: UnsafePointer<Pointee>)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?(_ other: UnsafePointer<Pointee>?)

    /// Returns a Boolean value indicating whether two pointers are equal.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` and `rhs` reference the same memory address;
    ///   otherwise, `false`.
    public static func == (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether the first pointer references
    /// an earlier memory location than the second pointer.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` references a memory address earlier than
    ///   `rhs`; otherwise, `false`.
    public static func < (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Bool

    /// Returns a pointer to the next consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer advanced from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func successor() -> UnsafePointer<Pointee>

    /// Returns a pointer to the previous consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer shifted backward from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func predecessor() -> UnsafePointer<Pointee>

    /// Returns the distance from this pointer to the given pointer, counted as
    /// instances of the pointer's `Pointee` type.
    ///
    /// With pointers `p` and `q`, the result of `p.distance(to: q)` is
    /// equivalent to `q - p`.
    ///
    /// Typed pointers are required to be properly aligned for their `Pointee`
    /// type. Proper alignment ensures that the result of `distance(to:)`
    /// accurately measures the distance between the two pointers, counted in
    /// strides of `Pointee`. To find the distance in bytes between two
    /// pointers, convert them to `UnsafeRawPointer` instances before calling
    /// `distance(to:)`.
    ///
    /// - Parameter end: The pointer to calculate the distance to.
    /// - Returns: The distance from this pointer to `end`, in strides of the
    ///   pointer's `Pointee` type. To access the stride, use
    ///   `MemoryLayout<Pointee>.stride`.
    public func distance(to end: UnsafePointer<Pointee>) -> Int

    /// Returns a pointer offset from this pointer by the specified number of
    /// instances.
    ///
    /// With pointer `p` and distance `n`, the result of `p.advanced(by: n)` is
    /// equivalent to `p + n`.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Parameter n: The number of strides of the pointer's `Pointee` type to
    ///   offset this pointer. To access the stride, use
    ///   `MemoryLayout<Pointee>.stride`. `n` may be positive, negative, or
    ///   zero.
    /// - Returns: A pointer offset from this pointer by `n` instances of the
    ///   `Pointee` type.
    public func advanced(by n: Int) -> UnsafePointer<Pointee>

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    @inlinable public func hash(into hasher: inout Hasher)

    /// A textual representation of the pointer, suitable for debugging.
    public var debugDescription: String { get }

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror { get }

    public static func + (lhs: UnsafePointer<Pointee>, rhs: Int) -> UnsafePointer<Pointee>

    public static func + (lhs: Int, rhs: UnsafePointer<Pointee>) -> UnsafePointer<Pointee>

    public static func - (lhs: UnsafePointer<Pointee>, rhs: Int) -> UnsafePointer<Pointee>

    public static func - (lhs: UnsafePointer<Pointee>, rhs: UnsafePointer<Pointee>) -> Int

    public static func += (lhs: inout UnsafePointer<Pointee>, rhs: Int)

    public static func -= (lhs: inout UnsafePointer<Pointee>, rhs: Int)

    /// Returns a half-open range that contains its lower bound but not its upper
    /// bound.
    ///
    /// Use the half-open range operator (`..<`) to create a range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `Range<Double>` from zero up to, but not including, 5.0.
    ///
    ///     let lessThanFive = 0.0..<5.0
    ///     print(lessThanFive.contains(3.14))  // Prints "true"
    ///     print(lessThanFive.contains(5.0))   // Prints "false"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ..< (minimum: UnsafePointer<Pointee>, maximum: UnsafePointer<Pointee>) -> Range<UnsafePointer<Pointee>>

    /// Returns a partial range up to, but not including, its upper bound.
    ///
    /// Use the prefix half-open range operator (prefix `..<`) to create a
    /// partial range of any type that conforms to the `Comparable` protocol.
    /// This example creates a `PartialRangeUpTo<Double>` instance that includes
    /// any value less than `5.0`.
    ///
    ///     let upToFive = ..<5.0
    ///
    ///     upToFive.contains(3.14)       // true
    ///     upToFive.contains(6.28)       // false
    ///     upToFive.contains(5.0)        // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, but not
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[..<3])
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ..< (maximum: UnsafePointer<Pointee>) -> PartialRangeUpTo<UnsafePointer<Pointee>>

    /// Returns a partial range up to, and including, its upper bound.
    ///
    /// Use the prefix closed range operator (prefix `...`) to create a partial
    /// range of any type that conforms to the `Comparable` protocol. This
    /// example creates a `PartialRangeThrough<Double>` instance that includes
    /// any value less than or equal to `5.0`.
    ///
    ///     let throughFive = ...5.0
    ///
    ///     throughFive.contains(4.0)     // true
    ///     throughFive.contains(5.0)     // true
    ///     throughFive.contains(6.0)     // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, and
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[...3])
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ... (maximum: UnsafePointer<Pointee>) -> PartialRangeThrough<UnsafePointer<Pointee>>

    /// Returns a partial range extending upward from a lower bound.
    ///
    /// Use the postfix range operator (postfix `...`) to create a partial range
    /// of any type that conforms to the `Comparable` protocol. This example
    /// creates a `PartialRangeFrom<Double>` instance that includes any value
    /// greater than or equal to `5.0`.
    ///
    ///     let atLeastFive = 5.0...
    ///
    ///     atLeastFive.contains(4.0)     // false
    ///     atLeastFive.contains(5.0)     // true
    ///     atLeastFive.contains(6.0)     // true
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the partial range's lower bound up to the end
    /// of the collection.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[3...])
    ///     // Prints "[40, 50, 60, 70]"
    ///
    /// - Parameter minimum: The lower bound for the range.
    ///
    /// - Precondition: `minimum` must compare equal to itself (i.e. cannot be NaN).
    postfix public static func ... (minimum: UnsafePointer<Pointee>) -> PartialRangeFrom<UnsafePointer<Pointee>>

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func < (x: UnsafePointer<Pointee>, y: UnsafePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func == (x: UnsafePointer<Pointee>, y: UnsafePointer<Pointee>) -> Bool
}

extension UnsafePointer : CVarArg {
}

/// A pointer for accessing and manipulating data of a
/// specific type.
///
/// You use instances of the `UnsafeMutablePointer` type to access data of a
/// specific type in memory. The type of data that a pointer can access is the
/// pointer's `Pointee` type. `UnsafeMutablePointer` provides no automated
/// memory management or alignment guarantees. You are responsible for
/// handling the life cycle of any memory you work with through unsafe
/// pointers to avoid leaks or undefined behavior.
///
/// Memory that you manually manage can be either *untyped* or *bound* to a
/// specific type. You use the `UnsafeMutablePointer` type to access and
/// manage memory that has been bound to a specific type.
///
/// Understanding a Pointer's Memory State
/// ======================================
///
/// The memory referenced by an `UnsafeMutablePointer` instance can be in
/// one of several states. Many pointer operations must only be applied to
/// pointers with memory in a specific state---you must keep track of the
/// state of the memory you are working with and understand the changes to
/// that state that different operations perform. Memory can be untyped and
/// uninitialized, bound to a type and uninitialized, or bound to a type and
/// initialized to a value. Finally, memory that was allocated previously may
/// have been deallocated, leaving existing pointers referencing unallocated
/// memory.
///
/// Uninitialized Memory
/// --------------------
///
/// Memory that has just been allocated through a typed pointer or has been
/// deinitialized is in an *uninitialized* state. Uninitialized memory must be
/// initialized before it can be accessed for reading.
///
/// You can use methods like `initialize(to:count:)`, `initialize(from:count:)`,
/// and `moveInitialize(from:count:)` to initialize the memory referenced by a
/// pointer with a value or series of values.
///
/// Initialized Memory
/// ------------------
///
/// *Initialized* memory has a value that can be read using a pointer's
/// `pointee` property or through subscript notation. In the following
/// example, `ptr` is a pointer to memory initialized with a value of `23`:
///
///     let ptr: UnsafeMutablePointer<Int> = ...
///     // ptr.pointee == 23
///     // ptr[0] == 23
///
/// Accessing a Pointer's Memory as a Different Type
/// ================================================
///
/// When you access memory through an `UnsafeMutablePointer` instance, the
/// `Pointee` type must be consistent with the bound type of the memory. If
/// you do need to access memory that is bound to one type as a different
/// type, Swift's pointer types provide type-safe ways to temporarily or
/// permanently change the bound type of the memory, or to load typed
/// instances directly from raw memory.
///
/// An `UnsafeMutablePointer<UInt8>` instance allocated with eight bytes of
/// memory, `uint8Pointer`, will be used for the examples below.
///
///     var bytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
///     let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
///     uint8Pointer.initialize(from: &bytes, count: 8)
///
/// When you only need to temporarily access a pointer's memory as a different
/// type, use the `withMemoryRebound(to:capacity:)` method. For example, you
/// can use this method to call an API that expects a pointer to a different
/// type that is layout compatible with your pointer's `Pointee`. The following
/// code temporarily rebinds the memory that `uint8Pointer` references from
/// `UInt8` to `Int8` to call the imported C `strlen` function.
///
///     // Imported from C
///     func strlen(_ __s: UnsafePointer<Int8>!) -> UInt
///
///     let length = uint8Pointer.withMemoryRebound(to: Int8.self, capacity: 8) {
///         return strlen($0)
///     }
///     // length == 7
///
/// When you need to permanently rebind memory to a different type, first
/// obtain a raw pointer to the memory and then call the
/// `bindMemory(to:capacity:)` method on the raw pointer. The following
/// example binds the memory referenced by `uint8Pointer` to one instance of
/// the `UInt64` type:
///
///     let uint64Pointer = UnsafeMutableRawPointer(uint8Pointer)
///                               .bindMemory(to: UInt64.self, capacity: 1)
///
/// After rebinding the memory referenced by `uint8Pointer` to `UInt64`,
/// accessing that pointer's referenced memory as a `UInt8` instance is
/// undefined.
///
///     var fullInteger = uint64Pointer.pointee          // OK
///     var firstByte = uint8Pointer.pointee             // undefined
///
/// Alternatively, you can access the same memory as a different type without
/// rebinding through untyped memory access, so long as the bound type and the
/// destination type are trivial types. Convert your pointer to an
/// `UnsafeMutableRawPointer` instance and then use the raw pointer's
/// `load(fromByteOffset:as:)` and `storeBytes(of:toByteOffset:as:)` methods
/// to read and write values.
///
///     let rawPointer = UnsafeMutableRawPointer(uint64Pointer)
///     let fullInteger = rawPointer.load(as: UInt64.self)   // OK
///     let firstByte = rawPointer.load(as: UInt8.self)      // OK
///
/// Performing Typed Pointer Arithmetic
/// ===================================
///
/// Pointer arithmetic with a typed pointer is counted in strides of the
/// pointer's `Pointee` type. When you add to or subtract from an `UnsafeMutablePointer`
/// instance, the result is a new pointer of the same type, offset by that
/// number of instances of the `Pointee` type.
///
///     // 'intPointer' points to memory initialized with [10, 20, 30, 40]
///     let intPointer: UnsafeMutablePointer<Int> = ...
///
///     // Load the first value in memory
///     let x = intPointer.pointee
///     // x == 10
///
///     // Load the third value in memory
///     let offsetPointer = intPointer + 2
///     let y = offsetPointer.pointee
///     // y == 30
///
/// You can also use subscript notation to access the value in memory at a
/// specific offset.
///
///     let z = intPointer[2]
///     // z == 30
///
/// Implicit Casting and Bridging
/// =============================
///
/// When calling a function or method with an `UnsafeMutablePointer` parameter, you can pass
/// an instance of that specific pointer type or use Swift's implicit bridging
/// to pass a compatible pointer.
///
/// For example, the `printInt(atAddress:)` function in the following code
/// sample expects an `UnsafeMutablePointer<Int>` instance as its first parameter:
///
///     func printInt(atAddress p: UnsafeMutablePointer<Int>) {
///         print(p.pointee)
///     }
///
/// As is typical in Swift, you can call the `printInt(atAddress:)` function
/// with an `UnsafeMutablePointer` instance. This example passes `intPointer`, a mutable
/// pointer to an `Int` value, to `print(address:)`.
///
///     printInt(atAddress: intPointer)
///     // Prints "42"
///
/// Alternatively, you can use Swift's *implicit bridging* to pass a pointer to
/// an instance or to the elements of an array. The following example passes a
/// pointer to the `value` variable by using inout syntax:
///
///     var value: Int = 23
///     printInt(atAddress: &value)
///     // Prints "23"
///
/// A mutable pointer to the elements of an array is implicitly created when
/// you pass the array using inout syntax. This example uses implicit bridging
/// to pass a pointer to the elements of `numbers` when calling
/// `printInt(atAddress:)`.
///
///     var numbers = [5, 10, 15, 20]
///     printInt(atAddress: &numbers)
///     // Prints "5"
///
/// No matter which way you call `printInt(atAddress:)`, Swift's type safety
/// guarantees that you can only pass a pointer to the type required by the
/// function---in this case, a pointer to an `Int`.
///
/// - Important: The pointer created through implicit bridging of an instance
///   or of an array's elements is only valid during the execution of the
///   called function. Escaping the pointer to use after the execution of the
///   function is undefined behavior. In particular, do not use implicit
///   bridging when calling an `UnsafeMutablePointer` initializer.
///
///       var number = 5
///       let numberPointer = UnsafeMutablePointer<Int>(&number)
///       // Accessing 'numberPointer' is undefined behavior.
@frozen public struct UnsafeMutablePointer<Pointee> {

    /// A type that represents the distance between two pointers.
    public typealias Distance = Int

    /// Creates a mutable typed pointer referencing the same memory as the given
    /// immutable pointer.
    ///
    /// - Parameter other: The immutable pointer to convert.
    public init(mutating other: UnsafePointer<Pointee>)

    /// Creates a mutable typed pointer referencing the same memory as the given
    /// immutable pointer.
    ///
    /// - Parameter other: The immutable pointer to convert. If `other` is `nil`,
    ///   the result is `nil`.
    public init?(mutating other: UnsafePointer<Pointee>?)

    /// Creates an immutable typed pointer referencing the same memory as the
    /// given mutable pointer.
    ///
    /// - Parameter other: The pointer to convert.
    public init(_ other: UnsafeMutablePointer<Pointee>)

    /// Creates an immutable typed pointer referencing the same memory as the
    /// given mutable pointer.
    ///
    /// - Parameter other: The pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?(_ other: UnsafeMutablePointer<Pointee>?)

    /// Allocates uninitialized memory for the specified number of instances of
    /// type `Pointee`.
    ///
    /// The resulting pointer references a region of memory that is bound to
    /// `Pointee` and is `count * MemoryLayout<Pointee>.stride` bytes in size.
    ///
    /// The following example allocates enough new memory to store four `Int`
    /// instances and then initializes that memory with the elements of a range.
    ///
    ///     let intPointer = UnsafeMutablePointer<Int>.allocate(capacity: 4)
    ///     for i in 0..<4 {
    ///         (intPointer + i).initialize(to: i)
    ///     }
    ///     print(intPointer.pointee)
    ///     // Prints "0"
    ///
    /// When you allocate memory, always remember to deallocate once you're
    /// finished.
    ///
    ///     intPointer.deallocate()
    ///
    /// - Parameter count: The amount of memory to allocate, counted in instances
    ///   of `Pointee`.
    @inlinable public static func allocate(capacity count: Int) -> UnsafeMutablePointer<Pointee>

    /// Deallocates the memory block previously allocated at this pointer.
    ///
    /// This pointer must be a pointer to the start of a previously allocated memory
    /// block. The memory must not be initialized or `Pointee` must be a trivial type.
    @inlinable public func deallocate()

    /// Accesses the instance referenced by this pointer.
    ///
    /// When reading from the `pointee` property, the instance referenced by this
    /// pointer must already be initialized. When `pointee` is used as the left
    /// side of an assignment, the instance must be initialized or this
    /// pointer's `Pointee` type must be a trivial type.
    ///
    /// Do not assign an instance of a nontrivial type through `pointee` to
    /// uninitialized memory. Instead, use an initializing method, such as
    /// `initialize(to:count:)`.
    @inlinable public var pointee: Pointee { get nonmutating set }

    /// Initializes this pointer's memory with the specified number of
    /// consecutive copies of the given value.
    ///
    /// The destination memory must be uninitialized or the pointer's `Pointee`
    /// must be a trivial type. After a call to `initialize(repeating:count:)`, the
    /// memory referenced by this pointer is initialized.
    ///
    /// - Parameters:
    ///   - repeatedValue: The instance to initialize this pointer's memory with.
    ///   - count: The number of consecutive copies of `newValue` to initialize.
    ///     `count` must not be negative.
    @inlinable public func initialize(repeating repeatedValue: Pointee, count: Int)

    /// Initializes this pointer's memory with a single instance of the given value.
    ///
    /// The destination memory must be uninitialized or the pointer's `Pointee`
    /// must be a trivial type. After a call to `initialize(to:)`, the
    /// memory referenced by this pointer is initialized. Calling this method is
    /// roughly equivalent to calling `initialize(repeating:count:)` with a
    /// `count` of 1.
    ///
    /// - Parameters:
    ///   - value: The instance to initialize this pointer's pointee to.
    @inlinable public func initialize(to value: Pointee)

    /// Retrieves and returns the referenced instance, returning the pointer's
    /// memory to an uninitialized state.
    ///
    /// Calling the `move()` method on a pointer `p` that references memory of
    /// type `T` is equivalent to the following code, aside from any cost and
    /// incidental side effects of copying and destroying the value:
    ///
    ///     let value: T = {
    ///         defer { p.deinitialize(count: 1) }
    ///         return p.pointee
    ///     }()
    ///
    /// The memory referenced by this pointer must be initialized. After calling
    /// `move()`, the memory is uninitialized.
    ///
    /// - Returns: The instance referenced by this pointer.
    @inlinable public func move() -> Pointee

    /// Replaces this pointer's memory with the specified number of
    /// consecutive copies of the given value.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be initialized or
    /// `Pointee` must be a trivial type. After calling
    /// `assign(repeating:count:)`, the region is initialized.
    ///
    /// - Parameters:
    ///   - repeatedValue: The instance to assign this pointer's memory to.
    ///   - count: The number of consecutive copies of `newValue` to assign.
    ///     `count` must not be negative.
    @inlinable public func assign(repeating repeatedValue: Pointee, count: Int)

    /// Replaces this pointer's initialized memory with the specified number of
    /// instances from the given pointer's memory.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be initialized or
    /// `Pointee` must be a trivial type. After calling
    /// `assign(from:count:)`, the region is initialized.
    ///
    /// - Note: Returns without performing work if `self` and `source` are equal.
    ///
    /// - Parameters:
    ///   - source: A pointer to at least `count` initialized instances of type
    ///     `Pointee`. The memory regions referenced by `source` and this
    ///     pointer may overlap.
    ///   - count: The number of instances to copy from the memory referenced by
    ///     `source` to this pointer's memory. `count` must not be negative.
    @inlinable public func assign(from source: UnsafePointer<Pointee>, count: Int)

    /// Moves instances from initialized source memory into the uninitialized
    /// memory referenced by this pointer, leaving the source memory
    /// uninitialized and the memory referenced by this pointer initialized.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be uninitialized or
    /// `Pointee` must be a trivial type. After calling
    /// `moveInitialize(from:count:)`, the region is initialized and the memory
    /// region `source..<(source + count)` is uninitialized.
    ///
    /// - Parameters:
    ///   - source: A pointer to the values to copy. The memory region
    ///     `source..<(source + count)` must be initialized. The memory regions
    ///     referenced by `source` and this pointer may overlap.
    ///   - count: The number of instances to move from `source` to this
    ///     pointer's memory. `count` must not be negative.
    @inlinable public func moveInitialize(from source: UnsafeMutablePointer<Pointee>, count: Int)

    /// Initializes the memory referenced by this pointer with the values
    /// starting at the given pointer.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be uninitialized or
    /// `Pointee` must be a trivial type. After calling
    /// `initialize(from:count:)`, the region is initialized.
    ///
    /// - Parameters:
    ///   - source: A pointer to the values to copy. The memory region
    ///     `source..<(source + count)` must be initialized. The memory regions
    ///     referenced by `source` and this pointer must not overlap.
    ///   - count: The number of instances to move from `source` to this
    ///     pointer's memory. `count` must not be negative.
    @inlinable public func initialize(from source: UnsafePointer<Pointee>, count: Int)

    /// Replaces the memory referenced by this pointer with the values
    /// starting at the given pointer, leaving the source memory uninitialized.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be initialized or
    /// `Pointee` must be a trivial type. After calling
    /// `moveAssign(from:count:)`, the region is initialized and the memory
    /// region `source..<(source + count)` is uninitialized.
    ///
    /// - Parameters:
    ///   - source: A pointer to the values to copy. The memory region
    ///     `source..<(source + count)` must be initialized. The memory regions
    ///     referenced by `source` and this pointer must not overlap.
    ///   - count: The number of instances to move from `source` to this
    ///     pointer's memory. `count` must not be negative.
    @inlinable public func moveAssign(from source: UnsafeMutablePointer<Pointee>, count: Int)

    /// Deinitializes the specified number of values starting at this pointer.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be initialized. After
    /// calling `deinitialize(count:)`, the memory is uninitialized, but still
    /// bound to the `Pointee` type.
    ///
    /// - Parameter count: The number of instances to deinitialize. `count` must
    ///   not be negative.
    /// - Returns: A raw pointer to the same address as this pointer. The memory
    ///   referenced by the returned raw pointer is still bound to `Pointee`.
    @inlinable public func deinitialize(count: Int) -> UnsafeMutableRawPointer

    /// Executes the given closure while temporarily binding the specified number
    /// of instances to the given type.
    ///
    /// Use this method when you have a pointer to memory bound to one type and
    /// you need to access that memory as instances of another type. Accessing
    /// memory as a type `T` requires that the memory be bound to that type. A
    /// memory location may only be bound to one type at a time, so accessing
    /// the same memory as an unrelated type without first rebinding the memory
    /// is undefined.
    ///
    /// The region of memory starting at this pointer and covering `count`
    /// instances of the pointer's `Pointee` type must be initialized.
    ///
    /// The following example temporarily rebinds the memory of a `UInt64`
    /// pointer to `Int64`, then accesses a property on the signed integer.
    ///
    ///     let uint64Pointer: UnsafeMutablePointer<UInt64> = fetchValue()
    ///     let isNegative = uint64Pointer.withMemoryRebound(to: Int64.self, capacity: 1) { ptr in
    ///         return ptr.pointee < 0
    ///     }
    ///
    /// Because this pointer's memory is no longer bound to its `Pointee` type
    /// while the `body` closure executes, do not access memory using the
    /// original pointer from within `body`. Instead, use the `body` closure's
    /// pointer argument to access the values in memory as instances of type
    /// `T`.
    ///
    /// After executing `body`, this method rebinds memory back to the original
    /// `Pointee` type.
    ///
    /// - Note: Only use this method to rebind the pointer's memory to a type
    ///   with the same size and stride as the currently bound `Pointee` type.
    ///   To bind a region of memory to a type that is a different size, convert
    ///   the pointer to a raw pointer and use the `bindMemory(to:capacity:)`
    ///   method.
    ///
    /// - Parameters:
    ///   - type: The type to temporarily bind the memory referenced by this
    ///     pointer. The type `T` must be the same size and be layout compatible
    ///     with the pointer's `Pointee` type.
    ///   - count: The number of instances of `Pointee` to bind to `type`.
    ///   - body: A closure that takes a mutable typed pointer to the
    ///     same memory as this pointer, only bound to type `T`. The closure's
    ///     pointer argument is valid only for the duration of the closure's
    ///     execution. If `body` has a return value, that value is also used as
    ///     the return value for the `withMemoryRebound(to:capacity:_:)` method.
    /// - Returns: The return value, if any, of the `body` closure parameter.
    @inlinable public func withMemoryRebound<T, Result>(to type: T.Type, capacity count: Int, _ body: (UnsafeMutablePointer<T>) throws -> Result) rethrows -> Result

    /// Accesses the pointee at the specified offset from this pointer.
    ///
    /// For a pointer `p`, the memory at `p + i` must be initialized when reading
    /// the value by using the subscript. When the subscript is used as the left
    /// side of an assignment, the memory at `p + i` must be initialized or
    /// the pointer's `Pointee` type must be a trivial type.
    ///
    /// Do not assign an instance of a nontrivial type through the subscript to
    /// uninitialized memory. Instead, use an initializing method, such as
    /// `initialize(to:count:)`.
    ///
    /// - Parameter i: The offset from this pointer at which to access an
    ///   instance, measured in strides of the pointer's `Pointee` type.
    @inlinable public subscript(i: Int) -> Pointee { get nonmutating set }

    /// A type that represents the distance between two values.
    public typealias Stride = Int

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    public var hashValue: Int { get }

    /// A custom playground Quick Look for this instance.
    ///
    /// If this type has value semantics, the `PlaygroundQuickLook` instance
    /// should be unaffected by subsequent mutations.
    @available(swift, deprecated: 4.2, message: "UnsafeMutablePointer.customPlaygroundQuickLook will be removed in a future Swift version")
    public var customPlaygroundQuickLook: PlaygroundQuickLook { get }

    /// Returns a closed range that contains both of its bounds.
    ///
    /// Use the closed range operator (`...`) to create a closed range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `ClosedRange<Character>` from "a" up to, and including, "z".
    ///
    ///     let lowercase = "a"..."z"
    ///     print(lowercase.contains("z"))
    ///     // Prints "true"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ... (minimum: UnsafeMutablePointer<Pointee>, maximum: UnsafeMutablePointer<Pointee>) -> ClosedRange<UnsafeMutablePointer<Pointee>>

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than that of the second argument.
    ///
    /// This is the default implementation of the greater-than operator (`>`) for
    /// any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func > (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is less than or equal to that of the second argument.
    ///
    /// This is the default implementation of the less-than-or-equal-to
    /// operator (`<=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func <= (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than or equal to that of the second argument.
    ///
    /// This is the default implementation of the greater-than-or-equal-to operator
    /// (`>=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs`; otherwise,
    ///   `false`.
    @inlinable public static func >= (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Bool

    public static func != (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Bool

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer.
    public init(_ from: OpaquePointer)

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer. If
    ///   `from` is `nil`, the result of this initializer is `nil`.
    public init?(_ from: OpaquePointer?)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: Int)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: UInt)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init(_ other: UnsafeMutablePointer<Pointee>)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?(_ other: UnsafeMutablePointer<Pointee>?)

    /// Returns a Boolean value indicating whether two pointers are equal.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` and `rhs` reference the same memory address;
    ///   otherwise, `false`.
    public static func == (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether the first pointer references
    /// an earlier memory location than the second pointer.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` references a memory address earlier than
    ///   `rhs`; otherwise, `false`.
    public static func < (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Bool

    /// Returns a pointer to the next consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer advanced from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func successor() -> UnsafeMutablePointer<Pointee>

    /// Returns a pointer to the previous consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer shifted backward from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func predecessor() -> UnsafeMutablePointer<Pointee>

    /// Returns the distance from this pointer to the given pointer, counted as
    /// instances of the pointer's `Pointee` type.
    ///
    /// With pointers `p` and `q`, the result of `p.distance(to: q)` is
    /// equivalent to `q - p`.
    ///
    /// Typed pointers are required to be properly aligned for their `Pointee`
    /// type. Proper alignment ensures that the result of `distance(to:)`
    /// accurately measures the distance between the two pointers, counted in
    /// strides of `Pointee`. To find the distance in bytes between two
    /// pointers, convert them to `UnsafeRawPointer` instances before calling
    /// `distance(to:)`.
    ///
    /// - Parameter end: The pointer to calculate the distance to.
    /// - Returns: The distance from this pointer to `end`, in strides of the
    ///   pointer's `Pointee` type. To access the stride, use
    ///   `MemoryLayout<Pointee>.stride`.
    public func distance(to end: UnsafeMutablePointer<Pointee>) -> Int

    /// Returns a pointer offset from this pointer by the specified number of
    /// instances.
    ///
    /// With pointer `p` and distance `n`, the result of `p.advanced(by: n)` is
    /// equivalent to `p + n`.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Parameter n: The number of strides of the pointer's `Pointee` type to
    ///   offset this pointer. To access the stride, use
    ///   `MemoryLayout<Pointee>.stride`. `n` may be positive, negative, or
    ///   zero.
    /// - Returns: A pointer offset from this pointer by `n` instances of the
    ///   `Pointee` type.
    public func advanced(by n: Int) -> UnsafeMutablePointer<Pointee>

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    @inlinable public func hash(into hasher: inout Hasher)

    /// A textual representation of the pointer, suitable for debugging.
    public var debugDescription: String { get }

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror { get }

    public static func + (lhs: UnsafeMutablePointer<Pointee>, rhs: Int) -> UnsafeMutablePointer<Pointee>

    public static func + (lhs: Int, rhs: UnsafeMutablePointer<Pointee>) -> UnsafeMutablePointer<Pointee>

    public static func - (lhs: UnsafeMutablePointer<Pointee>, rhs: Int) -> UnsafeMutablePointer<Pointee>

    public static func - (lhs: UnsafeMutablePointer<Pointee>, rhs: UnsafeMutablePointer<Pointee>) -> Int

    public static func += (lhs: inout UnsafeMutablePointer<Pointee>, rhs: Int)

    public static func -= (lhs: inout UnsafeMutablePointer<Pointee>, rhs: Int)

    /// Returns a half-open range that contains its lower bound but not its upper
    /// bound.
    ///
    /// Use the half-open range operator (`..<`) to create a range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `Range<Double>` from zero up to, but not including, 5.0.
    ///
    ///     let lessThanFive = 0.0..<5.0
    ///     print(lessThanFive.contains(3.14))  // Prints "true"
    ///     print(lessThanFive.contains(5.0))   // Prints "false"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ..< (minimum: UnsafeMutablePointer<Pointee>, maximum: UnsafeMutablePointer<Pointee>) -> Range<UnsafeMutablePointer<Pointee>>

    /// Returns a partial range up to, but not including, its upper bound.
    ///
    /// Use the prefix half-open range operator (prefix `..<`) to create a
    /// partial range of any type that conforms to the `Comparable` protocol.
    /// This example creates a `PartialRangeUpTo<Double>` instance that includes
    /// any value less than `5.0`.
    ///
    ///     let upToFive = ..<5.0
    ///
    ///     upToFive.contains(3.14)       // true
    ///     upToFive.contains(6.28)       // false
    ///     upToFive.contains(5.0)        // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, but not
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[..<3])
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ..< (maximum: UnsafeMutablePointer<Pointee>) -> PartialRangeUpTo<UnsafeMutablePointer<Pointee>>

    /// Returns a partial range up to, and including, its upper bound.
    ///
    /// Use the prefix closed range operator (prefix `...`) to create a partial
    /// range of any type that conforms to the `Comparable` protocol. This
    /// example creates a `PartialRangeThrough<Double>` instance that includes
    /// any value less than or equal to `5.0`.
    ///
    ///     let throughFive = ...5.0
    ///
    ///     throughFive.contains(4.0)     // true
    ///     throughFive.contains(5.0)     // true
    ///     throughFive.contains(6.0)     // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, and
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[...3])
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ... (maximum: UnsafeMutablePointer<Pointee>) -> PartialRangeThrough<UnsafeMutablePointer<Pointee>>

    /// Returns a partial range extending upward from a lower bound.
    ///
    /// Use the postfix range operator (postfix `...`) to create a partial range
    /// of any type that conforms to the `Comparable` protocol. This example
    /// creates a `PartialRangeFrom<Double>` instance that includes any value
    /// greater than or equal to `5.0`.
    ///
    ///     let atLeastFive = 5.0...
    ///
    ///     atLeastFive.contains(4.0)     // false
    ///     atLeastFive.contains(5.0)     // true
    ///     atLeastFive.contains(6.0)     // true
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the partial range's lower bound up to the end
    /// of the collection.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[3...])
    ///     // Prints "[40, 50, 60, 70]"
    ///
    /// - Parameter minimum: The lower bound for the range.
    ///
    /// - Precondition: `minimum` must compare equal to itself (i.e. cannot be NaN).
    postfix public static func ... (minimum: UnsafeMutablePointer<Pointee>) -> PartialRangeFrom<UnsafeMutablePointer<Pointee>>

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func < (x: UnsafeMutablePointer<Pointee>, y: UnsafeMutablePointer<Pointee>) -> Bool

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func == (x: UnsafeMutablePointer<Pointee>, y: UnsafeMutablePointer<Pointee>) -> Bool
}

extension UnsafeMutablePointer : CVarArg {
}

/// A mutable nonowning collection interface to the bytes in a
/// region of memory.
///
/// You can use an `UnsafeMutableRawBufferPointer` instance in low-level operations to eliminate
/// uniqueness checks and release mode bounds checks. Bounds checks are always
/// performed in debug mode.
///
/// An `UnsafeMutableRawBufferPointer` instance is a view of the raw bytes in a region of memory.
/// Each byte in memory is viewed as a `UInt8` value independent of the type
/// of values held in that memory. Reading from and writing to memory through
/// a raw buffer are untyped operations. Accessing this collection's bytes
/// does not bind the underlying memory to `UInt8`.
///
/// In addition to its collection interface, an `UnsafeMutableRawBufferPointer` instance also supports
/// the following methods provided by `UnsafeMutableRawPointer`, including
/// bounds checks in debug mode:
///
/// - `load(fromByteOffset:as:)`
/// - `storeBytes(of:toByteOffset:as:)`
/// - `copyMemory(from:)`
///
/// To access the underlying memory through typed operations, the memory must
/// be bound to a trivial type.
///
/// - Note: A *trivial type* can be copied bit for bit with no indirection
///   or reference-counting operations. Generally, native Swift types that do
///   not contain strong or weak references or other forms of indirection are
///   trivial, as are imported C structs and enums. Copying memory that
///   contains values of nontrivial types can only be done safely with a typed
///   pointer. Copying bytes directly from nontrivial, in-memory values does
///   not produce valid copies and can only be done by calling a C API, such as
///   `memmove()`.
///
/// UnsafeMutableRawBufferPointer Semantics
/// =================
///
/// An `UnsafeMutableRawBufferPointer` instance is a view into memory and does not own the memory
/// that it references. Copying a variable or constant of type `UnsafeMutableRawBufferPointer` does
/// not copy the underlying memory. However, initializing another collection
/// with an `UnsafeMutableRawBufferPointer` instance copies bytes out of the referenced memory and
/// into the new collection.
///
/// The following example uses `someBytes`, an `UnsafeMutableRawBufferPointer` instance, to
/// demonstrate the difference between assigning a buffer pointer and using a
/// buffer pointer as the source for another collection's elements. Here, the
/// assignment to `destBytes` creates a new, nonowning buffer pointer
/// covering the first `n` bytes of the memory that `someBytes`
/// references---nothing is copied:
///
///     var destBytes = someBytes[0..<n]
///
/// Next, the bytes referenced by `destBytes` are copied into `byteArray`, a
/// new `[UInt8]` array, and then the remainder of `someBytes` is appended to
/// `byteArray`:
///
///     var byteArray: [UInt8] = Array(destBytes)
///     byteArray += someBytes[n..<someBytes.count]
///
/// Assigning into a ranged subscript of an `UnsafeMutableRawBufferPointer` instance copies bytes
/// into the memory. The next `n` bytes of the memory that `someBytes`
/// references are copied in this code:
///
///     destBytes[0..<n] = someBytes[n..<(n + n)]
@frozen public struct UnsafeMutableRawBufferPointer {

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    public typealias Iterator = UnsafeRawBufferPointer.Iterator

    /// Returns a newly allocated buffer with the given size, in bytes.
    ///
    /// The memory referenced by the new buffer is allocated, but not
    /// initialized.
    ///
    /// - Parameters:
    ///   - byteCount: The number of bytes to allocate.
    ///   - alignment: The alignment of the new region of allocated memory, in
    ///     bytes.
    /// - Returns: A buffer pointer to a newly allocated region of memory aligned
    ///     to `alignment`.
    @inlinable public static func allocate(byteCount: Int, alignment: Int) -> UnsafeMutableRawBufferPointer

    /// Deallocates the memory block previously allocated at this buffer pointer’s
    /// base address.
    ///
    /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory
    /// block previously returned by a Swift allocation method. If `baseAddress` is
    /// `nil`, this function does nothing. Otherwise, the memory must not be initialized
    /// or `Pointee` must be a trivial type. This buffer pointer's byte `count` must
    /// be equal to the originally allocated size of the memory block.
    @inlinable public func deallocate()

    /// Returns a new instance of the given type, read from the buffer pointer's
    /// raw memory at the specified byte offset.
    ///
    /// You can use this method to create new values from the buffer pointer's
    /// underlying bytes. The following example creates two new `Int32`
    /// instances from the memory referenced by the buffer pointer `someBytes`.
    /// The bytes for `a` are copied from the first four bytes of `someBytes`,
    /// and the bytes for `b` are copied from the next four bytes.
    ///
    ///     let a = someBytes.load(as: Int32.self)
    ///     let b = someBytes.load(fromByteOffset: 4, as: Int32.self)
    ///
    /// The memory to read for the new instance must not extend beyond the buffer
    /// pointer's memory region---that is, `offset + MemoryLayout<T>.size` must
    /// be less than or equal to the buffer pointer's `count`.
    ///
    /// - Parameters:
    ///   - offset: The offset, in bytes, into the buffer pointer's memory at
    ///     which to begin reading data for the new instance. The buffer pointer
    ///     plus `offset` must be properly aligned for accessing an instance of
    ///     type `T`. The default is zero.
    ///   - type: The type to use for the newly constructed instance. The memory
    ///     must be initialized to a value of a type that is layout compatible
    ///     with `type`.
    /// - Returns: A new instance of type `T`, copied from the buffer pointer's
    ///   memory.
    @inlinable public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T

    /// Stores a value's bytes into the buffer pointer's raw memory at the
    /// specified byte offset.
    ///
    /// The type `T` to be stored must be a trivial type. The memory must also be
    /// uninitialized, initialized to `T`, or initialized to another trivial
    /// type that is layout compatible with `T`.
    ///
    /// The memory written to must not extend beyond the buffer pointer's memory
    /// region---that is, `offset + MemoryLayout<T>.size` must be less than or
    /// equal to the buffer pointer's `count`.
    ///
    /// After calling `storeBytes(of:toByteOffset:as:)`, the memory is
    /// initialized to the raw bytes of `value`. If the memory is bound to a
    /// type `U` that is layout compatible with `T`, then it contains a value of
    /// type `U`. Calling `storeBytes(of:toByteOffset:as:)` does not change the
    /// bound type of the memory.
    ///
    /// - Parameters:
    ///   - offset: The offset in bytes into the buffer pointer's memory to begin
    ///     reading data for the new instance. The buffer pointer plus `offset`
    ///     must be properly aligned for accessing an instance of type `T`. The
    ///     default is zero.
    ///   - type: The type to use for the newly constructed instance. The memory
    ///     must be initialized to a value of a type that is layout compatible
    ///     with `type`.
    @inlinable public func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as: T.Type)

    /// Copies the bytes from the given buffer to this buffer's memory.
    ///
    /// If the `source.count` bytes of memory referenced by this buffer are bound
    /// to a type `T`, then `T` must be a trivial type, the underlying pointer
    /// must be properly aligned for accessing `T`, and `source.count` must be a
    /// multiple of `MemoryLayout<T>.stride`.
    ///
    /// The memory referenced by `source` may overlap with the memory referenced
    /// by this buffer.
    ///
    /// After calling `copyMemory(from:)`, the first `source.count` bytes of
    /// memory referenced by this buffer are initialized to raw bytes. If the
    /// memory is bound to type `T`, then it contains values of type `T`.
    ///
    /// - Parameter source: A buffer of raw bytes from which to copy.
    ///   `source.count` must be less than or equal to this buffer's `count`.
    @inlinable public func copyMemory(from source: UnsafeRawBufferPointer)

    /// Copies from a collection of `UInt8` into this buffer's memory.
    ///
    /// If the `source.count` bytes of memory referenced by this buffer are bound
    /// to a type `T`, then `T` must be a trivial type, the underlying pointer
    /// must be properly aligned for accessing `T`, and `source.count` must be a
    /// multiple of `MemoryLayout<T>.stride`.
    ///
    /// After calling `copyBytes(from:)`, the `source.count` bytes of memory
    /// referenced by this buffer are initialized to raw bytes. If the memory is
    /// bound to type `T`, then it contains values of type `T`.
    ///
    /// - Parameter source: A collection of `UInt8` elements. `source.count` must
    ///   be less than or equal to this buffer's `count`.
    @inlinable public func copyBytes<C>(from source: C) where C : Collection, C.Element == UInt8

    /// Creates a buffer over the specified number of contiguous bytes starting
    /// at the given pointer.
    ///
    /// - Parameters:
    ///   - start: The address of the memory that starts the buffer. If `starts`
    ///     is `nil`, `count` must be zero. However, `count` may be zero even
    ///     for a non-`nil` `start`.
    ///   - count: The number of bytes to include in the buffer. `count` must not
    ///     be negative.
    @inlinable public init(start: UnsafeMutableRawPointer?, count: Int)

    /// Creates a new buffer over the same memory as the given buffer.
    ///
    /// - Parameter bytes: The buffer to convert.
    @inlinable public init(_ bytes: UnsafeMutableRawBufferPointer)

    /// Creates a new mutable buffer over the same memory as the given buffer.
    ///
    /// - Parameter bytes: The buffer to convert.
    @inlinable public init(mutating bytes: UnsafeRawBufferPointer)

    /// Creates a raw buffer over the contiguous bytes in the given typed buffer.
    ///
    /// - Parameter buffer: The typed buffer to convert to a raw buffer. The
    ///   buffer's type `T` must be a trivial type.
    @inlinable public init<T>(_ buffer: UnsafeMutableBufferPointer<T>)

    /// Creates a raw buffer over the same memory as the given raw buffer slice,
    /// with the indices rebased to zero.
    ///
    /// The new buffer represents the same region of memory as the slice, but its
    /// indices start at zero instead of at the beginning of the slice in the
    /// original buffer. The following code creates `slice`, a slice covering
    /// part of an existing buffer instance, then rebases it into a new `rebased`
    /// buffer.
    ///
    ///     let slice = buffer[n...]
    ///     let rebased = UnsafeRawBufferPointer(rebasing: slice)
    ///
    /// After this code has executed, the following are true:
    ///
    /// - `rebased.startIndex == 0`
    /// - `rebased[0] == slice[n]`
    /// - `rebased[0] == buffer[n]`
    /// - `rebased.count == slice.count`
    ///
    /// - Parameter slice: The raw buffer slice to rebase.
    @inlinable public init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>)

    /// A pointer to the first byte of the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    @inlinable public var baseAddress: UnsafeMutableRawPointer? { get }

    /// Initializes the memory referenced by this buffer with the given value,
    /// binds the memory to the value's type, and returns a typed buffer of the
    /// initialized memory.
    ///
    /// The memory referenced by this buffer must be uninitialized or
    /// initialized to a trivial type, and must be properly aligned for
    /// accessing `T`.
    ///
    /// After calling this method on a raw buffer with non-nil `baseAddress` `b`,
    /// the region starting at `b` and continuing up to
    /// `b + self.count - self.count % MemoryLayout<T>.stride` is bound to type `T` and
    /// initialized. If `T` is a nontrivial type, you must eventually deinitialize
    /// or move the values in this region to avoid leaks. If `baseAddress` is
    /// `nil`, this function does nothing and returns an empty buffer pointer.
    ///
    /// - Parameters:
    ///   - type: The type to bind this buffer’s memory to.
    ///   - repeatedValue: The instance to copy into memory.
    /// - Returns: A typed buffer of the memory referenced by this raw buffer.
    ///     The typed buffer contains `self.count / MemoryLayout<T>.stride`
    ///     instances of `T`.
    @inlinable public func initializeMemory<T>(as type: T.Type, repeating repeatedValue: T) -> UnsafeMutableBufferPointer<T>

    /// Initializes the buffer's memory with the given elements, binding the
    /// initialized memory to the elements' type.
    ///
    /// When calling the `initializeMemory(as:from:)` method on a buffer `b`,
    /// the memory referenced by `b` must be uninitialized or initialized to a
    /// trivial type, and must be properly aligned for accessing `S.Element`.
    /// The buffer must contain sufficient memory to accommodate
    /// `source.underestimatedCount`.
    ///
    /// This method initializes the buffer with elements from `source` until
    /// `source` is exhausted or, if `source` is a sequence but not a
    /// collection, the buffer has no more room for its elements. After calling
    /// `initializeMemory(as:from:)`, the memory referenced by the returned
    /// `UnsafeMutableBufferPointer` instance is bound and initialized to type
    /// `S.Element`.
    ///
    /// - Parameters:
    ///   - type: The type of the elements to bind the buffer's memory to.
    ///   - source: A sequence of elements with which to initialize the buffer.
    /// - Returns: An iterator to any elements of `source` that didn't fit in the
    ///   buffer, and a typed buffer of the written elements. The returned
    ///   buffer references memory starting at the same base address as this
    ///   buffer.
    @inlinable public func initializeMemory<S>(as type: S.Element.Type, from source: S) -> (unwritten: S.Iterator, initialized: UnsafeMutableBufferPointer<S.Element>) where S : Sequence

    /// Binds this buffer’s memory to the specified type and returns a typed buffer
    /// of the bound memory.
    ///
    /// Use the `bindMemory(to:)` method to bind the memory referenced
    /// by this buffer to the type `T`. The memory must be uninitialized or
    /// initialized to a type that is layout compatible with `T`. If the memory
    /// is uninitialized, it is still uninitialized after being bound to `T`.
    ///
    /// - Warning: A memory location may only be bound to one type at a time. The
    ///   behavior of accessing memory as a type unrelated to its bound type is
    ///   undefined.
    ///
    /// - Parameters:
    ///   - type: The type `T` to bind the memory to.
    /// - Returns: A typed buffer of the newly bound memory. The memory in this
    ///   region is bound to `T`, but has not been modified in any other way.
    ///   The typed buffer references `self.count / MemoryLayout<T>.stride` instances of `T`.
    public func bindMemory<T>(to type: T.Type) -> UnsafeMutableBufferPointer<T>

    /// Returns a subsequence containing all but the specified number of final
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in the
    /// collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropLast(2))
    ///     // Prints "[1, 2, 3]"
    ///     print(numbers.dropLast(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop off the end of the
    ///   collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence that leaves off `k` elements from the end.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop.
    @inlinable public func dropLast(_ k: Int) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence, up to the given maximum length, containing the
    /// final elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains the entire collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.suffix(2))
    ///     // Prints "[4, 5]"
    ///     print(numbers.suffix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence terminating at the end of the collection with at
    ///   most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is equal to
    ///   `maxLength`.
    @inlinable public func suffix(_ maxLength: Int) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    @inlinable public func map<T>(_ transform: (UInt8) throws -> T) rethrows -> [T]

    /// Returns a subsequence containing all but the given number of initial
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in
    /// the collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropFirst(2))
    ///     // Prints "[3, 4, 5]"
    ///     print(numbers.dropFirst(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop from the beginning of
    ///   the collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence starting after the specified number of
    ///   elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop from the beginning of the collection.
    @inlinable public func dropFirst(_ k: Int = 1) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence by skipping elements while `predicate` returns
    /// `true` and returning the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be skipped or `false` if it should be included. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func drop(while predicate: (UInt8) throws -> Bool) rethrows -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence, up to the specified maximum length, containing
    /// the initial elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains all the elements in the collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.prefix(2))
    ///     // Prints "[1, 2]"
    ///     print(numbers.prefix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence starting at the beginning of this collection
    ///   with at most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to select from the beginning of the collection.
    @inlinable public func prefix(_ maxLength: Int) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence containing the initial elements until `predicate`
    /// returns `false` and skipping the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be included or `false` if it should be excluded. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func prefix(while predicate: (UInt8) throws -> Bool) rethrows -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence from the start of the collection up to, but not
    /// including, the specified position.
    ///
    /// The resulting subsequence *does not include* the element at the position
    /// `end`. The following example searches for the index of the number `40`
    /// in an array of integers, and then prints the prefix of the array up to,
    /// but not including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(upTo: i))
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// Passing the collection's starting index as the `end` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.prefix(upTo: numbers.startIndex))
    ///     // Prints "[]"
    ///
    /// Using the `prefix(upTo:)` method is equivalent to using a partial
    /// half-open range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(upTo:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[..<i])
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter end: The "past the end" index of the resulting subsequence.
    ///   `end` must be a valid index of the collection.
    /// - Returns: A subsequence up to, but not including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(upTo end: Int) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence from the specified position to the end of the
    /// collection.
    ///
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the suffix of the array starting at
    /// that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.suffix(from: i))
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// Passing the collection's `endIndex` as the `start` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.suffix(from: numbers.endIndex))
    ///     // Prints "[]"
    ///
    /// Using the `suffix(from:)` method is equivalent to using a partial range
    /// from the index as the collection's subscript. The subscript notation is
    /// preferred over `suffix(from:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[i...])
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// - Parameter start: The index at which to start the resulting subsequence.
    ///   `start` must be a valid index of the collection.
    /// - Returns: A subsequence starting at the `start` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func suffix(from start: Int) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns a subsequence from the start of the collection through the
    /// specified position.
    ///
    /// The resulting subsequence *includes* the element at the position `end`.
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the prefix of the array up to, and
    /// including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(through: i))
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// Using the `prefix(through:)` method is equivalent to using a partial
    /// closed range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(through:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[...i])
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter end: The index of the last element to include in the
    ///   resulting subsequence. `end` must be a valid index of the collection
    ///   that is not equal to the `endIndex` property.
    /// - Returns: A subsequence up to, and including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(through position: Int) -> Slice<UnsafeMutableRawBufferPointer>

    /// Returns the longest possible subsequences of the collection, in order,
    /// that don't contain elements satisfying the given predicate.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string using a
    /// closure that matches spaces. The first use of `split` returns each word
    /// that was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(maxSplits: 1, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(omittingEmptySubsequences: false, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each pair of consecutive elements
    ///     satisfying the `isSeparator` predicate and for each element at the
    ///     start or end of the collection satisfying the `isSeparator`
    ///     predicate. The default value is `true`.
    ///   - isSeparator: A closure that takes an element as an argument and
    ///     returns a Boolean value indicating whether the collection should be
    ///     split at that element.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (UInt8) throws -> Bool) rethrows -> [Slice<UnsafeMutableRawBufferPointer>]

    /// Returns the longest possible subsequences of the collection, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the collection are not returned as part
    /// of any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " "))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the collection and for each instance of `separator` at
    ///     the start or end of the collection. If `true`, only nonempty
    ///     subsequences are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(separator: UInt8, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Slice<UnsafeMutableRawBufferPointer>]

    /// The last element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let lastNumber = numbers.last {
    ///         print(lastNumber)
    ///     }
    ///     // Prints "50"
    ///
    /// - Complexity: O(1)
    @inlinable public var last: UInt8? { get }

    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `firstIndex(of:)` to find the position of a particular element
    /// in a collection, you can use it to access the element by subscripting.
    /// This example shows how you can modify one of the names in an array of
    /// students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Maxime"]
    ///     if let i = students.firstIndex(of: "Maxime") {
    ///         students[i] = "Max"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(of element: UInt8) -> Int?

    /// Returns the first index in which an element of the collection satisfies
    /// the given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. Here's an example that finds a student name that
    /// begins with the letter "A":
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.firstIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Abena starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the first element for which `predicate` returns
    ///   `true`. If no elements in the collection satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(where predicate: (UInt8) throws -> Bool) rethrows -> Int?

    /// Returns the last element of the sequence that satisfies the given
    /// predicate.
    ///
    /// This example uses the `last(where:)` method to find the last
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let lastNegative = numbers.last(where: { $0 < 0 }) {
    ///         print("The last negative number is \(lastNegative).")
    ///     }
    ///     // Prints "The last negative number is -6."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The last element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func last(where predicate: (UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the index of the last element in the collection that matches the
    /// given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. This example finds the index of the last name that
    /// begins with the letter *A:*
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.lastIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Akosua starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the last element in the collection that matches
    ///   `predicate`, or `nil` if no elements match.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(where predicate: (UInt8) throws -> Bool) rethrows -> Int?

    /// Returns the last index where the specified value appears in the
    /// collection.
    ///
    /// After using `lastIndex(of:)` to find the position of the last instance of
    /// a particular element in a collection, you can use it to access the
    /// element by subscripting. This example shows how you can modify one of
    /// the names in an array of students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Ben", "Maxime"]
    ///     if let i = students.lastIndex(of: "Ben") {
    ///         students[i] = "Benjamin"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Benjamin", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The last index where `element` is found. If `element` is not
    ///   found in the collection, this method returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(of element: UInt8) -> Int?

    /// Reorders the elements of the collection such that all the elements
    /// that match the given predicate are after all the elements that don't
    /// match.
    ///
    /// After partitioning a collection, there is a pivot index `p` where
    /// no element before `p` satisfies the `belongsInSecondPartition`
    /// predicate and every element at or after `p` satisfies
    /// `belongsInSecondPartition`.
    ///
    /// In the following example, an array of numbers is partitioned by a
    /// predicate that matches elements greater than 30.
    ///
    ///     var numbers = [30, 40, 20, 30, 30, 60, 10]
    ///     let p = numbers.partition(by: { $0 > 30 })
    ///     // p == 5
    ///     // numbers == [30, 10, 20, 30, 30, 60, 40]
    ///
    /// The `numbers` array is now arranged in two partitions. The first
    /// partition, `numbers[..<p]`, is made up of the elements that
    /// are not greater than 30. The second partition, `numbers[p...]`,
    /// is made up of the elements that *are* greater than 30.
    ///
    ///     let first = numbers[..<p]
    ///     // first == [30, 10, 20, 30, 30]
    ///     let second = numbers[p...]
    ///     // second == [60, 40]
    ///
    /// - Parameter belongsInSecondPartition: A predicate used to partition
    ///   the collection. All elements satisfying this predicate are ordered
    ///   after all elements not satisfying it.
    /// - Returns: The index of the first element in the reordered collection
    ///   that matches `belongsInSecondPartition`. If no elements in the
    ///   collection match `belongsInSecondPartition`, the returned index is
    ///   equal to the collection's `endIndex`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public mutating func partition(by belongsInSecondPartition: (UInt8) throws -> Bool) rethrows -> Int

    /// Reorders the elements of the collection such that all the elements
    /// that match the given predicate are after all the elements that don't
    /// match.
    ///
    /// After partitioning a collection, there is a pivot index `p` where
    /// no element before `p` satisfies the `belongsInSecondPartition`
    /// predicate and every element at or after `p` satisfies
    /// `belongsInSecondPartition`.
    ///
    /// In the following example, an array of numbers is partitioned by a
    /// predicate that matches elements greater than 30.
    ///
    ///     var numbers = [30, 40, 20, 30, 30, 60, 10]
    ///     let p = numbers.partition(by: { $0 > 30 })
    ///     // p == 5
    ///     // numbers == [30, 10, 20, 30, 30, 60, 40]
    ///
    /// The `numbers` array is now arranged in two partitions. The first
    /// partition, `numbers[..<p]`, is made up of the elements that
    /// are not greater than 30. The second partition, `numbers[p...]`,
    /// is made up of the elements that *are* greater than 30.
    ///
    ///     let first = numbers[..<p]
    ///     // first == [30, 10, 20, 30, 30]
    ///     let second = numbers[p...]
    ///     // second == [60, 40]
    ///
    /// - Parameter belongsInSecondPartition: A predicate used to partition
    ///   the collection. All elements satisfying this predicate are ordered
    ///   after all elements not satisfying it.
    /// - Returns: The index of the first element in the reordered collection
    ///   that matches `belongsInSecondPartition`. If no elements in the
    ///   collection match `belongsInSecondPartition`, the returned index is
    ///   equal to the collection's `endIndex`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public mutating func partition(by belongsInSecondPartition: (UInt8) throws -> Bool) rethrows -> Int

    /// Returns the elements of the sequence, shuffled using the given generator
    /// as a source for randomness.
    ///
    /// You use this method to randomize the elements of a sequence when you are
    /// using a custom random number generator. For example, you can shuffle the
    /// numbers between `0` and `9` by calling the `shuffled(using:)` method on
    /// that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled(using: &myGenerator)
    ///     // shuffledNumbers == [8, 9, 4, 3, 2, 6, 7, 0, 5, 1]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the sequence.
    /// - Returns: An array of this sequence's elements in a shuffled order.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    /// - Note: The algorithm used to shuffle a sequence may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public func shuffled<T>(using generator: inout T) -> [UInt8] where T : RandomNumberGenerator

    /// Returns the elements of the sequence, shuffled.
    ///
    /// For example, you can shuffle the numbers between `0` and `9` by calling
    /// the `shuffled()` method on that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled()
    ///     // shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]
    ///
    /// This method is equivalent to calling `shuffled(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Returns: A shuffled array of this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func shuffled() -> [UInt8]

    /// Shuffles the collection in place, using the given generator as a source
    /// for randomness.
    ///
    /// You use this method to randomize the elements of a collection when you
    /// are using a custom random number generator. For example, you can use the
    /// `shuffle(using:)` method to randomly reorder the elements of an array.
    ///
    ///     var names = ["Alejandro", "Camila", "Diego", "Luciana", "Luis", "Sofía"]
    ///     names.shuffle(using: &myGenerator)
    ///     // names == ["Sofía", "Alejandro", "Camila", "Luis", "Diego", "Luciana"]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the collection.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    /// - Note: The algorithm used to shuffle a collection may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public mutating func shuffle<T>(using generator: inout T) where T : RandomNumberGenerator

    /// Shuffles the collection in place.
    ///
    /// Use the `shuffle()` method to randomly reorder the elements of an array.
    ///
    ///     var names = ["Alejandro", "Camila", "Diego", "Luciana", "Luis", "Sofía"]
    ///     names.shuffle(using: myGenerator)
    ///     // names == ["Luis", "Camila", "Luciana", "Sofía", "Alejandro", "Diego"]
    ///
    /// This method is equivalent to calling `shuffle(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public mutating func shuffle()

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection, using the given predicate as an
    /// equivalence test.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///   - areEquivalent: A closure that returns a Boolean value indicating
    ///     whether two elements are equivalent.
    ///
    /// - Returns: The difference needed to produce the reciever's state from
    ///   the parameter's state.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C, by areEquivalent: (C.Element, UInt8) -> Bool) -> CollectionDifference<UInt8> where C : BidirectionalCollection, UInt8 == C.Element

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///
    /// - Returns: The difference needed to produce this collection's ordered
    ///   elements from the given collection.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements, or
    ///   if `Element` conforms to `Hashable`.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C) -> CollectionDifference<UInt8> where C : BidirectionalCollection, UInt8 == C.Element

    /// A sequence containing the same elements as this sequence,
    /// but on which some operations, such as `map` and `filter`, are
    /// implemented lazily.
    @inlinable public var lazy: LazySequence<UnsafeMutableRawBufferPointer> { get }

    @available(swift, deprecated: 4.1, renamed: "compactMap(_:)", message: "Please use compactMap(_:) for the case where closure returns an optional value")
    public func flatMap<ElementOfResult>(_ transform: (UInt8) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the first index where the specified value appears in the
    /// collection.
    @available(swift, deprecated: 5.0, renamed: "firstIndex(of:)")
    @inlinable public func index(of element: UInt8) -> Int?

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// mutable contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of mutable contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// Often, the optimizer can eliminate bounds- and uniqueness-checks
    /// within an algorithm, but when that fails, invoking the
    /// same algorithm on `body`\ 's argument lets you trade safety for
    /// speed.
    @inlinable public mutating func withContiguousMutableStorageIfAvailable<R>(_ body: (inout UnsafeMutableBufferPointer<UInt8>) throws -> R) rethrows -> R?

    /// Accesses a contiguous subrange of the collection's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice of an array of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original array.
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2 ..< streets.endIndex]
    ///     print(streetsSlice)
    ///     // Prints "["Channing", "Douglas", "Evarts"]"
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     streets[index!] = "Eustace"
    ///     print(streets[index!])
    ///     // Prints "Eustace"
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeMutableRawBufferPointer>

    /// Accesses the contiguous subrange of the collection's elements specified
    /// by a range expression.
    ///
    /// The range expression is converted to a concrete subrange relative to this
    /// collection. For example, using a `PartialRangeFrom` range expression
    /// with an array accesses the subrange from the start of the range
    /// expression until the end of the array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2...]
    ///     print(streetsSlice)
    ///     // ["Channing", "Douglas", "Evarts"]
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection uses. This example searches `streetsSlice` for one
    /// of the strings in the slice, and then uses that index in the original
    /// array.
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // "Evarts"
    ///
    /// Always use the slice's `startIndex` property instead of assuming that its
    /// indices start at a particular value. Attempting to access an element by
    /// using an index outside the bounds of the slice's indices may result in a
    /// runtime error, even if that index is valid for the original collection.
    ///
    ///     print(streetsSlice.startIndex)
    ///     // 2
    ///     print(streetsSlice[2])
    ///     // "Channing"
    ///
    ///     print(streetsSlice[0])
    ///     // error: Index out of bounds
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript<R>(r: R) -> Slice<UnsafeMutableRawBufferPointer> where R : RangeExpression, Int == R.Bound { get }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> Slice<UnsafeMutableRawBufferPointer> { get }

    @inlinable public subscript<R>(r: R) -> Slice<UnsafeMutableRawBufferPointer> where R : RangeExpression, Int == R.Bound

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> Slice<UnsafeMutableRawBufferPointer>

    /// Reverses the elements of the collection in place.
    ///
    /// The following example reverses the elements of an array of characters:
    ///
    ///     var characters: [Character] = ["C", "a", "f", "é"]
    ///     characters.reverse()
    ///     print(characters)
    ///     // Prints "["é", "f", "a", "C"]
    ///
    /// - Complexity: O(*n*), where *n* is the number of elements in the
    ///   collection.
    @inlinable public mutating func reverse()

    /// Returns a view presenting the elements of the collection in reverse
    /// order.
    ///
    /// You can reverse a collection without allocating new space for its
    /// elements by calling this `reversed()` method. A `ReversedCollection`
    /// instance wraps an underlying collection and provides access to its
    /// elements in reverse order. This example prints the characters of a
    /// string in reverse order:
    ///
    ///     let word = "Backwards"
    ///     for char in word.reversed() {
    ///         print(char, terminator: "")
    ///     }
    ///     // Prints "sdrawkcaB"
    ///
    /// If you need a reversed collection of the same type, you may be able to
    /// use the collection's sequence-based or collection-based initializer. For
    /// example, to get the reversed version of a string, reverse its
    /// characters and initialize a new `String` instance from the result.
    ///
    ///     let reversedWord = String(word.reversed())
    ///     print(reversedWord)
    ///     // Prints "sdrawkcaB"
    ///
    /// - Complexity: O(1)
    @inlinable public func reversed() -> ReversedCollection<UnsafeMutableRawBufferPointer>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func map<T>(_ transform: (UInt8) throws -> T) rethrows -> [T]

    /// Returns an array containing, in order, the elements of the sequence
    /// that satisfy the given predicate.
    ///
    /// In this example, `filter(_:)` is used to include only names shorter than
    /// five characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let shortNames = cast.filter { $0.count < 5 }
    ///     print(shortNames)
    ///     // Prints "["Kim", "Karl"]"
    ///
    /// - Parameter isIncluded: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be included in the returned array.
    /// - Returns: An array of the elements that `isIncluded` allowed.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func filter(_ isIncluded: (UInt8) throws -> Bool) rethrows -> [UInt8]

    /// A value less than or equal to the number of elements in the sequence,
    /// calculated nondestructively.
    ///
    /// The default implementation returns 0. If you provide your own
    /// implementation, make sure to compute the value nondestructively.
    ///
    /// - Complexity: O(1), except if the sequence also conforms to `Collection`.
    ///   In this case, see the documentation of `Collection.underestimatedCount`.
    @inlinable public var underestimatedCount: Int { get }

    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEach(_ body: (UInt8) throws -> Void) rethrows

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `first(where:)` method to find the first
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let firstNegative = numbers.first(where: { $0 < 0 }) {
    ///         print("The first negative number is \(firstNegative).")
    ///     }
    ///     // Prints "The first negative number is -2."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The first element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func first(where predicate: (UInt8) throws -> Bool) rethrows -> UInt8?

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R?

    /// Returns a sequence of pairs (*n*, *x*), where *n* represents a
    /// consecutive integer starting at zero and *x* represents an element of
    /// the sequence.
    ///
    /// This example enumerates the characters of the string "Swift" and prints
    /// each character along with its place in the string.
    ///
    ///     for (n, c) in "Swift".enumerated() {
    ///         print("\(n): '\(c)'")
    ///     }
    ///     // Prints "0: 'S'"
    ///     // Prints "1: 'w'"
    ///     // Prints "2: 'i'"
    ///     // Prints "3: 'f'"
    ///     // Prints "4: 't'"
    ///
    /// When you enumerate a collection, the integer part of each pair is a counter
    /// for the enumeration, but is not necessarily the index of the paired value.
    /// These counters can be used as indices only in instances of zero-based,
    /// integer-indexed collections, such as `Array` and `ContiguousArray`. For
    /// other collections the counters may be out of range or of the wrong type
    /// to use as an index. To iterate over the elements of a collection with its
    /// indices, use the `zip(_:_:)` function.
    ///
    /// This example iterates over the indices and elements of a set, building a
    /// list consisting of indices of names with five or fewer letters.
    ///
    ///     let names: Set = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     var shorterIndices: [Set<String>.Index] = []
    ///     for (i, name) in zip(names.indices, names) {
    ///         if name.count <= 5 {
    ///             shorterIndices.append(i)
    ///         }
    ///     }
    ///
    /// Now that the `shorterIndices` array holds the indices of the shorter
    /// names in the `names` set, you can use those indices to access elements in
    /// the set.
    ///
    ///     for i in shorterIndices {
    ///         print(names[i])
    ///     }
    ///     // Prints "Sofia"
    ///     // Prints "Mateo"
    ///
    /// - Returns: A sequence of pairs enumerating the sequence.
    ///
    /// - Complexity: O(1)
    @inlinable public func enumerated() -> EnumeratedSequence<UnsafeMutableRawBufferPointer>

    /// Returns the minimum element in the sequence, using the given predicate as
    /// the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `min(by:)` method on a
    /// dictionary to find the key-value pair with the lowest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let leastHue = hues.min { a, b in a.value < b.value }
    ///     print(leastHue)
    ///     // Prints "Optional((key: "Coral", value: 16))"
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true`
    ///   if its first argument should be ordered before its second
    ///   argument; otherwise, `false`.
    /// - Returns: The sequence's minimum element, according to
    ///   `areInIncreasingOrder`. If the sequence has no elements, returns
    ///   `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the maximum element in the sequence, using the given predicate
    /// as the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `max(by:)` method on a
    /// dictionary to find the key-value pair with the highest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let greatestHue = hues.max { a, b in a.value < b.value }
    ///     print(greatestHue)
    ///     // Prints "Optional((key: "Heliotrope", value: 296))"
    ///
    /// - Parameter areInIncreasingOrder:  A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: The sequence's maximum element if the sequence is not empty;
    ///   otherwise, `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the minimum element in the sequence.
    ///
    /// This example finds the smallest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let lowestHeight = heights.min()
    ///     print(lowestHeight)
    ///     // Prints "Optional(58.5)"
    ///
    /// - Returns: The sequence's minimum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min() -> UInt8?

    /// Returns the maximum element in the sequence.
    ///
    /// This example finds the largest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let greatestHeight = heights.max()
    ///     print(greatestHeight)
    ///     // Prints "Optional(67.5)"
    ///
    /// - Returns: The sequence's maximum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max() -> UInt8?

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are equivalent to the elements in another sequence, using
    /// the given predicate as the equivalence test.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - possiblePrefix: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if the initial elements of the sequence are equivalent
    ///   to the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix, by areEquivalent: (UInt8, PossiblePrefix.Element) throws -> Bool) rethrows -> Bool where PossiblePrefix : Sequence

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are the same as the elements in another sequence.
    ///
    /// This example tests whether one countable range begins with the elements
    /// of another countable range.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(b.starts(with: a))
    ///     // Prints "true"
    ///
    /// Passing a sequence with no elements or an empty collection as
    /// `possiblePrefix` always results in `true`.
    ///
    ///     print(b.starts(with: []))
    ///     // Prints "true"
    ///
    /// - Parameter possiblePrefix: A sequence to compare to this sequence.
    /// - Returns: `true` if the initial elements of the sequence are the same as
    ///   the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, UInt8 == PossiblePrefix.Element

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain equivalent elements in the same order, using the given
    /// predicate as the equivalence test.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if this sequence and `other` contain equivalent items,
    ///   using `areEquivalent` as the equivalence test; otherwise, `false.`
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence, by areEquivalent: (UInt8, OtherSequence.Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain the same elements in the same order.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// This example tests whether one countable range shares the same elements
    /// as another countable range and an array.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(a.elementsEqual(b))
    ///     // Prints "false"
    ///     print(a.elementsEqual([1, 2, 3]))
    ///     // Prints "true"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence and `other` contain the same elements
    ///   in the same order.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the given
    /// predicate to compare elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areInIncreasingOrder:  A predicate that returns `true` if its first
    ///     argument should be ordered before its second argument; otherwise,
    ///     `false`.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering as ordered by `areInIncreasingOrder`; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that perform
    ///   localized comparison instead.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence, by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the
    /// less-than operator (`<`) to compare elements.
    ///
    /// This example uses the `lexicographicallyPrecedes` method to test which
    /// array of integers comes first in a lexicographical ordering.
    ///
    ///     let a = [1, 2, 2, 2]
    ///     let b = [1, 2, 3, 4]
    ///
    ///     print(a.lexicographicallyPrecedes(b))
    ///     // Prints "true"
    ///     print(b.lexicographicallyPrecedes(b))
    ///     // Prints "false"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that
    ///   perform localized comparison.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains an
    /// element that satisfies the given predicate.
    ///
    /// You can use the predicate to check for an element of a type that
    /// doesn't conform to the `Equatable` protocol, such as the
    /// `HTTPResponse` enumeration in this example.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]
    ///     let hadError = lastThreeResponses.contains { element in
    ///         if case .error = element {
    ///             return true
    ///         } else {
    ///             return false
    ///         }
    ///     }
    ///     // 'hadError' == true
    ///
    /// Alternatively, a predicate can be satisfied by a range of `Equatable`
    /// elements or a general condition. This example shows how you can check an
    /// array for an expense greater than $100.
    ///
    ///     let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
    ///     let hasBigPurchase = expenses.contains { $0 > 100 }
    ///     // 'hasBigPurchase' == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element represents a match.
    /// - Returns: `true` if the sequence contains an element that satisfies
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(where predicate: (UInt8) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether every element of a sequence
    /// satisfies a given predicate.
    ///
    /// The following code uses this method to test whether all the names in an
    /// array have at least five characters:
    ///
    ///     let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
    ///     // allHaveAtLeastFive == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element satisfies a condition.
    /// - Returns: `true` if the sequence contains only elements that satisfy
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func allSatisfy(_ predicate: (UInt8) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether the sequence contains the
    /// given element.
    ///
    /// This example checks to see whether a favorite actor is in an array
    /// storing a movie's cast.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     print(cast.contains("Marlon"))
    ///     // Prints "true"
    ///     print(cast.contains("James"))
    ///     // Prints "false"
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: `true` if the element was found in the sequence; otherwise,
    ///   `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(_ element: UInt8) -> Bool

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(_:_:)` method to produce a single value from the elements
    /// of an entire sequence. For example, you can use this method on an array
    /// of numbers to find their sum or product.
    ///
    /// The `nextPartialResult` closure is called sequentially with an
    /// accumulating value initialized to `initialResult` and each element of
    /// the sequence. This example shows how to find the sum of an array of
    /// numbers.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///     let numberSum = numbers.reduce(0, { x, y in
    ///         x + y
    ///     })
    ///     // numberSum == 10
    ///
    /// When `numbers.reduce(_:_:)` is called, the following steps occur:
    ///
    /// 1. The `nextPartialResult` closure is called with `initialResult`---`0`
    ///    in this case---and the first element of `numbers`, returning the sum:
    ///    `1`.
    /// 2. The closure is called again repeatedly with the previous call's return
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the last value returned from the
    ///    closure is returned to the caller.
    ///
    /// If the sequence has no elements, `nextPartialResult` is never executed
    /// and `initialResult` is the result of the call to `reduce(_:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///     `initialResult` is passed to `nextPartialResult` the first time the
    ///     closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and
    ///     an element of the sequence into a new accumulating value, to be used
    ///     in the next call of the `nextPartialResult` closure or returned to
    ///     the caller.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, UInt8) throws -> Result) rethrows -> Result

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(into:_:)` method to produce a single value from the
    /// elements of an entire sequence. For example, you can use this method on an
    /// array of integers to filter adjacent equal entries or count frequencies.
    ///
    /// This method is preferred over `reduce(_:_:)` for efficiency when the
    /// result is a copy-on-write type, for example an Array or a Dictionary.
    ///
    /// The `updateAccumulatingResult` closure is called sequentially with a
    /// mutable accumulating value initialized to `initialResult` and each element
    /// of the sequence. This example shows how to build a dictionary of letter
    /// frequencies of a string.
    ///
    ///     let letters = "abracadabra"
    ///     let letterCount = letters.reduce(into: [:]) { counts, letter in
    ///         counts[letter, default: 0] += 1
    ///     }
    ///     // letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1]
    ///
    /// When `letters.reduce(into:_:)` is called, the following steps occur:
    ///
    /// 1. The `updateAccumulatingResult` closure is called with the initial
    ///    accumulating value---`[:]` in this case---and the first character of
    ///    `letters`, modifying the accumulating value by setting `1` for the key
    ///    `"a"`.
    /// 2. The closure is called again repeatedly with the updated accumulating
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the accumulating value is returned to
    ///    the caller.
    ///
    /// If the sequence has no elements, `updateAccumulatingResult` is never
    /// executed and `initialResult` is the result of the call to
    /// `reduce(into:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating
    ///     value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, UInt8) throws -> ()) rethrows -> Result

    /// Returns an array containing the concatenated results of calling the
    /// given transformation with each element of this sequence.
    ///
    /// Use this method to receive a single-level collection when your
    /// transformation produces a sequence or collection for each element.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns an array.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///
    ///     let mapped = numbers.map { Array(repeating: $0, count: $0) }
    ///     // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
    ///
    ///     let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
    ///     // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
    ///
    /// In fact, `s.flatMap(transform)`  is equivalent to
    /// `Array(s.map(transform).joined())`.
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns a sequence or collection.
    /// - Returns: The resulting flattened array.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func flatMap<SegmentOfResult>(_ transform: (UInt8) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence

    /// Returns an array containing the non-`nil` results of calling the given
    /// transformation with each element of this sequence.
    ///
    /// Use this method to receive an array of non-optional values when your
    /// transformation produces an optional value.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `compactMap` with a transformation that returns an optional `Int` value.
    ///
    ///     let possibleNumbers = ["1", "2", "three", "///4///", "5"]
    ///
    ///     let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
    ///     // [1, 2, nil, nil, 5]
    ///
    ///     let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
    ///     // [1, 2, 5]
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-`nil` results of calling `transform`
    ///   with each element of the sequence.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func compactMap<ElementOfResult>(_ transform: (UInt8) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the elements of the sequence, sorted.
    ///
    /// You can sort any sequence of elements that conform to the `Comparable`
    /// protocol by calling this method. Elements are sorted in ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let sortedStudents = students.sorted()
    ///     print(sortedStudents)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your sequence in descending order, pass the
    /// greater-than operator (`>`) to the `sorted(by:)` method.
    ///
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted() -> [UInt8]

    /// Returns the elements of the sequence, sorted using the given predicate as
    /// the comparison between elements.
    ///
    /// When you want to sort a sequence of elements that don't conform to the
    /// `Comparable` protocol, pass a predicate to this method that returns
    /// `true` when the first element should be ordered before the second. The
    /// elements of the resulting array are ordered according to the given
    /// predicate.
    ///
    /// In the following example, the predicate provides an ordering for an array
    /// of a custom `HTTPResponse` type. The predicate orders errors before
    /// successes and sorts the error responses by their error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     let sortedResponses = responses.sorted {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(sortedResponses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// You also use this method to sort elements that conform to the
    /// `Comparable` protocol in descending order. To sort your sequence in
    /// descending order, pass the greater-than operator (`>`) as the
    /// `areInIncreasingOrder` parameter.
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// Calling the related `sorted()` method is equivalent to calling this
    /// method and passing the less-than operator (`<`) as the predicate.
    ///
    ///     print(students.sorted())
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///     print(students.sorted(by: <))
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> [UInt8]

    /// Sorts the collection in place.
    ///
    /// You can sort any mutable collection of elements that conform to the
    /// `Comparable` protocol by calling this method. Elements are sorted in
    /// ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     var students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     students.sort()
    ///     print(students)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your collection in descending order, pass the
    /// greater-than operator (`>`) to the `sort(by:)` method.
    ///
    ///     students.sort(by: >)
    ///     print(students)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the collection.
    @inlinable public mutating func sort()

    /// Sorts the collection in place, using the given predicate as the
    /// comparison between elements.
    ///
    /// When you want to sort a collection of elements that don't conform to
    /// the `Comparable` protocol, pass a closure to this method that returns
    /// `true` when the first element should be ordered before the second.
    ///
    /// In the following example, the closure provides an ordering for an array
    /// of a custom enumeration that describes an HTTP response. The predicate
    /// orders errors before successes and sorts the error responses by their
    /// error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     var responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     responses.sort {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(responses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// Alternatively, use this method to sort a collection of elements that do
    /// conform to `Comparable` when you want the sort to be descending instead
    /// of ascending. Pass the greater-than operator (`>`) operator as the
    /// predicate.
    ///
    ///     var students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     students.sort(by: >)
    ///     print(students)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// `areInIncreasingOrder` must be a *strict weak ordering* over the
    /// elements. That is, for any elements `a`, `b`, and `c`, the following
    /// conditions must hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`. If `areInIncreasingOrder` throws an error during
    ///   the sort, the elements may be in a different order, but none will be
    ///   lost.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the collection.
    @inlinable public mutating func sort(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows
}

/// Default implementation for bidirectional collections.
extension UnsafeMutableRawBufferPointer {

    /// Replaces the given index with its predecessor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    @inlinable public func formIndex(before i: inout Int)
}

/// Default implementation for random access collections.
extension UnsafeMutableRawBufferPointer {

    /// Returns an index that is the specified distance from the given index,
    /// unless that distance is beyond a given limiting index.
    ///
    /// The following example obtains an index advanced four positions from an
    /// array's starting index and then prints the element at that position. The
    /// operation doesn't require going beyond the limiting `numbers.endIndex`
    /// value, so it succeeds.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     let i = numbers.index(numbers.startIndex, offsetBy: 4)
    ///     print(numbers[i])
    ///     // Prints "50"
    ///
    /// The next example attempts to retrieve an index ten positions from
    /// `numbers.startIndex`, but fails, because that distance is beyond the
    /// index passed as `limit`.
    ///
    ///     let j = numbers.index(numbers.startIndex,
    ///                           offsetBy: 10,
    ///                           limitedBy: numbers.endIndex)
    ///     print(j)
    ///     // Prints "nil"
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the array.
    ///   - distance: The distance to offset `i`.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, `limit` should be greater than `i` to have any
    ///     effect. Likewise, if `distance < 0`, `limit` should be less than `i`
    ///     to have any effect.
    /// - Returns: An index offset by `distance` from the index `i`, unless that
    ///   index would be beyond `limit` in the direction of movement. In that
    ///   case, the method returns `nil`.
    ///
    /// - Complexity: O(1)
    @inlinable public func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int?
}

/// Default implementation for forward collections.
extension UnsafeMutableRawBufferPointer {

    /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    @inlinable public func formIndex(after i: inout Int)

    /// Offsets the given index by the specified distance.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int)

    /// Offsets the given index by the specified distance, or so that it equals
    /// the given limiting index.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, a limit that is less than `i` has no effect.
    ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
    ///     effect.
    /// - Returns: `true` if `i` has been offset by exactly `distance` steps
    ///   without going beyond `limit`; otherwise, `false`. When the return
    ///   value is `false`, the value of `i` is equal to `limit`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int, limitedBy limit: Int) -> Bool

    /// Returns a random element of the collection, using the given generator as
    /// a source for randomness.
    ///
    /// Call `randomElement(using:)` to select a random element from an array or
    /// another collection when you are using a custom random number generator.
    /// This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement(using: &myGenerator)!
    ///     // randomName == "Amani"
    ///
    /// - Parameter generator: The random number generator to use when choosing a
    ///   random element.
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    /// - Note: The algorithm used to select a random element may change in a
    ///   future version of Swift. If you're passing a generator that results in
    ///   the same sequence of elements each time you run your program, that
    ///   sequence may change when your program is compiled using a different
    ///   version of Swift.
    @inlinable public func randomElement<T>(using generator: inout T) -> UInt8? where T : RandomNumberGenerator

    /// Returns a random element of the collection.
    ///
    /// Call `randomElement()` to select a random element from an array or
    /// another collection. This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement()!
    ///     // randomName == "Amani"
    ///
    /// This method is equivalent to calling `randomElement(using:)`, passing in
    /// the system's default random generator.
    ///
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public func randomElement() -> UInt8?
}

/// Supply the default "slicing" `subscript` for `Collection` models
/// that accept the default associated `SubSequence`, `Slice<Self>`.
extension UnsafeMutableRawBufferPointer {

    /// Accesses a contiguous subrange of the collection's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice of an array of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2 ..< streets.endIndex]
    ///     print(streetsSlice)
    ///     // Prints "["Channing", "Douglas", "Evarts"]"
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // Prints "Evarts"
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeMutableRawBufferPointer> { get }
}

/// Default implementations of core requirements
extension UnsafeMutableRawBufferPointer {

    /// A Boolean value indicating whether the collection is empty.
    ///
    /// When you need to check whether your collection is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero. For collections that don't conform to
    /// `RandomAccessCollection`, accessing the `count` property iterates
    /// through the elements of the collection.
    ///
    ///     let horseName = "Silver"
    ///     if horseName.isEmpty {
    ///         print("My horse has no name.")
    ///     } else {
    ///         print("Hi ho, \(horseName)!")
    ///     }
    ///     // Prints "Hi ho, Silver!")
    ///
    /// - Complexity: O(1)
    @inlinable public var isEmpty: Bool { get }

    /// The first element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let firstNumber = numbers.first {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "10"
    @inlinable public var first: UInt8? { get }

    /// A value less than or equal to the number of elements in the collection.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var underestimatedCount: Int { get }

    /// The number of elements in the collection.
    ///
    /// To check whether a collection is empty, use its `isEmpty` property
    /// instead of comparing `count` to zero. Unless the collection guarantees
    /// random-access performance, calculating `count` can be an O(*n*)
    /// operation.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var count: Int { get }
}

extension UnsafeMutableRawBufferPointer : MutableCollection {

    /// A type representing the sequence's elements.
    public typealias Element = UInt8

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Range<Int>

    /// Always zero, which is the index of the first byte in a nonempty buffer.
    @inlinable public var startIndex: UnsafeMutableRawBufferPointer.Index { get }

    /// The "past the end" position---that is, the position one greater than the
    /// last valid subscript argument.
    ///
    /// The `endIndex` property of an `UnsafeMutableRawBufferPointer`
    /// instance is always identical to `count`.
    @inlinable public var endIndex: UnsafeMutableRawBufferPointer.Index { get }

    /// The indices that are valid for subscripting the collection, in ascending
    /// order.
    ///
    /// A collection's `indices` property can hold a strong reference to the
    /// collection itself, causing the collection to be nonuniquely referenced.
    /// If you mutate the collection while iterating over its indices, a strong
    /// reference can result in an unexpected copy of the collection. To avoid
    /// the unexpected copy, use the `index(after:)` method starting with
    /// `startIndex` to produce indices instead.
    ///
    ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
    ///     var i = c.startIndex
    ///     while i != c.endIndex {
    ///         c[i] /= 5
    ///         i = c.index(after: i)
    ///     }
    ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
    @inlinable public var indices: UnsafeMutableRawBufferPointer.Indices { get }

    /// Accesses the byte at the given offset in the memory region as a `UInt8`
    /// value.
    ///
    /// - Parameter i: The offset of the byte to access. `i` must be in the range
    ///   `0..<count`.
    @inlinable public subscript(i: Int) -> UnsafeMutableRawBufferPointer.Element { get nonmutating set }

    /// Accesses the bytes in the specified memory region.
    ///
    /// - Parameter bounds: The range of byte offsets to access. The upper and
    ///   lower bounds of the range must be in the range `0...count`.
    @inlinable public subscript(bounds: Range<Int>) -> UnsafeMutableRawBufferPointer.SubSequence { get nonmutating set }

    /// Exchanges the byte values at the specified indices
    /// in this buffer's memory.
    ///
    /// Both parameters must be valid indices of the buffer, and not
    /// equal to `endIndex`. Passing the same index as both `i` and `j` has no
    /// effect.
    ///
    /// - Parameters:
    ///   - i: The index of the first byte to swap.
    ///   - j: The index of the second byte to swap.
    @inlinable public func swapAt(_ i: Int, _ j: Int)

    /// The number of bytes in the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    @inlinable public var count: Int { get }
}

extension UnsafeMutableRawBufferPointer : Sequence {

    /// A sequence that represents a contiguous subrange of the collection's
    /// elements.
    ///
    /// This associated type appears as a requirement in the `Sequence`
    /// protocol, but it is restated here with stricter constraints. In a
    /// collection, the subsequence should also conform to `Collection`.
    public typealias SubSequence = Slice<UnsafeMutableRawBufferPointer>

    /// Returns an iterator over the bytes of this sequence.
    @inlinable public func makeIterator() -> UnsafeMutableRawBufferPointer.Iterator
}

extension UnsafeMutableRawBufferPointer : CustomDebugStringConvertible {

    /// A textual representation of the buffer, suitable for debugging.
    public var debugDescription: String { get }
}

/// A  nonowning collection interface to the bytes in a
/// region of memory.
///
/// You can use an `UnsafeRawBufferPointer` instance in low-level operations to eliminate
/// uniqueness checks and release mode bounds checks. Bounds checks are always
/// performed in debug mode.
///
/// An `UnsafeRawBufferPointer` instance is a view of the raw bytes in a region of memory.
/// Each byte in memory is viewed as a `UInt8` value independent of the type
/// of values held in that memory. Reading from memory through a raw buffer is
/// an untyped operation.
///
/// In addition to its collection interface, an `UnsafeRawBufferPointer` instance also supports
/// the `load(fromByteOffset:as:)` method provided by `UnsafeRawPointer`,
/// including bounds checks in debug mode.
///
/// To access the underlying memory through typed operations, the memory must
/// be bound to a trivial type.
///
/// - Note: A *trivial type* can be copied bit for bit with no indirection
///   or reference-counting operations. Generally, native Swift types that do
///   not contain strong or weak references or other forms of indirection are
///   trivial, as are imported C structs and enums. Copying memory that
///   contains values of nontrivial types can only be done safely with a typed
///   pointer. Copying bytes directly from nontrivial, in-memory values does
///   not produce valid copies and can only be done by calling a C API, such as
///   `memmove()`.
///
/// UnsafeRawBufferPointer Semantics
/// =================
///
/// An `UnsafeRawBufferPointer` instance is a view into memory and does not own the memory
/// that it references. Copying a variable or constant of type `UnsafeRawBufferPointer` does
/// not copy the underlying memory. However, initializing another collection
/// with an `UnsafeRawBufferPointer` instance copies bytes out of the referenced memory and
/// into the new collection.
///
/// The following example uses `someBytes`, an `UnsafeRawBufferPointer` instance, to
/// demonstrate the difference between assigning a buffer pointer and using a
/// buffer pointer as the source for another collection's elements. Here, the
/// assignment to `destBytes` creates a new, nonowning buffer pointer
/// covering the first `n` bytes of the memory that `someBytes`
/// references---nothing is copied:
///
///     var destBytes = someBytes[0..<n]
///
/// Next, the bytes referenced by `destBytes` are copied into `byteArray`, a
/// new `[UInt8]` array, and then the remainder of `someBytes` is appended to
/// `byteArray`:
///
///     var byteArray: [UInt8] = Array(destBytes)
///     byteArray += someBytes[n..<someBytes.count]
@frozen public struct UnsafeRawBufferPointer {

    /// An iterator over the bytes viewed by a raw buffer pointer.
    @frozen public struct Iterator {
    }

    /// Deallocates the memory block previously allocated at this buffer pointer’s
    /// base address.
    ///
    /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory
    /// block previously returned by a Swift allocation method. If `baseAddress` is
    /// `nil`, this function does nothing. Otherwise, the memory must not be initialized
    /// or `Pointee` must be a trivial type. This buffer pointer's byte `count` must
    /// be equal to the originally allocated size of the memory block.
    @inlinable public func deallocate()

    /// Returns a new instance of the given type, read from the buffer pointer's
    /// raw memory at the specified byte offset.
    ///
    /// You can use this method to create new values from the buffer pointer's
    /// underlying bytes. The following example creates two new `Int32`
    /// instances from the memory referenced by the buffer pointer `someBytes`.
    /// The bytes for `a` are copied from the first four bytes of `someBytes`,
    /// and the bytes for `b` are copied from the next four bytes.
    ///
    ///     let a = someBytes.load(as: Int32.self)
    ///     let b = someBytes.load(fromByteOffset: 4, as: Int32.self)
    ///
    /// The memory to read for the new instance must not extend beyond the buffer
    /// pointer's memory region---that is, `offset + MemoryLayout<T>.size` must
    /// be less than or equal to the buffer pointer's `count`.
    ///
    /// - Parameters:
    ///   - offset: The offset, in bytes, into the buffer pointer's memory at
    ///     which to begin reading data for the new instance. The buffer pointer
    ///     plus `offset` must be properly aligned for accessing an instance of
    ///     type `T`. The default is zero.
    ///   - type: The type to use for the newly constructed instance. The memory
    ///     must be initialized to a value of a type that is layout compatible
    ///     with `type`.
    /// - Returns: A new instance of type `T`, copied from the buffer pointer's
    ///   memory.
    @inlinable public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T

    /// Creates a buffer over the specified number of contiguous bytes starting
    /// at the given pointer.
    ///
    /// - Parameters:
    ///   - start: The address of the memory that starts the buffer. If `starts`
    ///     is `nil`, `count` must be zero. However, `count` may be zero even
    ///     for a non-`nil` `start`.
    ///   - count: The number of bytes to include in the buffer. `count` must not
    ///     be negative.
    @inlinable public init(start: UnsafeRawPointer?, count: Int)

    /// Creates a new buffer over the same memory as the given buffer.
    ///
    /// - Parameter bytes: The buffer to convert.
    @inlinable public init(_ bytes: UnsafeMutableRawBufferPointer)

    /// Creates a new buffer over the same memory as the given buffer.
    ///
    /// - Parameter bytes: The buffer to convert.
    @inlinable public init(_ bytes: UnsafeRawBufferPointer)

    /// Creates a raw buffer over the contiguous bytes in the given typed buffer.
    ///
    /// - Parameter buffer: The typed buffer to convert to a raw buffer. The
    ///   buffer's type `T` must be a trivial type.
    @inlinable public init<T>(_ buffer: UnsafeMutableBufferPointer<T>)

    /// Creates a raw buffer over the contiguous bytes in the given typed buffer.
    ///
    /// - Parameter buffer: The typed buffer to convert to a raw buffer. The
    ///   buffer's type `T` must be a trivial type.
    @inlinable public init<T>(_ buffer: UnsafeBufferPointer<T>)

    /// Creates a raw buffer over the same memory as the given raw buffer slice,
    /// with the indices rebased to zero.
    ///
    /// The new buffer represents the same region of memory as the slice, but its
    /// indices start at zero instead of at the beginning of the slice in the
    /// original buffer. The following code creates `slice`, a slice covering
    /// part of an existing buffer instance, then rebases it into a new `rebased`
    /// buffer.
    ///
    ///     let slice = buffer[n...]
    ///     let rebased = UnsafeRawBufferPointer(rebasing: slice)
    ///
    /// After this code has executed, the following are true:
    ///
    /// - `rebased.startIndex == 0`
    /// - `rebased[0] == slice[n]`
    /// - `rebased[0] == buffer[n]`
    /// - `rebased.count == slice.count`
    ///
    /// - Parameter slice: The raw buffer slice to rebase.
    @inlinable public init(rebasing slice: Slice<UnsafeRawBufferPointer>)

    /// Creates a raw buffer over the same memory as the given raw buffer slice,
    /// with the indices rebased to zero.
    ///
    /// The new buffer represents the same region of memory as the slice, but its
    /// indices start at zero instead of at the beginning of the slice in the
    /// original buffer. The following code creates `slice`, a slice covering
    /// part of an existing buffer instance, then rebases it into a new `rebased`
    /// buffer.
    ///
    ///     let slice = buffer[n...]
    ///     let rebased = UnsafeRawBufferPointer(rebasing: slice)
    ///
    /// After this code has executed, the following are true:
    ///
    /// - `rebased.startIndex == 0`
    /// - `rebased[0] == slice[n]`
    /// - `rebased[0] == buffer[n]`
    /// - `rebased.count == slice.count`
    ///
    /// - Parameter slice: The raw buffer slice to rebase.
    @inlinable public init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>)

    /// A pointer to the first byte of the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    @inlinable public var baseAddress: UnsafeRawPointer? { get }

    /// Binds this buffer’s memory to the specified type and returns a typed buffer
    /// of the bound memory.
    ///
    /// Use the `bindMemory(to:)` method to bind the memory referenced
    /// by this buffer to the type `T`. The memory must be uninitialized or
    /// initialized to a type that is layout compatible with `T`. If the memory
    /// is uninitialized, it is still uninitialized after being bound to `T`.
    ///
    /// - Warning: A memory location may only be bound to one type at a time. The
    ///   behavior of accessing memory as a type unrelated to its bound type is
    ///   undefined.
    ///
    /// - Parameters:
    ///   - type: The type `T` to bind the memory to.
    /// - Returns: A typed buffer of the newly bound memory. The memory in this
    ///   region is bound to `T`, but has not been modified in any other way.
    ///   The typed buffer references `self.count / MemoryLayout<T>.stride` instances of `T`.
    public func bindMemory<T>(to type: T.Type) -> UnsafeBufferPointer<T>

    /// Returns a subsequence containing all but the specified number of final
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in the
    /// collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropLast(2))
    ///     // Prints "[1, 2, 3]"
    ///     print(numbers.dropLast(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop off the end of the
    ///   collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence that leaves off `k` elements from the end.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop.
    @inlinable public func dropLast(_ k: Int) -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence, up to the given maximum length, containing the
    /// final elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains the entire collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.suffix(2))
    ///     // Prints "[4, 5]"
    ///     print(numbers.suffix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence terminating at the end of the collection with at
    ///   most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is equal to
    ///   `maxLength`.
    @inlinable public func suffix(_ maxLength: Int) -> Slice<UnsafeRawBufferPointer>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    @inlinable public func map<T>(_ transform: (UInt8) throws -> T) rethrows -> [T]

    /// Returns a subsequence containing all but the given number of initial
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in
    /// the collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropFirst(2))
    ///     // Prints "[3, 4, 5]"
    ///     print(numbers.dropFirst(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop from the beginning of
    ///   the collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence starting after the specified number of
    ///   elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop from the beginning of the collection.
    @inlinable public func dropFirst(_ k: Int = 1) -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence by skipping elements while `predicate` returns
    /// `true` and returning the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be skipped or `false` if it should be included. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func drop(while predicate: (UInt8) throws -> Bool) rethrows -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence, up to the specified maximum length, containing
    /// the initial elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains all the elements in the collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.prefix(2))
    ///     // Prints "[1, 2]"
    ///     print(numbers.prefix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence starting at the beginning of this collection
    ///   with at most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to select from the beginning of the collection.
    @inlinable public func prefix(_ maxLength: Int) -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence containing the initial elements until `predicate`
    /// returns `false` and skipping the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be included or `false` if it should be excluded. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func prefix(while predicate: (UInt8) throws -> Bool) rethrows -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence from the start of the collection up to, but not
    /// including, the specified position.
    ///
    /// The resulting subsequence *does not include* the element at the position
    /// `end`. The following example searches for the index of the number `40`
    /// in an array of integers, and then prints the prefix of the array up to,
    /// but not including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(upTo: i))
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// Passing the collection's starting index as the `end` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.prefix(upTo: numbers.startIndex))
    ///     // Prints "[]"
    ///
    /// Using the `prefix(upTo:)` method is equivalent to using a partial
    /// half-open range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(upTo:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[..<i])
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter end: The "past the end" index of the resulting subsequence.
    ///   `end` must be a valid index of the collection.
    /// - Returns: A subsequence up to, but not including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(upTo end: Int) -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence from the specified position to the end of the
    /// collection.
    ///
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the suffix of the array starting at
    /// that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.suffix(from: i))
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// Passing the collection's `endIndex` as the `start` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.suffix(from: numbers.endIndex))
    ///     // Prints "[]"
    ///
    /// Using the `suffix(from:)` method is equivalent to using a partial range
    /// from the index as the collection's subscript. The subscript notation is
    /// preferred over `suffix(from:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[i...])
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// - Parameter start: The index at which to start the resulting subsequence.
    ///   `start` must be a valid index of the collection.
    /// - Returns: A subsequence starting at the `start` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func suffix(from start: Int) -> Slice<UnsafeRawBufferPointer>

    /// Returns a subsequence from the start of the collection through the
    /// specified position.
    ///
    /// The resulting subsequence *includes* the element at the position `end`.
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the prefix of the array up to, and
    /// including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(through: i))
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// Using the `prefix(through:)` method is equivalent to using a partial
    /// closed range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(through:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[...i])
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter end: The index of the last element to include in the
    ///   resulting subsequence. `end` must be a valid index of the collection
    ///   that is not equal to the `endIndex` property.
    /// - Returns: A subsequence up to, and including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(through position: Int) -> Slice<UnsafeRawBufferPointer>

    /// Returns the longest possible subsequences of the collection, in order,
    /// that don't contain elements satisfying the given predicate.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string using a
    /// closure that matches spaces. The first use of `split` returns each word
    /// that was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(maxSplits: 1, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(omittingEmptySubsequences: false, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each pair of consecutive elements
    ///     satisfying the `isSeparator` predicate and for each element at the
    ///     start or end of the collection satisfying the `isSeparator`
    ///     predicate. The default value is `true`.
    ///   - isSeparator: A closure that takes an element as an argument and
    ///     returns a Boolean value indicating whether the collection should be
    ///     split at that element.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (UInt8) throws -> Bool) rethrows -> [Slice<UnsafeRawBufferPointer>]

    /// Returns the longest possible subsequences of the collection, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the collection are not returned as part
    /// of any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " "))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the collection and for each instance of `separator` at
    ///     the start or end of the collection. If `true`, only nonempty
    ///     subsequences are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(separator: UInt8, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Slice<UnsafeRawBufferPointer>]

    /// The last element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let lastNumber = numbers.last {
    ///         print(lastNumber)
    ///     }
    ///     // Prints "50"
    ///
    /// - Complexity: O(1)
    @inlinable public var last: UInt8? { get }

    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `firstIndex(of:)` to find the position of a particular element
    /// in a collection, you can use it to access the element by subscripting.
    /// This example shows how you can modify one of the names in an array of
    /// students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Maxime"]
    ///     if let i = students.firstIndex(of: "Maxime") {
    ///         students[i] = "Max"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(of element: UInt8) -> Int?

    /// Returns the first index in which an element of the collection satisfies
    /// the given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. Here's an example that finds a student name that
    /// begins with the letter "A":
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.firstIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Abena starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the first element for which `predicate` returns
    ///   `true`. If no elements in the collection satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(where predicate: (UInt8) throws -> Bool) rethrows -> Int?

    /// Returns the last element of the sequence that satisfies the given
    /// predicate.
    ///
    /// This example uses the `last(where:)` method to find the last
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let lastNegative = numbers.last(where: { $0 < 0 }) {
    ///         print("The last negative number is \(lastNegative).")
    ///     }
    ///     // Prints "The last negative number is -6."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The last element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func last(where predicate: (UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the index of the last element in the collection that matches the
    /// given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. This example finds the index of the last name that
    /// begins with the letter *A:*
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.lastIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Akosua starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the last element in the collection that matches
    ///   `predicate`, or `nil` if no elements match.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(where predicate: (UInt8) throws -> Bool) rethrows -> Int?

    /// Returns the last index where the specified value appears in the
    /// collection.
    ///
    /// After using `lastIndex(of:)` to find the position of the last instance of
    /// a particular element in a collection, you can use it to access the
    /// element by subscripting. This example shows how you can modify one of
    /// the names in an array of students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Ben", "Maxime"]
    ///     if let i = students.lastIndex(of: "Ben") {
    ///         students[i] = "Benjamin"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Benjamin", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The last index where `element` is found. If `element` is not
    ///   found in the collection, this method returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(of element: UInt8) -> Int?

    /// Returns the elements of the sequence, shuffled using the given generator
    /// as a source for randomness.
    ///
    /// You use this method to randomize the elements of a sequence when you are
    /// using a custom random number generator. For example, you can shuffle the
    /// numbers between `0` and `9` by calling the `shuffled(using:)` method on
    /// that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled(using: &myGenerator)
    ///     // shuffledNumbers == [8, 9, 4, 3, 2, 6, 7, 0, 5, 1]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the sequence.
    /// - Returns: An array of this sequence's elements in a shuffled order.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    /// - Note: The algorithm used to shuffle a sequence may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public func shuffled<T>(using generator: inout T) -> [UInt8] where T : RandomNumberGenerator

    /// Returns the elements of the sequence, shuffled.
    ///
    /// For example, you can shuffle the numbers between `0` and `9` by calling
    /// the `shuffled()` method on that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled()
    ///     // shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]
    ///
    /// This method is equivalent to calling `shuffled(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Returns: A shuffled array of this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func shuffled() -> [UInt8]

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection, using the given predicate as an
    /// equivalence test.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///   - areEquivalent: A closure that returns a Boolean value indicating
    ///     whether two elements are equivalent.
    ///
    /// - Returns: The difference needed to produce the reciever's state from
    ///   the parameter's state.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C, by areEquivalent: (C.Element, UInt8) -> Bool) -> CollectionDifference<UInt8> where C : BidirectionalCollection, UInt8 == C.Element

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///
    /// - Returns: The difference needed to produce this collection's ordered
    ///   elements from the given collection.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements, or
    ///   if `Element` conforms to `Hashable`.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C) -> CollectionDifference<UInt8> where C : BidirectionalCollection, UInt8 == C.Element

    /// A sequence containing the same elements as this sequence,
    /// but on which some operations, such as `map` and `filter`, are
    /// implemented lazily.
    @inlinable public var lazy: LazySequence<UnsafeRawBufferPointer> { get }

    @available(swift, deprecated: 4.1, renamed: "compactMap(_:)", message: "Please use compactMap(_:) for the case where closure returns an optional value")
    public func flatMap<ElementOfResult>(_ transform: (UInt8) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the first index where the specified value appears in the
    /// collection.
    @available(swift, deprecated: 5.0, renamed: "firstIndex(of:)")
    @inlinable public func index(of element: UInt8) -> Int?

    /// Accesses the contiguous subrange of the collection's elements specified
    /// by a range expression.
    ///
    /// The range expression is converted to a concrete subrange relative to this
    /// collection. For example, using a `PartialRangeFrom` range expression
    /// with an array accesses the subrange from the start of the range
    /// expression until the end of the array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2...]
    ///     print(streetsSlice)
    ///     // ["Channing", "Douglas", "Evarts"]
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection uses. This example searches `streetsSlice` for one
    /// of the strings in the slice, and then uses that index in the original
    /// array.
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // "Evarts"
    ///
    /// Always use the slice's `startIndex` property instead of assuming that its
    /// indices start at a particular value. Attempting to access an element by
    /// using an index outside the bounds of the slice's indices may result in a
    /// runtime error, even if that index is valid for the original collection.
    ///
    ///     print(streetsSlice.startIndex)
    ///     // 2
    ///     print(streetsSlice[2])
    ///     // "Channing"
    ///
    ///     print(streetsSlice[0])
    ///     // error: Index out of bounds
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript<R>(r: R) -> Slice<UnsafeRawBufferPointer> where R : RangeExpression, Int == R.Bound { get }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> Slice<UnsafeRawBufferPointer> { get }

    /// Returns a view presenting the elements of the collection in reverse
    /// order.
    ///
    /// You can reverse a collection without allocating new space for its
    /// elements by calling this `reversed()` method. A `ReversedCollection`
    /// instance wraps an underlying collection and provides access to its
    /// elements in reverse order. This example prints the characters of a
    /// string in reverse order:
    ///
    ///     let word = "Backwards"
    ///     for char in word.reversed() {
    ///         print(char, terminator: "")
    ///     }
    ///     // Prints "sdrawkcaB"
    ///
    /// If you need a reversed collection of the same type, you may be able to
    /// use the collection's sequence-based or collection-based initializer. For
    /// example, to get the reversed version of a string, reverse its
    /// characters and initialize a new `String` instance from the result.
    ///
    ///     let reversedWord = String(word.reversed())
    ///     print(reversedWord)
    ///     // Prints "sdrawkcaB"
    ///
    /// - Complexity: O(1)
    @inlinable public func reversed() -> ReversedCollection<UnsafeRawBufferPointer>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func map<T>(_ transform: (UInt8) throws -> T) rethrows -> [T]

    /// Returns an array containing, in order, the elements of the sequence
    /// that satisfy the given predicate.
    ///
    /// In this example, `filter(_:)` is used to include only names shorter than
    /// five characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let shortNames = cast.filter { $0.count < 5 }
    ///     print(shortNames)
    ///     // Prints "["Kim", "Karl"]"
    ///
    /// - Parameter isIncluded: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be included in the returned array.
    /// - Returns: An array of the elements that `isIncluded` allowed.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func filter(_ isIncluded: (UInt8) throws -> Bool) rethrows -> [UInt8]

    /// A value less than or equal to the number of elements in the sequence,
    /// calculated nondestructively.
    ///
    /// The default implementation returns 0. If you provide your own
    /// implementation, make sure to compute the value nondestructively.
    ///
    /// - Complexity: O(1), except if the sequence also conforms to `Collection`.
    ///   In this case, see the documentation of `Collection.underestimatedCount`.
    @inlinable public var underestimatedCount: Int { get }

    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEach(_ body: (UInt8) throws -> Void) rethrows

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `first(where:)` method to find the first
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let firstNegative = numbers.first(where: { $0 < 0 }) {
    ///         print("The first negative number is \(firstNegative).")
    ///     }
    ///     // Prints "The first negative number is -2."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The first element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func first(where predicate: (UInt8) throws -> Bool) rethrows -> UInt8?

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R?

    /// Returns a sequence of pairs (*n*, *x*), where *n* represents a
    /// consecutive integer starting at zero and *x* represents an element of
    /// the sequence.
    ///
    /// This example enumerates the characters of the string "Swift" and prints
    /// each character along with its place in the string.
    ///
    ///     for (n, c) in "Swift".enumerated() {
    ///         print("\(n): '\(c)'")
    ///     }
    ///     // Prints "0: 'S'"
    ///     // Prints "1: 'w'"
    ///     // Prints "2: 'i'"
    ///     // Prints "3: 'f'"
    ///     // Prints "4: 't'"
    ///
    /// When you enumerate a collection, the integer part of each pair is a counter
    /// for the enumeration, but is not necessarily the index of the paired value.
    /// These counters can be used as indices only in instances of zero-based,
    /// integer-indexed collections, such as `Array` and `ContiguousArray`. For
    /// other collections the counters may be out of range or of the wrong type
    /// to use as an index. To iterate over the elements of a collection with its
    /// indices, use the `zip(_:_:)` function.
    ///
    /// This example iterates over the indices and elements of a set, building a
    /// list consisting of indices of names with five or fewer letters.
    ///
    ///     let names: Set = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     var shorterIndices: [Set<String>.Index] = []
    ///     for (i, name) in zip(names.indices, names) {
    ///         if name.count <= 5 {
    ///             shorterIndices.append(i)
    ///         }
    ///     }
    ///
    /// Now that the `shorterIndices` array holds the indices of the shorter
    /// names in the `names` set, you can use those indices to access elements in
    /// the set.
    ///
    ///     for i in shorterIndices {
    ///         print(names[i])
    ///     }
    ///     // Prints "Sofia"
    ///     // Prints "Mateo"
    ///
    /// - Returns: A sequence of pairs enumerating the sequence.
    ///
    /// - Complexity: O(1)
    @inlinable public func enumerated() -> EnumeratedSequence<UnsafeRawBufferPointer>

    /// Returns the minimum element in the sequence, using the given predicate as
    /// the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `min(by:)` method on a
    /// dictionary to find the key-value pair with the lowest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let leastHue = hues.min { a, b in a.value < b.value }
    ///     print(leastHue)
    ///     // Prints "Optional((key: "Coral", value: 16))"
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true`
    ///   if its first argument should be ordered before its second
    ///   argument; otherwise, `false`.
    /// - Returns: The sequence's minimum element, according to
    ///   `areInIncreasingOrder`. If the sequence has no elements, returns
    ///   `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the maximum element in the sequence, using the given predicate
    /// as the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `max(by:)` method on a
    /// dictionary to find the key-value pair with the highest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let greatestHue = hues.max { a, b in a.value < b.value }
    ///     print(greatestHue)
    ///     // Prints "Optional((key: "Heliotrope", value: 296))"
    ///
    /// - Parameter areInIncreasingOrder:  A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: The sequence's maximum element if the sequence is not empty;
    ///   otherwise, `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the minimum element in the sequence.
    ///
    /// This example finds the smallest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let lowestHeight = heights.min()
    ///     print(lowestHeight)
    ///     // Prints "Optional(58.5)"
    ///
    /// - Returns: The sequence's minimum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min() -> UInt8?

    /// Returns the maximum element in the sequence.
    ///
    /// This example finds the largest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let greatestHeight = heights.max()
    ///     print(greatestHeight)
    ///     // Prints "Optional(67.5)"
    ///
    /// - Returns: The sequence's maximum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max() -> UInt8?

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are equivalent to the elements in another sequence, using
    /// the given predicate as the equivalence test.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - possiblePrefix: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if the initial elements of the sequence are equivalent
    ///   to the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix, by areEquivalent: (UInt8, PossiblePrefix.Element) throws -> Bool) rethrows -> Bool where PossiblePrefix : Sequence

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are the same as the elements in another sequence.
    ///
    /// This example tests whether one countable range begins with the elements
    /// of another countable range.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(b.starts(with: a))
    ///     // Prints "true"
    ///
    /// Passing a sequence with no elements or an empty collection as
    /// `possiblePrefix` always results in `true`.
    ///
    ///     print(b.starts(with: []))
    ///     // Prints "true"
    ///
    /// - Parameter possiblePrefix: A sequence to compare to this sequence.
    /// - Returns: `true` if the initial elements of the sequence are the same as
    ///   the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, UInt8 == PossiblePrefix.Element

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain equivalent elements in the same order, using the given
    /// predicate as the equivalence test.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if this sequence and `other` contain equivalent items,
    ///   using `areEquivalent` as the equivalence test; otherwise, `false.`
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence, by areEquivalent: (UInt8, OtherSequence.Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain the same elements in the same order.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// This example tests whether one countable range shares the same elements
    /// as another countable range and an array.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(a.elementsEqual(b))
    ///     // Prints "false"
    ///     print(a.elementsEqual([1, 2, 3]))
    ///     // Prints "true"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence and `other` contain the same elements
    ///   in the same order.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the given
    /// predicate to compare elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areInIncreasingOrder:  A predicate that returns `true` if its first
    ///     argument should be ordered before its second argument; otherwise,
    ///     `false`.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering as ordered by `areInIncreasingOrder`; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that perform
    ///   localized comparison instead.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence, by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the
    /// less-than operator (`<`) to compare elements.
    ///
    /// This example uses the `lexicographicallyPrecedes` method to test which
    /// array of integers comes first in a lexicographical ordering.
    ///
    ///     let a = [1, 2, 2, 2]
    ///     let b = [1, 2, 3, 4]
    ///
    ///     print(a.lexicographicallyPrecedes(b))
    ///     // Prints "true"
    ///     print(b.lexicographicallyPrecedes(b))
    ///     // Prints "false"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that
    ///   perform localized comparison.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains an
    /// element that satisfies the given predicate.
    ///
    /// You can use the predicate to check for an element of a type that
    /// doesn't conform to the `Equatable` protocol, such as the
    /// `HTTPResponse` enumeration in this example.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]
    ///     let hadError = lastThreeResponses.contains { element in
    ///         if case .error = element {
    ///             return true
    ///         } else {
    ///             return false
    ///         }
    ///     }
    ///     // 'hadError' == true
    ///
    /// Alternatively, a predicate can be satisfied by a range of `Equatable`
    /// elements or a general condition. This example shows how you can check an
    /// array for an expense greater than $100.
    ///
    ///     let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
    ///     let hasBigPurchase = expenses.contains { $0 > 100 }
    ///     // 'hasBigPurchase' == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element represents a match.
    /// - Returns: `true` if the sequence contains an element that satisfies
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(where predicate: (UInt8) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether every element of a sequence
    /// satisfies a given predicate.
    ///
    /// The following code uses this method to test whether all the names in an
    /// array have at least five characters:
    ///
    ///     let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
    ///     // allHaveAtLeastFive == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element satisfies a condition.
    /// - Returns: `true` if the sequence contains only elements that satisfy
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func allSatisfy(_ predicate: (UInt8) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether the sequence contains the
    /// given element.
    ///
    /// This example checks to see whether a favorite actor is in an array
    /// storing a movie's cast.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     print(cast.contains("Marlon"))
    ///     // Prints "true"
    ///     print(cast.contains("James"))
    ///     // Prints "false"
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: `true` if the element was found in the sequence; otherwise,
    ///   `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(_ element: UInt8) -> Bool

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(_:_:)` method to produce a single value from the elements
    /// of an entire sequence. For example, you can use this method on an array
    /// of numbers to find their sum or product.
    ///
    /// The `nextPartialResult` closure is called sequentially with an
    /// accumulating value initialized to `initialResult` and each element of
    /// the sequence. This example shows how to find the sum of an array of
    /// numbers.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///     let numberSum = numbers.reduce(0, { x, y in
    ///         x + y
    ///     })
    ///     // numberSum == 10
    ///
    /// When `numbers.reduce(_:_:)` is called, the following steps occur:
    ///
    /// 1. The `nextPartialResult` closure is called with `initialResult`---`0`
    ///    in this case---and the first element of `numbers`, returning the sum:
    ///    `1`.
    /// 2. The closure is called again repeatedly with the previous call's return
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the last value returned from the
    ///    closure is returned to the caller.
    ///
    /// If the sequence has no elements, `nextPartialResult` is never executed
    /// and `initialResult` is the result of the call to `reduce(_:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///     `initialResult` is passed to `nextPartialResult` the first time the
    ///     closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and
    ///     an element of the sequence into a new accumulating value, to be used
    ///     in the next call of the `nextPartialResult` closure or returned to
    ///     the caller.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, UInt8) throws -> Result) rethrows -> Result

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(into:_:)` method to produce a single value from the
    /// elements of an entire sequence. For example, you can use this method on an
    /// array of integers to filter adjacent equal entries or count frequencies.
    ///
    /// This method is preferred over `reduce(_:_:)` for efficiency when the
    /// result is a copy-on-write type, for example an Array or a Dictionary.
    ///
    /// The `updateAccumulatingResult` closure is called sequentially with a
    /// mutable accumulating value initialized to `initialResult` and each element
    /// of the sequence. This example shows how to build a dictionary of letter
    /// frequencies of a string.
    ///
    ///     let letters = "abracadabra"
    ///     let letterCount = letters.reduce(into: [:]) { counts, letter in
    ///         counts[letter, default: 0] += 1
    ///     }
    ///     // letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1]
    ///
    /// When `letters.reduce(into:_:)` is called, the following steps occur:
    ///
    /// 1. The `updateAccumulatingResult` closure is called with the initial
    ///    accumulating value---`[:]` in this case---and the first character of
    ///    `letters`, modifying the accumulating value by setting `1` for the key
    ///    `"a"`.
    /// 2. The closure is called again repeatedly with the updated accumulating
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the accumulating value is returned to
    ///    the caller.
    ///
    /// If the sequence has no elements, `updateAccumulatingResult` is never
    /// executed and `initialResult` is the result of the call to
    /// `reduce(into:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating
    ///     value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, UInt8) throws -> ()) rethrows -> Result

    /// Returns an array containing the concatenated results of calling the
    /// given transformation with each element of this sequence.
    ///
    /// Use this method to receive a single-level collection when your
    /// transformation produces a sequence or collection for each element.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns an array.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///
    ///     let mapped = numbers.map { Array(repeating: $0, count: $0) }
    ///     // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
    ///
    ///     let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
    ///     // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
    ///
    /// In fact, `s.flatMap(transform)`  is equivalent to
    /// `Array(s.map(transform).joined())`.
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns a sequence or collection.
    /// - Returns: The resulting flattened array.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func flatMap<SegmentOfResult>(_ transform: (UInt8) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence

    /// Returns an array containing the non-`nil` results of calling the given
    /// transformation with each element of this sequence.
    ///
    /// Use this method to receive an array of non-optional values when your
    /// transformation produces an optional value.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `compactMap` with a transformation that returns an optional `Int` value.
    ///
    ///     let possibleNumbers = ["1", "2", "three", "///4///", "5"]
    ///
    ///     let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
    ///     // [1, 2, nil, nil, 5]
    ///
    ///     let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
    ///     // [1, 2, 5]
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-`nil` results of calling `transform`
    ///   with each element of the sequence.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func compactMap<ElementOfResult>(_ transform: (UInt8) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the elements of the sequence, sorted.
    ///
    /// You can sort any sequence of elements that conform to the `Comparable`
    /// protocol by calling this method. Elements are sorted in ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let sortedStudents = students.sorted()
    ///     print(sortedStudents)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your sequence in descending order, pass the
    /// greater-than operator (`>`) to the `sorted(by:)` method.
    ///
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted() -> [UInt8]

    /// Returns the elements of the sequence, sorted using the given predicate as
    /// the comparison between elements.
    ///
    /// When you want to sort a sequence of elements that don't conform to the
    /// `Comparable` protocol, pass a predicate to this method that returns
    /// `true` when the first element should be ordered before the second. The
    /// elements of the resulting array are ordered according to the given
    /// predicate.
    ///
    /// In the following example, the predicate provides an ordering for an array
    /// of a custom `HTTPResponse` type. The predicate orders errors before
    /// successes and sorts the error responses by their error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     let sortedResponses = responses.sorted {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(sortedResponses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// You also use this method to sort elements that conform to the
    /// `Comparable` protocol in descending order. To sort your sequence in
    /// descending order, pass the greater-than operator (`>`) as the
    /// `areInIncreasingOrder` parameter.
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// Calling the related `sorted()` method is equivalent to calling this
    /// method and passing the less-than operator (`<`) as the predicate.
    ///
    ///     print(students.sorted())
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///     print(students.sorted(by: <))
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> [UInt8]
}

/// Default implementation for bidirectional collections.
extension UnsafeRawBufferPointer {

    /// Replaces the given index with its predecessor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    @inlinable public func formIndex(before i: inout Int)
}

/// Default implementation for random access collections.
extension UnsafeRawBufferPointer {

    /// Returns an index that is the specified distance from the given index,
    /// unless that distance is beyond a given limiting index.
    ///
    /// The following example obtains an index advanced four positions from an
    /// array's starting index and then prints the element at that position. The
    /// operation doesn't require going beyond the limiting `numbers.endIndex`
    /// value, so it succeeds.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     let i = numbers.index(numbers.startIndex, offsetBy: 4)
    ///     print(numbers[i])
    ///     // Prints "50"
    ///
    /// The next example attempts to retrieve an index ten positions from
    /// `numbers.startIndex`, but fails, because that distance is beyond the
    /// index passed as `limit`.
    ///
    ///     let j = numbers.index(numbers.startIndex,
    ///                           offsetBy: 10,
    ///                           limitedBy: numbers.endIndex)
    ///     print(j)
    ///     // Prints "nil"
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the array.
    ///   - distance: The distance to offset `i`.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, `limit` should be greater than `i` to have any
    ///     effect. Likewise, if `distance < 0`, `limit` should be less than `i`
    ///     to have any effect.
    /// - Returns: An index offset by `distance` from the index `i`, unless that
    ///   index would be beyond `limit` in the direction of movement. In that
    ///   case, the method returns `nil`.
    ///
    /// - Complexity: O(1)
    @inlinable public func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int?
}

/// Default implementation for forward collections.
extension UnsafeRawBufferPointer {

    /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    @inlinable public func formIndex(after i: inout Int)

    /// Offsets the given index by the specified distance.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int)

    /// Offsets the given index by the specified distance, or so that it equals
    /// the given limiting index.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, a limit that is less than `i` has no effect.
    ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
    ///     effect.
    /// - Returns: `true` if `i` has been offset by exactly `distance` steps
    ///   without going beyond `limit`; otherwise, `false`. When the return
    ///   value is `false`, the value of `i` is equal to `limit`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int, limitedBy limit: Int) -> Bool

    /// Returns a random element of the collection, using the given generator as
    /// a source for randomness.
    ///
    /// Call `randomElement(using:)` to select a random element from an array or
    /// another collection when you are using a custom random number generator.
    /// This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement(using: &myGenerator)!
    ///     // randomName == "Amani"
    ///
    /// - Parameter generator: The random number generator to use when choosing a
    ///   random element.
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    /// - Note: The algorithm used to select a random element may change in a
    ///   future version of Swift. If you're passing a generator that results in
    ///   the same sequence of elements each time you run your program, that
    ///   sequence may change when your program is compiled using a different
    ///   version of Swift.
    @inlinable public func randomElement<T>(using generator: inout T) -> UInt8? where T : RandomNumberGenerator

    /// Returns a random element of the collection.
    ///
    /// Call `randomElement()` to select a random element from an array or
    /// another collection. This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement()!
    ///     // randomName == "Amani"
    ///
    /// This method is equivalent to calling `randomElement(using:)`, passing in
    /// the system's default random generator.
    ///
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public func randomElement() -> UInt8?
}

/// Supply the default "slicing" `subscript` for `Collection` models
/// that accept the default associated `SubSequence`, `Slice<Self>`.
extension UnsafeRawBufferPointer {

    /// Accesses a contiguous subrange of the collection's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice of an array of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2 ..< streets.endIndex]
    ///     print(streetsSlice)
    ///     // Prints "["Channing", "Douglas", "Evarts"]"
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // Prints "Evarts"
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeRawBufferPointer> { get }
}

/// Default implementations of core requirements
extension UnsafeRawBufferPointer {

    /// A Boolean value indicating whether the collection is empty.
    ///
    /// When you need to check whether your collection is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero. For collections that don't conform to
    /// `RandomAccessCollection`, accessing the `count` property iterates
    /// through the elements of the collection.
    ///
    ///     let horseName = "Silver"
    ///     if horseName.isEmpty {
    ///         print("My horse has no name.")
    ///     } else {
    ///         print("Hi ho, \(horseName)!")
    ///     }
    ///     // Prints "Hi ho, Silver!")
    ///
    /// - Complexity: O(1)
    @inlinable public var isEmpty: Bool { get }

    /// The first element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let firstNumber = numbers.first {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "10"
    @inlinable public var first: UInt8? { get }

    /// A value less than or equal to the number of elements in the collection.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var underestimatedCount: Int { get }

    /// The number of elements in the collection.
    ///
    /// To check whether a collection is empty, use its `isEmpty` property
    /// instead of comparing `count` to zero. Unless the collection guarantees
    /// random-access performance, calculating `count` can be an O(*n*)
    /// operation.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var count: Int { get }
}

extension UnsafeRawBufferPointer : Collection {

    /// A type representing the sequence's elements.
    public typealias Element = UInt8

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Range<Int>

    /// Always zero, which is the index of the first byte in a nonempty buffer.
    @inlinable public var startIndex: UnsafeRawBufferPointer.Index { get }

    /// The "past the end" position---that is, the position one greater than the
    /// last valid subscript argument.
    ///
    /// The `endIndex` property of an `UnsafeRawBufferPointer`
    /// instance is always identical to `count`.
    @inlinable public var endIndex: UnsafeRawBufferPointer.Index { get }

    /// The indices that are valid for subscripting the collection, in ascending
    /// order.
    ///
    /// A collection's `indices` property can hold a strong reference to the
    /// collection itself, causing the collection to be nonuniquely referenced.
    /// If you mutate the collection while iterating over its indices, a strong
    /// reference can result in an unexpected copy of the collection. To avoid
    /// the unexpected copy, use the `index(after:)` method starting with
    /// `startIndex` to produce indices instead.
    ///
    ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
    ///     var i = c.startIndex
    ///     while i != c.endIndex {
    ///         c[i] /= 5
    ///         i = c.index(after: i)
    ///     }
    ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
    @inlinable public var indices: UnsafeRawBufferPointer.Indices { get }

    /// Accesses the byte at the given offset in the memory region as a `UInt8`
    /// value.
    ///
    /// - Parameter i: The offset of the byte to access. `i` must be in the range
    ///   `0..<count`.
    @inlinable public subscript(i: Int) -> UnsafeRawBufferPointer.Element { get }

    /// Accesses the bytes in the specified memory region.
    ///
    /// - Parameter bounds: The range of byte offsets to access. The upper and
    ///   lower bounds of the range must be in the range `0...count`.
    @inlinable public subscript(bounds: Range<Int>) -> UnsafeRawBufferPointer.SubSequence { get }

    /// The number of bytes in the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    @inlinable public var count: Int { get }
}

extension UnsafeRawBufferPointer : Sequence {

    /// A sequence that represents a contiguous subrange of the collection's
    /// elements.
    ///
    /// This associated type appears as a requirement in the `Sequence`
    /// protocol, but it is restated here with stricter constraints. In a
    /// collection, the subsequence should also conform to `Collection`.
    public typealias SubSequence = Slice<UnsafeRawBufferPointer>

    /// Returns an iterator over the bytes of this sequence.
    @inlinable public func makeIterator() -> UnsafeRawBufferPointer.Iterator
}

extension UnsafeRawBufferPointer : CustomDebugStringConvertible {

    /// A textual representation of the buffer, suitable for debugging.
    public var debugDescription: String { get }
}

extension UnsafeRawBufferPointer.Iterator {

    /// Returns the elements of the sequence, shuffled using the given generator
    /// as a source for randomness.
    ///
    /// You use this method to randomize the elements of a sequence when you are
    /// using a custom random number generator. For example, you can shuffle the
    /// numbers between `0` and `9` by calling the `shuffled(using:)` method on
    /// that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled(using: &myGenerator)
    ///     // shuffledNumbers == [8, 9, 4, 3, 2, 6, 7, 0, 5, 1]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the sequence.
    /// - Returns: An array of this sequence's elements in a shuffled order.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    /// - Note: The algorithm used to shuffle a sequence may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public func shuffled<T>(using generator: inout T) -> [UInt8] where T : RandomNumberGenerator

    /// Returns the elements of the sequence, shuffled.
    ///
    /// For example, you can shuffle the numbers between `0` and `9` by calling
    /// the `shuffled()` method on that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled()
    ///     // shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]
    ///
    /// This method is equivalent to calling `shuffled(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Returns: A shuffled array of this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func shuffled() -> [UInt8]

    /// A sequence containing the same elements as this sequence,
    /// but on which some operations, such as `map` and `filter`, are
    /// implemented lazily.
    @inlinable public var lazy: LazySequence<UnsafeRawBufferPointer.Iterator> { get }

    @available(swift, deprecated: 4.1, renamed: "compactMap(_:)", message: "Please use compactMap(_:) for the case where closure returns an optional value")
    public func flatMap<ElementOfResult>(_ transform: (UInt8) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func map<T>(_ transform: (UInt8) throws -> T) rethrows -> [T]

    /// Returns an array containing, in order, the elements of the sequence
    /// that satisfy the given predicate.
    ///
    /// In this example, `filter(_:)` is used to include only names shorter than
    /// five characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let shortNames = cast.filter { $0.count < 5 }
    ///     print(shortNames)
    ///     // Prints "["Kim", "Karl"]"
    ///
    /// - Parameter isIncluded: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be included in the returned array.
    /// - Returns: An array of the elements that `isIncluded` allowed.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func filter(_ isIncluded: (UInt8) throws -> Bool) rethrows -> [UInt8]

    /// A value less than or equal to the number of elements in the sequence,
    /// calculated nondestructively.
    ///
    /// The default implementation returns 0. If you provide your own
    /// implementation, make sure to compute the value nondestructively.
    ///
    /// - Complexity: O(1), except if the sequence also conforms to `Collection`.
    ///   In this case, see the documentation of `Collection.underestimatedCount`.
    @inlinable public var underestimatedCount: Int { get }

    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEach(_ body: (UInt8) throws -> Void) rethrows

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `first(where:)` method to find the first
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let firstNegative = numbers.first(where: { $0 < 0 }) {
    ///         print("The first negative number is \(firstNegative).")
    ///     }
    ///     // Prints "The first negative number is -2."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The first element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func first(where predicate: (UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the longest possible subsequences of the sequence, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " ")
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1)
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false)
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the sequence, or one
    ///     less than the number of subsequences to return. If `maxSplits + 1`
    ///     subsequences are returned, the last one is a suffix of the original
    ///     sequence containing the remaining elements. `maxSplits` must be
    ///     greater than or equal to zero. The default value is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the sequence and for each instance of `separator` at the
    ///     start or end of the sequence. If `true`, only nonempty subsequences
    ///     are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func split(separator: UInt8, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [ArraySlice<UInt8>]

    /// Returns the longest possible subsequences of the sequence, in order, that
    /// don't contain elements satisfying the given predicate. Elements that are
    /// used to split the sequence are not returned as part of any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string using a
    /// closure that matches spaces. The first use of `split` returns each word
    /// that was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(whereSeparator: { $0 == " " })
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(
    ///        line.split(maxSplits: 1, whereSeparator: { $0 == " " })
    ///                       .map(String.init))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `true` for the `allowEmptySlices` parameter, so
    /// the returned array contains empty strings where spaces were repeated.
    ///
    ///     print(
    ///         line.split(
    ///             omittingEmptySubsequences: false,
    ///             whereSeparator: { $0 == " " }
    ///         ).map(String.init))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - maxSplits: The maximum number of times to split the sequence, or one
    ///     less than the number of subsequences to return. If `maxSplits + 1`
    ///     subsequences are returned, the last one is a suffix of the original
    ///     sequence containing the remaining elements. `maxSplits` must be
    ///     greater than or equal to zero. The default value is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each pair of consecutive elements
    ///     satisfying the `isSeparator` predicate and for each element at the
    ///     start or end of the sequence satisfying the `isSeparator` predicate.
    ///     If `true`, only nonempty subsequences are returned. The default
    ///     value is `true`.
    ///   - isSeparator: A closure that returns `true` if its argument should be
    ///     used to split the sequence; otherwise, `false`.
    /// - Returns: An array of subsequences, split from this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (UInt8) throws -> Bool) rethrows -> [ArraySlice<UInt8>]

    /// Returns a subsequence, up to the given maximum length, containing the
    /// final elements of the sequence.
    ///
    /// The sequence must be finite. If the maximum length exceeds the number of
    /// elements in the sequence, the result contains all the elements in the
    /// sequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.suffix(2))
    ///     // Prints "[4, 5]"
    ///     print(numbers.suffix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return. The
    ///   value of `maxLength` must be greater than or equal to zero.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func suffix(_ maxLength: Int) -> [UInt8]

    /// Returns a sequence containing all but the given number of initial
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in
    /// the sequence, the result is an empty sequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropFirst(2))
    ///     // Prints "[3, 4, 5]"
    ///     print(numbers.dropFirst(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop from the beginning of
    ///   the sequence. `k` must be greater than or equal to zero.
    /// - Returns: A sequence starting after the specified number of
    ///   elements.
    ///
    /// - Complexity: O(1), with O(*k*) deferred to each iteration of the result,
    ///   where *k* is the number of elements to drop from the beginning of
    ///   the sequence.
    @inlinable public func dropFirst(_ k: Int = 1) -> DropFirstSequence<UnsafeRawBufferPointer.Iterator>

    /// Returns a sequence containing all but the given number of final
    /// elements.
    ///
    /// The sequence must be finite. If the number of elements to drop exceeds
    /// the number of elements in the sequence, the result is an empty
    /// sequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropLast(2))
    ///     // Prints "[1, 2, 3]"
    ///     print(numbers.dropLast(10))
    ///     // Prints "[]"
    ///
    /// - Parameter n: The number of elements to drop off the end of the
    ///   sequence. `n` must be greater than or equal to zero.
    /// - Returns: A sequence leaving off the specified number of elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func dropLast(_ k: Int = 1) -> [UInt8]

    /// Returns a sequence by skipping the initial, consecutive elements that
    /// satisfy the given predicate.
    ///
    /// The following example uses the `drop(while:)` method to skip over the
    /// positive numbers at the beginning of the `numbers` array. The result
    /// begins with the first element of `numbers` that does not satisfy
    /// `predicate`.
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     let startingWithNegative = numbers.drop(while: { $0 > 0 })
    ///     // startingWithNegative == [-2, 9, -6, 10, 1]
    ///
    /// If `predicate` matches every element in the sequence, the result is an
    /// empty sequence.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element should be included in the result.
    /// - Returns: A sequence starting after the initial, consecutive elements
    ///   that satisfy `predicate`.
    ///
    /// - Complexity: O(*k*), where *k* is the number of elements to drop from
    ///   the beginning of the sequence.
    @inlinable public func drop(while predicate: (UInt8) throws -> Bool) rethrows -> DropWhileSequence<UnsafeRawBufferPointer.Iterator>

    /// Returns a sequence, up to the specified maximum length, containing the
    /// initial elements of the sequence.
    ///
    /// If the maximum length exceeds the number of elements in the sequence,
    /// the result contains all the elements in the sequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.prefix(2))
    ///     // Prints "[1, 2]"
    ///     print(numbers.prefix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return. The
    ///   value of `maxLength` must be greater than or equal to zero.
    /// - Returns: A sequence starting at the beginning of this sequence
    ///   with at most `maxLength` elements.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(_ maxLength: Int) -> PrefixSequence<UnsafeRawBufferPointer.Iterator>

    /// Returns a sequence containing the initial, consecutive elements that
    /// satisfy the given predicate.
    ///
    /// The following example uses the `prefix(while:)` method to find the
    /// positive numbers at the beginning of the `numbers` array. Every element
    /// of `numbers` up to, but not including, the first negative value is
    /// included in the result.
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     let positivePrefix = numbers.prefix(while: { $0 > 0 })
    ///     // positivePrefix == [3, 7, 4]
    ///
    /// If `predicate` matches every element in the sequence, the resulting
    /// sequence contains every element of the sequence.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element should be included in the result.
    /// - Returns: A sequence of the initial, consecutive elements that
    ///   satisfy `predicate`.
    ///
    /// - Complexity: O(*k*), where *k* is the length of the result.
    @inlinable public func prefix(while predicate: (UInt8) throws -> Bool) rethrows -> [UInt8]

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R?

    /// Returns a sequence of pairs (*n*, *x*), where *n* represents a
    /// consecutive integer starting at zero and *x* represents an element of
    /// the sequence.
    ///
    /// This example enumerates the characters of the string "Swift" and prints
    /// each character along with its place in the string.
    ///
    ///     for (n, c) in "Swift".enumerated() {
    ///         print("\(n): '\(c)'")
    ///     }
    ///     // Prints "0: 'S'"
    ///     // Prints "1: 'w'"
    ///     // Prints "2: 'i'"
    ///     // Prints "3: 'f'"
    ///     // Prints "4: 't'"
    ///
    /// When you enumerate a collection, the integer part of each pair is a counter
    /// for the enumeration, but is not necessarily the index of the paired value.
    /// These counters can be used as indices only in instances of zero-based,
    /// integer-indexed collections, such as `Array` and `ContiguousArray`. For
    /// other collections the counters may be out of range or of the wrong type
    /// to use as an index. To iterate over the elements of a collection with its
    /// indices, use the `zip(_:_:)` function.
    ///
    /// This example iterates over the indices and elements of a set, building a
    /// list consisting of indices of names with five or fewer letters.
    ///
    ///     let names: Set = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     var shorterIndices: [Set<String>.Index] = []
    ///     for (i, name) in zip(names.indices, names) {
    ///         if name.count <= 5 {
    ///             shorterIndices.append(i)
    ///         }
    ///     }
    ///
    /// Now that the `shorterIndices` array holds the indices of the shorter
    /// names in the `names` set, you can use those indices to access elements in
    /// the set.
    ///
    ///     for i in shorterIndices {
    ///         print(names[i])
    ///     }
    ///     // Prints "Sofia"
    ///     // Prints "Mateo"
    ///
    /// - Returns: A sequence of pairs enumerating the sequence.
    ///
    /// - Complexity: O(1)
    @inlinable public func enumerated() -> EnumeratedSequence<UnsafeRawBufferPointer.Iterator>

    /// Returns the minimum element in the sequence, using the given predicate as
    /// the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `min(by:)` method on a
    /// dictionary to find the key-value pair with the lowest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let leastHue = hues.min { a, b in a.value < b.value }
    ///     print(leastHue)
    ///     // Prints "Optional((key: "Coral", value: 16))"
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true`
    ///   if its first argument should be ordered before its second
    ///   argument; otherwise, `false`.
    /// - Returns: The sequence's minimum element, according to
    ///   `areInIncreasingOrder`. If the sequence has no elements, returns
    ///   `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the maximum element in the sequence, using the given predicate
    /// as the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `max(by:)` method on a
    /// dictionary to find the key-value pair with the highest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let greatestHue = hues.max { a, b in a.value < b.value }
    ///     print(greatestHue)
    ///     // Prints "Optional((key: "Heliotrope", value: 296))"
    ///
    /// - Parameter areInIncreasingOrder:  A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: The sequence's maximum element if the sequence is not empty;
    ///   otherwise, `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> UInt8?

    /// Returns the minimum element in the sequence.
    ///
    /// This example finds the smallest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let lowestHeight = heights.min()
    ///     print(lowestHeight)
    ///     // Prints "Optional(58.5)"
    ///
    /// - Returns: The sequence's minimum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min() -> UInt8?

    /// Returns the maximum element in the sequence.
    ///
    /// This example finds the largest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let greatestHeight = heights.max()
    ///     print(greatestHeight)
    ///     // Prints "Optional(67.5)"
    ///
    /// - Returns: The sequence's maximum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max() -> UInt8?

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are equivalent to the elements in another sequence, using
    /// the given predicate as the equivalence test.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - possiblePrefix: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if the initial elements of the sequence are equivalent
    ///   to the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix, by areEquivalent: (UInt8, PossiblePrefix.Element) throws -> Bool) rethrows -> Bool where PossiblePrefix : Sequence

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are the same as the elements in another sequence.
    ///
    /// This example tests whether one countable range begins with the elements
    /// of another countable range.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(b.starts(with: a))
    ///     // Prints "true"
    ///
    /// Passing a sequence with no elements or an empty collection as
    /// `possiblePrefix` always results in `true`.
    ///
    ///     print(b.starts(with: []))
    ///     // Prints "true"
    ///
    /// - Parameter possiblePrefix: A sequence to compare to this sequence.
    /// - Returns: `true` if the initial elements of the sequence are the same as
    ///   the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, UInt8 == PossiblePrefix.Element

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain equivalent elements in the same order, using the given
    /// predicate as the equivalence test.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if this sequence and `other` contain equivalent items,
    ///   using `areEquivalent` as the equivalence test; otherwise, `false.`
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence, by areEquivalent: (UInt8, OtherSequence.Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain the same elements in the same order.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// This example tests whether one countable range shares the same elements
    /// as another countable range and an array.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(a.elementsEqual(b))
    ///     // Prints "false"
    ///     print(a.elementsEqual([1, 2, 3]))
    ///     // Prints "true"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence and `other` contain the same elements
    ///   in the same order.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the given
    /// predicate to compare elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areInIncreasingOrder:  A predicate that returns `true` if its first
    ///     argument should be ordered before its second argument; otherwise,
    ///     `false`.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering as ordered by `areInIncreasingOrder`; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that perform
    ///   localized comparison instead.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence, by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the
    /// less-than operator (`<`) to compare elements.
    ///
    /// This example uses the `lexicographicallyPrecedes` method to test which
    /// array of integers comes first in a lexicographical ordering.
    ///
    ///     let a = [1, 2, 2, 2]
    ///     let b = [1, 2, 3, 4]
    ///
    ///     print(a.lexicographicallyPrecedes(b))
    ///     // Prints "true"
    ///     print(b.lexicographicallyPrecedes(b))
    ///     // Prints "false"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that
    ///   perform localized comparison.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, UInt8 == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains an
    /// element that satisfies the given predicate.
    ///
    /// You can use the predicate to check for an element of a type that
    /// doesn't conform to the `Equatable` protocol, such as the
    /// `HTTPResponse` enumeration in this example.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]
    ///     let hadError = lastThreeResponses.contains { element in
    ///         if case .error = element {
    ///             return true
    ///         } else {
    ///             return false
    ///         }
    ///     }
    ///     // 'hadError' == true
    ///
    /// Alternatively, a predicate can be satisfied by a range of `Equatable`
    /// elements or a general condition. This example shows how you can check an
    /// array for an expense greater than $100.
    ///
    ///     let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
    ///     let hasBigPurchase = expenses.contains { $0 > 100 }
    ///     // 'hasBigPurchase' == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element represents a match.
    /// - Returns: `true` if the sequence contains an element that satisfies
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(where predicate: (UInt8) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether every element of a sequence
    /// satisfies a given predicate.
    ///
    /// The following code uses this method to test whether all the names in an
    /// array have at least five characters:
    ///
    ///     let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
    ///     // allHaveAtLeastFive == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element satisfies a condition.
    /// - Returns: `true` if the sequence contains only elements that satisfy
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func allSatisfy(_ predicate: (UInt8) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether the sequence contains the
    /// given element.
    ///
    /// This example checks to see whether a favorite actor is in an array
    /// storing a movie's cast.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     print(cast.contains("Marlon"))
    ///     // Prints "true"
    ///     print(cast.contains("James"))
    ///     // Prints "false"
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: `true` if the element was found in the sequence; otherwise,
    ///   `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(_ element: UInt8) -> Bool

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(_:_:)` method to produce a single value from the elements
    /// of an entire sequence. For example, you can use this method on an array
    /// of numbers to find their sum or product.
    ///
    /// The `nextPartialResult` closure is called sequentially with an
    /// accumulating value initialized to `initialResult` and each element of
    /// the sequence. This example shows how to find the sum of an array of
    /// numbers.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///     let numberSum = numbers.reduce(0, { x, y in
    ///         x + y
    ///     })
    ///     // numberSum == 10
    ///
    /// When `numbers.reduce(_:_:)` is called, the following steps occur:
    ///
    /// 1. The `nextPartialResult` closure is called with `initialResult`---`0`
    ///    in this case---and the first element of `numbers`, returning the sum:
    ///    `1`.
    /// 2. The closure is called again repeatedly with the previous call's return
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the last value returned from the
    ///    closure is returned to the caller.
    ///
    /// If the sequence has no elements, `nextPartialResult` is never executed
    /// and `initialResult` is the result of the call to `reduce(_:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///     `initialResult` is passed to `nextPartialResult` the first time the
    ///     closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and
    ///     an element of the sequence into a new accumulating value, to be used
    ///     in the next call of the `nextPartialResult` closure or returned to
    ///     the caller.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, UInt8) throws -> Result) rethrows -> Result

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(into:_:)` method to produce a single value from the
    /// elements of an entire sequence. For example, you can use this method on an
    /// array of integers to filter adjacent equal entries or count frequencies.
    ///
    /// This method is preferred over `reduce(_:_:)` for efficiency when the
    /// result is a copy-on-write type, for example an Array or a Dictionary.
    ///
    /// The `updateAccumulatingResult` closure is called sequentially with a
    /// mutable accumulating value initialized to `initialResult` and each element
    /// of the sequence. This example shows how to build a dictionary of letter
    /// frequencies of a string.
    ///
    ///     let letters = "abracadabra"
    ///     let letterCount = letters.reduce(into: [:]) { counts, letter in
    ///         counts[letter, default: 0] += 1
    ///     }
    ///     // letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1]
    ///
    /// When `letters.reduce(into:_:)` is called, the following steps occur:
    ///
    /// 1. The `updateAccumulatingResult` closure is called with the initial
    ///    accumulating value---`[:]` in this case---and the first character of
    ///    `letters`, modifying the accumulating value by setting `1` for the key
    ///    `"a"`.
    /// 2. The closure is called again repeatedly with the updated accumulating
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the accumulating value is returned to
    ///    the caller.
    ///
    /// If the sequence has no elements, `updateAccumulatingResult` is never
    /// executed and `initialResult` is the result of the call to
    /// `reduce(into:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating
    ///     value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, UInt8) throws -> ()) rethrows -> Result

    /// Returns an array containing the elements of this sequence in reverse
    /// order.
    ///
    /// The sequence must be finite.
    ///
    /// - Returns: An array containing the elements of this sequence in
    ///   reverse order.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reversed() -> [UInt8]

    /// Returns an array containing the concatenated results of calling the
    /// given transformation with each element of this sequence.
    ///
    /// Use this method to receive a single-level collection when your
    /// transformation produces a sequence or collection for each element.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns an array.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///
    ///     let mapped = numbers.map { Array(repeating: $0, count: $0) }
    ///     // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
    ///
    ///     let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
    ///     // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
    ///
    /// In fact, `s.flatMap(transform)`  is equivalent to
    /// `Array(s.map(transform).joined())`.
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns a sequence or collection.
    /// - Returns: The resulting flattened array.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func flatMap<SegmentOfResult>(_ transform: (UInt8) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence

    /// Returns an array containing the non-`nil` results of calling the given
    /// transformation with each element of this sequence.
    ///
    /// Use this method to receive an array of non-optional values when your
    /// transformation produces an optional value.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `compactMap` with a transformation that returns an optional `Int` value.
    ///
    ///     let possibleNumbers = ["1", "2", "three", "///4///", "5"]
    ///
    ///     let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
    ///     // [1, 2, nil, nil, 5]
    ///
    ///     let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
    ///     // [1, 2, 5]
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-`nil` results of calling `transform`
    ///   with each element of the sequence.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func compactMap<ElementOfResult>(_ transform: (UInt8) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the elements of the sequence, sorted.
    ///
    /// You can sort any sequence of elements that conform to the `Comparable`
    /// protocol by calling this method. Elements are sorted in ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let sortedStudents = students.sorted()
    ///     print(sortedStudents)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your sequence in descending order, pass the
    /// greater-than operator (`>`) to the `sorted(by:)` method.
    ///
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted() -> [UInt8]

    /// Returns the elements of the sequence, sorted using the given predicate as
    /// the comparison between elements.
    ///
    /// When you want to sort a sequence of elements that don't conform to the
    /// `Comparable` protocol, pass a predicate to this method that returns
    /// `true` when the first element should be ordered before the second. The
    /// elements of the resulting array are ordered according to the given
    /// predicate.
    ///
    /// In the following example, the predicate provides an ordering for an array
    /// of a custom `HTTPResponse` type. The predicate orders errors before
    /// successes and sorts the error responses by their error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     let sortedResponses = responses.sorted {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(sortedResponses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// You also use this method to sort elements that conform to the
    /// `Comparable` protocol in descending order. To sort your sequence in
    /// descending order, pass the greater-than operator (`>`) as the
    /// `areInIncreasingOrder` parameter.
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// Calling the related `sorted()` method is equivalent to calling this
    /// method and passing the less-than operator (`<`) as the predicate.
    ///
    ///     print(students.sorted())
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///     print(students.sorted(by: <))
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted(by areInIncreasingOrder: (UInt8, UInt8) throws -> Bool) rethrows -> [UInt8]
}

/// A default makeIterator() function for `IteratorProtocol` instances that
/// are declared to conform to `Sequence`
extension UnsafeRawBufferPointer.Iterator {

    /// Returns an iterator over the elements of this sequence.
    @inlinable public func makeIterator() -> UnsafeRawBufferPointer.Iterator
}

extension UnsafeRawBufferPointer.Iterator : IteratorProtocol, Sequence {

    /// Advances to the next byte and returns it, or `nil` if no next byte
    /// exists.
    ///
    /// Once `nil` has been returned, all subsequent calls return `nil`.
    ///
    /// - Returns: The next sequential byte in the raw buffer if another byte
    ///   exists; otherwise, `nil`.
    @inlinable public mutating func next() -> UInt8?

    /// The type of element traversed by the iterator.
    public typealias Element = UInt8

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    public typealias Iterator = UnsafeRawBufferPointer.Iterator
}

/// Invokes the given closure with a mutable buffer pointer covering the raw
/// bytes of the given argument.
///
/// The buffer pointer argument to the `body` closure provides a collection
/// interface to the raw bytes of `value`. The buffer is the size of the
/// instance passed as `value` and does not include any remote storage.
///
/// - Parameters:
///   - value: An instance to temporarily access through a mutable raw buffer
///     pointer.
///     Note that the `inout` exclusivity rules mean that, like any other
///     `inout` argument, `value` cannot be directly accessed by other code
///     for the duration of `body`. Access must only occur through the pointer
///     argument to `body` until `body` returns.
///   - body: A closure that takes a raw buffer pointer to the bytes of `value`
///     as its sole argument. If the closure has a return value, that value is
///     also used as the return value of the `withUnsafeMutableBytes(of:_:)`
///     function. The buffer pointer argument is valid only for the duration
///     of the closure's execution.
/// - Returns: The return value, if any, of the `body` closure.
@inlinable public func withUnsafeMutableBytes<T, Result>(of value: inout T, _ body: (UnsafeMutableRawBufferPointer) throws -> Result) rethrows -> Result

/// Invokes the given closure with a buffer pointer covering the raw bytes of
/// the given argument.
///
/// The buffer pointer argument to the `body` closure provides a collection
/// interface to the raw bytes of `value`. The buffer is the size of the
/// instance passed as `value` and does not include any remote storage.
///
/// - Parameters:
///   - value: An instance to temporarily access through a raw buffer pointer.
///     Note that the `inout` exclusivity rules mean that, like any other
///     `inout` argument, `value` cannot be directly accessed by other code
///     for the duration of `body`. Access must only occur through the pointer
///     argument to `body` until `body` returns.
///   - body: A closure that takes a raw buffer pointer to the bytes of `value`
///     as its sole argument. If the closure has a return value, that value is
///     also used as the return value of the `withUnsafeBytes(of:_:)`
///     function. The buffer pointer argument is valid only for the duration
///     of the closure's execution. It is undefined behavior to attempt to
///     mutate through the pointer by conversion to
///     `UnsafeMutableRawBufferPointer` or any other mutable pointer type.
///     If you want to mutate a value by writing through a pointer, use
///     `withUnsafeMutableBytes(of:_:)` instead.
/// - Returns: The return value, if any, of the `body` closure.
@inlinable public func withUnsafeBytes<T, Result>(of value: inout T, _ body: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result

/// Invokes the given closure with a buffer pointer covering the raw bytes of
/// the given argument.
///
/// The buffer pointer argument to the `body` closure provides a collection
/// interface to the raw bytes of `value`. The buffer is the size of the
/// instance passed as `value` and does not include any remote storage.
///
/// - Parameters:
///   - value: An instance to temporarily access through a raw buffer pointer.
///   - body: A closure that takes a raw buffer pointer to the bytes of `value`
///     as its sole argument. If the closure has a return value, that value is
///     also used as the return value of the `withUnsafeBytes(of:_:)`
///     function. The buffer pointer argument is valid only for the duration
///     of the closure's execution. It is undefined behavior to attempt to
///     mutate through the pointer by conversion to
///     `UnsafeMutableRawBufferPointer` or any other mutable pointer type.
///     If you want to mutate a value by writing through a pointer, use
///     `withUnsafeMutableBytes(of:_:)` instead.
/// - Returns: The return value, if any, of the `body` closure.
@inlinable public func withUnsafeBytes<T, Result>(of value: T, _ body: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result

/// A raw pointer for accessing
/// untyped data.
///
/// The `UnsafeRawPointer` type provides no automated memory management, no type safety,
/// and no alignment guarantees. You are responsible for handling the life
/// cycle of any memory you work with through unsafe pointers, to avoid leaks
/// or undefined behavior.
///
/// Memory that you manually manage can be either *untyped* or *bound* to a
/// specific type. You use the `UnsafeRawPointer` type to access and
/// manage raw bytes in memory, whether or not that memory has been bound to a
/// specific type.
///
/// Understanding a Pointer's Memory State
/// ======================================
///
/// The memory referenced by an `UnsafeRawPointer` instance can be in one of several
/// states. Many pointer operations must only be applied to pointers with
/// memory in a specific state---you must keep track of the state of the
/// memory you are working with and understand the changes to that state that
/// different operations perform. Memory can be untyped and uninitialized,
/// bound to a type and uninitialized, or bound to a type and initialized to a
/// value. Finally, memory that was allocated previously may have been
/// deallocated, leaving existing pointers referencing unallocated memory.
///
/// Raw, Uninitialized Memory
/// -------------------------
///
/// Raw memory that has just been allocated is in an *uninitialized, untyped*
/// state. Uninitialized memory must be initialized with values of a type
/// before it can be used with any typed operations.
///
/// To bind uninitialized memory to a type without initializing it, use the
/// `bindMemory(to:count:)` method. This method returns a typed pointer
/// for further typed access to the memory.
///
/// Typed Memory
/// ------------
///
/// Memory that has been bound to a type, whether it is initialized or
/// uninitialized, is typically accessed using typed pointers---instances of
/// `UnsafePointer` and `UnsafeMutablePointer`. Initialization, assignment,
/// and deinitialization can be performed using `UnsafeMutablePointer`
/// methods.
///
/// Memory that has been bound to a type can be rebound to a different type
/// only after it has been deinitialized or if the bound type is a *trivial
/// type*. Deinitializing typed memory does not unbind that memory's type. The
/// deinitialized memory can be reinitialized with values of the same type,
/// bound to a new type, or deallocated.
///
/// - Note: A trivial type can be copied bit for bit with no indirection or
///   reference-counting operations. Generally, native Swift types that do not
///   contain strong or weak references or other forms of indirection are
///   trivial, as are imported C structs and enumerations.
///
/// When reading from  memory as raw
/// bytes when that memory is bound to a type, you must ensure that you
/// satisfy any alignment requirements.
///
/// Raw Pointer Arithmetic
/// ======================
///
/// Pointer arithmetic with raw pointers is performed at the byte level. When
/// you add to or subtract from a raw pointer, the result is a new raw pointer
/// offset by that number of bytes. The following example allocates four bytes
/// of memory and stores `0xFF` in all four bytes:
///
///     let bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: 4, alignment: 4)
///     bytesPointer.storeBytes(of: 0xFFFF_FFFF, as: UInt32.self)
///
///     // Load a value from the memory referenced by 'bytesPointer'
///     let x = bytesPointer.load(as: UInt8.self)       // 255
///
///     // Load a value from the last two allocated bytes
///     let offsetPointer = bytesPointer + 2
///     let y = offsetPointer.load(as: UInt16.self)     // 65535
///
/// The code above stores the value `0xFFFF_FFFF` into the four newly allocated
/// bytes, and then loads the first byte as a `UInt8` instance and the third
/// and fourth bytes as a `UInt16` instance.
///
/// Always remember to deallocate any memory that you allocate yourself.
///
///     bytesPointer.deallocate()
///
/// Implicit Casting and Bridging
/// =============================
///
/// When calling a function or method with an `UnsafeRawPointer` parameter, you can pass
/// an instance of that specific pointer type, pass an instance of a
/// compatible pointer type, or use Swift's implicit bridging to pass a
/// compatible pointer.
///
/// For example, the `print(address:as:)` function in the following code sample
/// takes an `UnsafeRawPointer` instance as its first parameter:
///
///     func print<T>(address p: UnsafeRawPointer, as type: T.Type) {
///         let value = p.load(as: type)
///         print(value)
///     }
///
/// As is typical in Swift, you can call the `print(address:as:)` function with
/// an `UnsafeRawPointer` instance. This example passes `rawPointer` as the initial
/// parameter.
///
///     // 'rawPointer' points to memory initialized with `Int` values.
///     let rawPointer: UnsafeRawPointer = ...
///     print(address: rawPointer, as: Int.self)
///     // Prints "42"
///
/// Because typed pointers can be implicitly cast to raw pointers when passed
/// as a parameter, you can also call `print(address:as:)` with any mutable or
/// immutable typed pointer instance.
///
///     let intPointer: UnsafePointer<Int> = ...
///     print(address: intPointer, as: Int.self)
///     // Prints "42"
///
///     let mutableIntPointer = UnsafeMutablePointer(mutating: intPointer)
///     print(address: mutableIntPointer, as: Int.self)
///     // Prints "42"
///
/// Alternatively, you can use Swift's *implicit bridging* to pass a pointer to
/// an instance or to the elements of an array. Use inout syntax to implicitly
/// create a pointer to an instance of any type. The following example uses
/// implicit bridging to pass a pointer to `value` when calling
/// `print(address:as:)`:
///
///     var value: Int = 23
///     print(address: &value, as: Int.self)
///     // Prints "23"
///
/// An immutable pointer to the elements of an array is implicitly created when
/// you pass the array as an argument. This example uses implicit bridging to
/// pass a pointer to the elements of `numbers` when calling
/// `print(address:as:)`.
///
///     let numbers = [5, 10, 15, 20]
///     print(address: numbers, as: Int.self)
///     // Prints "5"
///
/// You can also use inout syntax to pass a mutable pointer to the elements of
/// an array. Because `print(address:as:)` requires an immutable pointer,
/// although this is syntactically valid, it isn't necessary.
///
///     var mutableNumbers = numbers
///     print(address: &mutableNumbers, as: Int.self)
///
/// - Important: The pointer created through implicit bridging of an instance
///   or of an array's elements is only valid during the execution of the
///   called function. Escaping the pointer to use after the execution of the
///   function is undefined behavior. In particular, do not use implicit
///   bridging when calling an `UnsafeRawPointer` initializer.
///
///       var number = 5
///       let numberPointer = UnsafeRawPointer(&number)
///       // Accessing 'numberPointer' is undefined behavior.
@frozen public struct UnsafeRawPointer {

    public typealias Pointee = UInt8

    /// Creates a new raw pointer from the given typed pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init<T>(_ other: UnsafePointer<T>)

    /// Creates a new raw pointer from the given typed pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?<T>(_ other: UnsafePointer<T>?)

    /// Creates a new raw pointer from the given mutable raw pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The mutable raw pointer to convert.
    public init(_ other: UnsafeMutableRawPointer)

    /// Creates a new raw pointer from the given mutable raw pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The mutable raw pointer to convert. If `other` is
    ///   `nil`, the result is `nil`.
    public init?(_ other: UnsafeMutableRawPointer?)

    /// Creates a new raw pointer from the given typed pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init<T>(_ other: UnsafeMutablePointer<T>)

    /// Creates a new raw pointer from the given typed pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?<T>(_ other: UnsafeMutablePointer<T>?)

    /// Deallocates the previously allocated memory block referenced by this pointer.
    ///
    /// The memory to be deallocated must be uninitialized or initialized to a
    /// trivial type.
    @inlinable public func deallocate()

    /// Binds the memory to the specified type and returns a typed pointer to the
    /// bound memory.
    ///
    /// Use the `bindMemory(to:capacity:)` method to bind the memory referenced
    /// by this pointer to the type `T`. The memory must be uninitialized or
    /// initialized to a type that is layout compatible with `T`. If the memory
    /// is uninitialized, it is still uninitialized after being bound to `T`.
    ///
    /// In this example, 100 bytes of raw memory are allocated for the pointer
    /// `bytesPointer`, and then the first four bytes are bound to the `Int8`
    /// type.
    ///
    ///     let count = 4
    ///     let bytesPointer = UnsafeMutableRawPointer.allocate(
    ///             byteCount: 100,
    ///             alignment: MemoryLayout<Int8>.alignment)
    ///     let int8Pointer = bytesPointer.bindMemory(to: Int8.self, capacity: count)
    ///
    /// After calling `bindMemory(to:capacity:)`, the first four bytes of the
    /// memory referenced by `bytesPointer` are bound to the `Int8` type, though
    /// they remain uninitialized. The remainder of the allocated region is
    /// unbound raw memory. All 100 bytes of memory must eventually be
    /// deallocated.
    ///
    /// - Warning: A memory location may only be bound to one type at a time. The
    ///   behavior of accessing memory as a type unrelated to its bound type is
    ///   undefined.
    ///
    /// - Parameters:
    ///   - type: The type `T` to bind the memory to.
    ///   - count: The amount of memory to bind to type `T`, counted as instances
    ///     of `T`.
    /// - Returns: A typed pointer to the newly bound memory. The memory in this
    ///   region is bound to `T`, but has not been modified in any other way.
    ///   The number of bytes in this region is
    ///   `count * MemoryLayout<T>.stride`.
    public func bindMemory<T>(to type: T.Type, capacity count: Int) -> UnsafePointer<T>

    /// Returns a typed pointer to the memory referenced by this pointer,
    /// assuming that the memory is already bound to the specified type.
    ///
    /// Use this method when you have a raw pointer to memory that has *already*
    /// been bound to the specified type. The memory starting at this pointer
    /// must be bound to the type `T`. Accessing memory through the returned
    /// pointer is undefined if the memory has not been bound to `T`. To bind
    /// memory to `T`, use `bindMemory(to:capacity:)` instead of this method.
    ///
    /// - Parameter to: The type `T` that the memory has already been bound to.
    /// - Returns: A typed pointer to the same memory as this raw pointer.
    public func assumingMemoryBound<T>(to: T.Type) -> UnsafePointer<T>

    /// Returns a new instance of the given type, constructed from the raw memory
    /// at the specified offset.
    ///
    /// The memory at this pointer plus `offset` must be properly aligned for
    /// accessing `T` and initialized to `T` or another type that is layout
    /// compatible with `T`.
    ///
    /// - Parameters:
    ///   - offset: The offset from this pointer, in bytes. `offset` must be
    ///     nonnegative. The default is zero.
    ///   - type: The type of the instance to create.
    /// - Returns: A new instance of type `T`, read from the raw bytes at
    ///   `offset`. The returned instance is memory-managed and unassociated
    ///   with the value in the memory referenced by this pointer.
    @inlinable public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    public var hashValue: Int { get }

    /// Creates a new raw pointer from an `AutoreleasingUnsafeMutablePointer`
    /// instance.
    ///
    /// - Parameter other: The pointer to convert.
    public init<T>(_ other: AutoreleasingUnsafeMutablePointer<T>)

    /// Creates a new raw pointer from an `AutoreleasingUnsafeMutablePointer`
    /// instance.
    ///
    /// - Parameter other: The pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?<T>(_ other: AutoreleasingUnsafeMutablePointer<T>?)

    /// A custom playground Quick Look for this instance.
    ///
    /// If this type has value semantics, the `PlaygroundQuickLook` instance
    /// should be unaffected by subsequent mutations.
    @available(swift, deprecated: 4.2, message: "UnsafeRawPointer.customPlaygroundQuickLook will be removed in a future Swift version")
    public var customPlaygroundQuickLook: _PlaygroundQuickLook { get }

    /// Returns a closed range that contains both of its bounds.
    ///
    /// Use the closed range operator (`...`) to create a closed range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `ClosedRange<Character>` from "a" up to, and including, "z".
    ///
    ///     let lowercase = "a"..."z"
    ///     print(lowercase.contains("z"))
    ///     // Prints "true"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ... (minimum: UnsafeRawPointer, maximum: UnsafeRawPointer) -> ClosedRange<UnsafeRawPointer>

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than that of the second argument.
    ///
    /// This is the default implementation of the greater-than operator (`>`) for
    /// any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func > (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is less than or equal to that of the second argument.
    ///
    /// This is the default implementation of the less-than-or-equal-to
    /// operator (`<=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func <= (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than or equal to that of the second argument.
    ///
    /// This is the default implementation of the greater-than-or-equal-to operator
    /// (`>=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs`; otherwise,
    ///   `false`.
    @inlinable public static func >= (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Bool

    public static func != (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Bool

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer.
    public init(_ from: OpaquePointer)

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer. If
    ///   `from` is `nil`, the result of this initializer is `nil`.
    public init?(_ from: OpaquePointer?)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: Int)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: UInt)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init(_ other: UnsafeRawPointer)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?(_ other: UnsafeRawPointer?)

    /// Returns a Boolean value indicating whether two pointers are equal.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` and `rhs` reference the same memory address;
    ///   otherwise, `false`.
    public static func == (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Bool

    /// Returns a Boolean value indicating whether the first pointer references
    /// an earlier memory location than the second pointer.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` references a memory address earlier than
    ///   `rhs`; otherwise, `false`.
    public static func < (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Bool

    /// Returns a pointer to the next consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer advanced from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func successor() -> UnsafeRawPointer

    /// Returns a pointer to the previous consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer shifted backward from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func predecessor() -> UnsafeRawPointer

    /// Returns the distance from this pointer to the given pointer, counted as
    /// instances of the pointer's `Pointee` type.
    ///
    /// With pointers `p` and `q`, the result of `p.distance(to: q)` is
    /// equivalent to `q - p`.
    ///
    /// Typed pointers are required to be properly aligned for their `Pointee`
    /// type. Proper alignment ensures that the result of `distance(to:)`
    /// accurately measures the distance between the two pointers, counted in
    /// strides of `Pointee`. To find the distance in bytes between two
    /// pointers, convert them to `UnsafeRawPointer` instances before calling
    /// `distance(to:)`.
    ///
    /// - Parameter end: The pointer to calculate the distance to.
    /// - Returns: The distance from this pointer to `end`, in strides of the
    ///   pointer's `Pointee` type. To access the stride, use
    ///   `MemoryLayout<Pointee>.stride`.
    public func distance(to end: UnsafeRawPointer) -> Int

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    @inlinable public func hash(into hasher: inout Hasher)

    /// A textual representation of the pointer, suitable for debugging.
    public var debugDescription: String { get }

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror { get }

    public static func + (lhs: UnsafeRawPointer, rhs: Int) -> UnsafeRawPointer

    public static func + (lhs: Int, rhs: UnsafeRawPointer) -> UnsafeRawPointer

    public static func - (lhs: UnsafeRawPointer, rhs: Int) -> UnsafeRawPointer

    public static func - (lhs: UnsafeRawPointer, rhs: UnsafeRawPointer) -> Int

    public static func += (lhs: inout UnsafeRawPointer, rhs: Int)

    public static func -= (lhs: inout UnsafeRawPointer, rhs: Int)

    /// Returns a half-open range that contains its lower bound but not its upper
    /// bound.
    ///
    /// Use the half-open range operator (`..<`) to create a range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `Range<Double>` from zero up to, but not including, 5.0.
    ///
    ///     let lessThanFive = 0.0..<5.0
    ///     print(lessThanFive.contains(3.14))  // Prints "true"
    ///     print(lessThanFive.contains(5.0))   // Prints "false"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ..< (minimum: UnsafeRawPointer, maximum: UnsafeRawPointer) -> Range<UnsafeRawPointer>

    /// Returns a partial range up to, but not including, its upper bound.
    ///
    /// Use the prefix half-open range operator (prefix `..<`) to create a
    /// partial range of any type that conforms to the `Comparable` protocol.
    /// This example creates a `PartialRangeUpTo<Double>` instance that includes
    /// any value less than `5.0`.
    ///
    ///     let upToFive = ..<5.0
    ///
    ///     upToFive.contains(3.14)       // true
    ///     upToFive.contains(6.28)       // false
    ///     upToFive.contains(5.0)        // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, but not
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[..<3])
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ..< (maximum: UnsafeRawPointer) -> PartialRangeUpTo<UnsafeRawPointer>

    /// Returns a partial range up to, and including, its upper bound.
    ///
    /// Use the prefix closed range operator (prefix `...`) to create a partial
    /// range of any type that conforms to the `Comparable` protocol. This
    /// example creates a `PartialRangeThrough<Double>` instance that includes
    /// any value less than or equal to `5.0`.
    ///
    ///     let throughFive = ...5.0
    ///
    ///     throughFive.contains(4.0)     // true
    ///     throughFive.contains(5.0)     // true
    ///     throughFive.contains(6.0)     // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, and
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[...3])
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ... (maximum: UnsafeRawPointer) -> PartialRangeThrough<UnsafeRawPointer>

    /// Returns a partial range extending upward from a lower bound.
    ///
    /// Use the postfix range operator (postfix `...`) to create a partial range
    /// of any type that conforms to the `Comparable` protocol. This example
    /// creates a `PartialRangeFrom<Double>` instance that includes any value
    /// greater than or equal to `5.0`.
    ///
    ///     let atLeastFive = 5.0...
    ///
    ///     atLeastFive.contains(4.0)     // false
    ///     atLeastFive.contains(5.0)     // true
    ///     atLeastFive.contains(6.0)     // true
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the partial range's lower bound up to the end
    /// of the collection.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[3...])
    ///     // Prints "[40, 50, 60, 70]"
    ///
    /// - Parameter minimum: The lower bound for the range.
    ///
    /// - Precondition: `minimum` must compare equal to itself (i.e. cannot be NaN).
    postfix public static func ... (minimum: UnsafeRawPointer) -> PartialRangeFrom<UnsafeRawPointer>

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func < (x: UnsafeRawPointer, y: UnsafeRawPointer) -> Bool

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func == (x: UnsafeRawPointer, y: UnsafeRawPointer) -> Bool
}

extension UnsafeRawPointer : Strideable {

    /// Returns a value that is offset the specified distance from this value.
    ///
    /// Use the `advanced(by:)` method in generic code to offset a value by a
    /// specified distance. If you're working directly with numeric values, use
    /// the addition operator (`+`) instead of this method.
    ///
    ///     func addOne<T: Strideable>(to x: T) -> T
    ///         where T.Stride: ExpressibleByIntegerLiteral
    ///     {
    ///         return x.advanced(by: 1)
    ///     }
    ///
    ///     let x = addOne(to: 5)
    ///     // x == 6
    ///     let y = addOne(to: 3.5)
    ///     // y = 4.5
    ///
    /// If this type's `Stride` type conforms to `BinaryInteger`, then for a
    /// value `x`, a distance `n`, and a value `y = x.advanced(by: n)`,
    /// `x.distance(to: y) == n`. Using this method with types that have a
    /// noninteger `Stride` may result in an approximation.
    ///
    /// - Parameter n: The distance to advance this value.
    /// - Returns: A value that is offset from this value by `n`.
    ///
    /// - Complexity: O(1)
    public func advanced(by n: Int) -> UnsafeRawPointer

    /// A type that represents the distance between two values.
    public typealias Stride = Int
}

/// A raw pointer for accessing and manipulating
/// untyped data.
///
/// The `UnsafeMutableRawPointer` type provides no automated memory management, no type safety,
/// and no alignment guarantees. You are responsible for handling the life
/// cycle of any memory you work with through unsafe pointers, to avoid leaks
/// or undefined behavior.
///
/// Memory that you manually manage can be either *untyped* or *bound* to a
/// specific type. You use the `UnsafeMutableRawPointer` type to access and
/// manage raw bytes in memory, whether or not that memory has been bound to a
/// specific type.
///
/// Understanding a Pointer's Memory State
/// ======================================
///
/// The memory referenced by an `UnsafeMutableRawPointer` instance can be in one of several
/// states. Many pointer operations must only be applied to pointers with
/// memory in a specific state---you must keep track of the state of the
/// memory you are working with and understand the changes to that state that
/// different operations perform. Memory can be untyped and uninitialized,
/// bound to a type and uninitialized, or bound to a type and initialized to a
/// value. Finally, memory that was allocated previously may have been
/// deallocated, leaving existing pointers referencing unallocated memory.
///
/// Raw, Uninitialized Memory
/// -------------------------
///
/// Raw memory that has just been allocated is in an *uninitialized, untyped*
/// state. Uninitialized memory must be initialized with values of a type
/// before it can be used with any typed operations.
///
/// You can use methods like `initializeMemory(as:from:)` and
/// `moveInitializeMemory(as:from:count:)` to bind raw memory to a type and
/// initialize it with a value or series of values. To bind uninitialized
/// memory to a type without initializing it, use the `bindMemory(to:count:)`
/// method. These methods all return typed pointers for further typed access
/// to the memory.
///
/// Typed Memory
/// ------------
///
/// Memory that has been bound to a type, whether it is initialized or
/// uninitialized, is typically accessed using typed pointers---instances of
/// `UnsafePointer` and `UnsafeMutablePointer`. Initialization, assignment,
/// and deinitialization can be performed using `UnsafeMutablePointer`
/// methods.
///
/// Memory that has been bound to a type can be rebound to a different type
/// only after it has been deinitialized or if the bound type is a *trivial
/// type*. Deinitializing typed memory does not unbind that memory's type. The
/// deinitialized memory can be reinitialized with values of the same type,
/// bound to a new type, or deallocated.
///
/// - Note: A trivial type can be copied bit for bit with no indirection or
///   reference-counting operations. Generally, native Swift types that do not
///   contain strong or weak references or other forms of indirection are
///   trivial, as are imported C structs and enumerations.
///
/// When reading from or writing to  memory as raw
/// bytes when that memory is bound to a type, you must ensure that you
/// satisfy any alignment requirements.
/// Writing to typed memory as raw bytes must only be performed when the bound
/// type is a trivial type.
///
/// Raw Pointer Arithmetic
/// ======================
///
/// Pointer arithmetic with raw pointers is performed at the byte level. When
/// you add to or subtract from a raw pointer, the result is a new raw pointer
/// offset by that number of bytes. The following example allocates four bytes
/// of memory and stores `0xFF` in all four bytes:
///
///     let bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: 4, alignment: 1)
///     bytesPointer.storeBytes(of: 0xFFFF_FFFF, as: UInt32.self)
///
///     // Load a value from the memory referenced by 'bytesPointer'
///     let x = bytesPointer.load(as: UInt8.self)       // 255
///
///     // Load a value from the last two allocated bytes
///     let offsetPointer = bytesPointer + 2
///     let y = offsetPointer.load(as: UInt16.self)     // 65535
///
/// The code above stores the value `0xFFFF_FFFF` into the four newly allocated
/// bytes, and then loads the first byte as a `UInt8` instance and the third
/// and fourth bytes as a `UInt16` instance.
///
/// Always remember to deallocate any memory that you allocate yourself.
///
///     bytesPointer.deallocate()
///
/// Implicit Casting and Bridging
/// =============================
///
/// When calling a function or method with an `UnsafeMutableRawPointer` parameter, you can pass
/// an instance of that specific pointer type, pass an instance of a
/// compatible pointer type, or use Swift's implicit bridging to pass a
/// compatible pointer.
///
/// For example, the `print(address:as:)` function in the following code sample
/// takes an `UnsafeMutableRawPointer` instance as its first parameter:
///
///     func print<T>(address p: UnsafeMutableRawPointer, as type: T.Type) {
///         let value = p.load(as: type)
///         print(value)
///     }
///
/// As is typical in Swift, you can call the `print(address:as:)` function with
/// an `UnsafeMutableRawPointer` instance. This example passes `rawPointer` as the initial
/// parameter.
///
///     // 'rawPointer' points to memory initialized with `Int` values.
///     let rawPointer: UnsafeMutableRawPointer = ...
///     print(address: rawPointer, as: Int.self)
///     // Prints "42"
///
/// Because typed pointers can be implicitly cast to raw pointers when passed
/// as a parameter, you can also call `print(address:as:)` with any mutable
/// typed pointer instance.
///
///     let intPointer: UnsafeMutablePointer<Int> = ...
///     print(address: intPointer, as: Int.self)
///     // Prints "42"
///
/// Alternatively, you can use Swift's *implicit bridging* to pass a pointer to
/// an instance or to the elements of an array. Use inout syntax to implicitly
/// create a pointer to an instance of any type. The following example uses
/// implicit bridging to pass a pointer to `value` when calling
/// `print(address:as:)`:
///
///     var value: Int = 23
///     print(address: &value, as: Int.self)
///     // Prints "23"
///
/// A mutable pointer to the elements of an array is implicitly created when
/// you pass the array using inout syntax. This example uses implicit bridging
/// to pass a pointer to the elements of `numbers` when calling
/// `print(address:as:)`.
///
///     var numbers = [5, 10, 15, 20]
///     print(address: &numbers, as: Int.self)
///     // Prints "5"
///
/// - Important: The pointer created through implicit bridging of an instance
///   or of an array's elements is only valid during the execution of the
///   called function. Escaping the pointer to use after the execution of the
///   function is undefined behavior. In particular, do not use implicit
///   bridging when calling an `UnsafeMutableRawPointer` initializer.
///
///       var number = 5
///       let numberPointer = UnsafeMutableRawPointer(&number)
///       // Accessing 'numberPointer' is undefined behavior.
@frozen public struct UnsafeMutableRawPointer {

    public typealias Pointee = UInt8

    /// Creates a new raw pointer from the given typed pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeMutableRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init<T>(_ other: UnsafeMutablePointer<T>)

    /// Creates a new raw pointer from the given typed pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeMutableRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?<T>(_ other: UnsafeMutablePointer<T>?)

    /// Creates a new mutable raw pointer from the given immutable raw pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeMutableRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The immutable raw pointer to convert.
    public init(mutating other: UnsafeRawPointer)

    /// Creates a new mutable raw pointer from the given immutable raw pointer.
    ///
    /// Use this initializer to explicitly convert `other` to an `UnsafeMutableRawPointer`
    /// instance. This initializer creates a new pointer to the same address as
    /// `other` and performs no allocation or copying.
    ///
    /// - Parameter other: The immutable raw pointer to convert. If `other` is
    ///   `nil`, the result is `nil`.
    public init?(mutating other: UnsafeRawPointer?)

    /// Allocates uninitialized memory with the specified size and alignment.
    ///
    /// You are in charge of managing the allocated memory. Be sure to deallocate
    /// any memory that you manually allocate.
    ///
    /// The allocated memory is not bound to any specific type and must be bound
    /// before performing any typed operations. If you are using the memory for
    /// a specific type, allocate memory using the
    /// `UnsafeMutablePointer.allocate(capacity:)` static method instead.
    ///
    /// - Parameters:
    ///   - byteCount: The number of bytes to allocate. `byteCount` must not be negative.
    ///   - alignment: The alignment of the new region of allocated memory, in
    ///     bytes.
    /// - Returns: A pointer to a newly allocated region of memory. The memory is
    ///   allocated, but not initialized.
    @inlinable public static func allocate(byteCount: Int, alignment: Int) -> UnsafeMutableRawPointer

    /// Deallocates the previously allocated memory block referenced by this pointer.
    ///
    /// The memory to be deallocated must be uninitialized or initialized to a
    /// trivial type.
    @inlinable public func deallocate()

    /// Binds the memory to the specified type and returns a typed pointer to the
    /// bound memory.
    ///
    /// Use the `bindMemory(to:capacity:)` method to bind the memory referenced
    /// by this pointer to the type `T`. The memory must be uninitialized or
    /// initialized to a type that is layout compatible with `T`. If the memory
    /// is uninitialized, it is still uninitialized after being bound to `T`.
    ///
    /// In this example, 100 bytes of raw memory are allocated for the pointer
    /// `bytesPointer`, and then the first four bytes are bound to the `Int8`
    /// type.
    ///
    ///     let count = 4
    ///     let bytesPointer = UnsafeMutableRawPointer.allocate(
    ///             byteCount: 100,
    ///             alignment: MemoryLayout<Int8>.alignment)
    ///     let int8Pointer = bytesPointer.bindMemory(to: Int8.self, capacity: count)
    ///
    /// After calling `bindMemory(to:capacity:)`, the first four bytes of the
    /// memory referenced by `bytesPointer` are bound to the `Int8` type, though
    /// they remain uninitialized. The remainder of the allocated region is
    /// unbound raw memory. All 100 bytes of memory must eventually be
    /// deallocated.
    ///
    /// - Warning: A memory location may only be bound to one type at a time. The
    ///   behavior of accessing memory as a type unrelated to its bound type is
    ///   undefined.
    ///
    /// - Parameters:
    ///   - type: The type `T` to bind the memory to.
    ///   - count: The amount of memory to bind to type `T`, counted as instances
    ///     of `T`.
    /// - Returns: A typed pointer to the newly bound memory. The memory in this
    ///   region is bound to `T`, but has not been modified in any other way.
    ///   The number of bytes in this region is
    ///   `count * MemoryLayout<T>.stride`.
    public func bindMemory<T>(to type: T.Type, capacity count: Int) -> UnsafeMutablePointer<T>

    /// Returns a typed pointer to the memory referenced by this pointer,
    /// assuming that the memory is already bound to the specified type.
    ///
    /// Use this method when you have a raw pointer to memory that has *already*
    /// been bound to the specified type. The memory starting at this pointer
    /// must be bound to the type `T`. Accessing memory through the returned
    /// pointer is undefined if the memory has not been bound to `T`. To bind
    /// memory to `T`, use `bindMemory(to:capacity:)` instead of this method.
    ///
    /// - Parameter to: The type `T` that the memory has already been bound to.
    /// - Returns: A typed pointer to the same memory as this raw pointer.
    public func assumingMemoryBound<T>(to: T.Type) -> UnsafeMutablePointer<T>

    /// Initializes the memory referenced by this pointer with the given value,
    /// binds the memory to the value's type, and returns a typed pointer to the
    /// initialized memory.
    ///
    /// The memory referenced by this pointer must be uninitialized or
    /// initialized to a trivial type, and must be properly aligned for
    /// accessing `T`.
    ///
    /// The following example allocates enough raw memory to hold four instances
    /// of `Int8`, and then uses the `initializeMemory(as:repeating:count:)` method
    /// to initialize the allocated memory.
    ///
    ///     let count = 4
    ///     let bytesPointer = UnsafeMutableRawPointer.allocate(
    ///             byteCount: count * MemoryLayout<Int8>.stride,
    ///             alignment: MemoryLayout<Int8>.alignment)
    ///     let int8Pointer = bytesPointer.initializeMemory(
    ///             as: Int8.self, repeating: 0, count: count)
    ///
    ///     // After using 'int8Pointer':
    ///     int8Pointer.deallocate()
    ///
    /// After calling this method on a raw pointer `p`, the region starting at
    /// `self` and continuing up to `p + count * MemoryLayout<T>.stride` is bound
    /// to type `T` and initialized. If `T` is a nontrivial type, you must
    /// eventually deinitialize or move from the values in this region to avoid leaks.
    ///
    /// - Parameters:
    ///   - type: The type to bind this memory to.
    ///   - repeatedValue: The instance to copy into memory.
    ///   - count: The number of copies of `value` to copy into memory. `count`
    ///     must not be negative.
    /// - Returns: A typed pointer to the memory referenced by this raw pointer.
    @inlinable public func initializeMemory<T>(as type: T.Type, repeating repeatedValue: T, count: Int) -> UnsafeMutablePointer<T>

    /// Initializes the memory referenced by this pointer with the values
    /// starting at the given pointer, binds the memory to the values' type, and
    /// returns a typed pointer to the initialized memory.
    ///
    /// The memory referenced by this pointer must be uninitialized or
    /// initialized to a trivial type, and must be properly aligned for
    /// accessing `T`.
    ///
    /// The following example allocates enough raw memory to hold four instances
    /// of `Int8`, and then uses the `initializeMemory(as:from:count:)` method
    /// to initialize the allocated memory.
    ///
    ///     let count = 4
    ///     let bytesPointer = UnsafeMutableRawPointer.allocate(
    ///             byteCount: count * MemoryLayout<Int8>.stride,
    ///             alignment: MemoryLayout<Int8>.alignment)
    ///     let values: [Int8] = [1, 2, 3, 4]
    ///     let int8Pointer = values.withUnsafeBufferPointer { buffer in
    ///         return bytesPointer.initializeMemory(as: Int8.self,
    ///                   from: buffer.baseAddress!,
    ///                   count: buffer.count)
    ///     }
    ///     // int8Pointer.pointee == 1
    ///     // (int8Pointer + 3).pointee == 4
    ///
    ///     // After using 'int8Pointer':
    ///     int8Pointer.deallocate()
    ///
    /// After calling this method on a raw pointer `p`, the region starting at
    /// `p` and continuing up to `p + count * MemoryLayout<T>.stride` is bound
    /// to type `T` and initialized. If `T` is a nontrivial type, you must
    /// eventually deinitialize or move from the values in this region to avoid
    /// leaks. The instances in the region `source..<(source + count)` are
    /// unaffected.
    ///
    /// - Parameters:
    ///   - type: The type to bind this memory to.
    ///   - source: A pointer to the values to copy. The memory in the region
    ///     `source..<(source + count)` must be initialized to type `T` and must
    ///     not overlap the destination region.
    ///   - count: The number of copies of `value` to copy into memory. `count`
    ///     must not be negative.
    /// - Returns: A typed pointer to the memory referenced by this raw pointer.
    @inlinable public func initializeMemory<T>(as type: T.Type, from source: UnsafePointer<T>, count: Int) -> UnsafeMutablePointer<T>

    /// Initializes the memory referenced by this pointer with the values
    /// starting at the given pointer, binds the memory to the values' type,
    /// deinitializes the source memory, and returns a typed pointer to the
    /// newly initialized memory.
    ///
    /// The memory referenced by this pointer must be uninitialized or
    /// initialized to a trivial type, and must be properly aligned for
    /// accessing `T`.
    ///
    /// The memory in the region `source..<(source + count)` may overlap with the
    /// destination region. The `moveInitializeMemory(as:from:count:)` method
    /// automatically performs a forward or backward copy of all instances from
    /// the source region to their destination.
    ///
    /// After calling this method on a raw pointer `p`, the region starting at
    /// `p` and continuing up to `p + count * MemoryLayout<T>.stride` is bound
    /// to type `T` and initialized. If `T` is a nontrivial type, you must
    /// eventually deinitialize or move from the values in this region to avoid
    /// leaks. Any memory in the region `source..<(source + count)` that does
    /// not overlap with the destination region is returned to an uninitialized
    /// state.
    ///
    /// - Parameters:
    ///   - type: The type to bind this memory to.
    ///   - source: A pointer to the values to copy. The memory in the region
    ///     `source..<(source + count)` must be initialized to type `T`.
    ///   - count: The number of copies of `value` to copy into memory. `count`
    ///     must not be negative.
    /// - Returns: A typed pointer to the memory referenced by this raw pointer.
    @inlinable public func moveInitializeMemory<T>(as type: T.Type, from source: UnsafeMutablePointer<T>, count: Int) -> UnsafeMutablePointer<T>

    /// Returns a new instance of the given type, constructed from the raw memory
    /// at the specified offset.
    ///
    /// The memory at this pointer plus `offset` must be properly aligned for
    /// accessing `T` and initialized to `T` or another type that is layout
    /// compatible with `T`.
    ///
    /// - Parameters:
    ///   - offset: The offset from this pointer, in bytes. `offset` must be
    ///     nonnegative. The default is zero.
    ///   - type: The type of the instance to create.
    /// - Returns: A new instance of type `T`, read from the raw bytes at
    ///   `offset`. The returned instance is memory-managed and unassociated
    ///   with the value in the memory referenced by this pointer.
    @inlinable public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T

    /// Stores the given value's bytes into raw memory at the specified offset.
    ///
    /// The type `T` to be stored must be a trivial type. The memory at this
    /// pointer plus `offset` must be properly aligned for accessing `T`. The
    /// memory must also be uninitialized, initialized to `T`, or initialized to
    /// another trivial type that is layout compatible with `T`.
    ///
    /// After calling `storeBytes(of:toByteOffset:as:)`, the memory is
    /// initialized to the raw bytes of `value`. If the memory is bound to a
    /// type `U` that is layout compatible with `T`, then it contains a value of
    /// type `U`. Calling `storeBytes(of:toByteOffset:as:)` does not change the
    /// bound type of the memory.
    ///
    /// - Note: A trivial type can be copied with just a bit-for-bit copy without
    ///   any indirection or reference-counting operations. Generally, native
    ///   Swift types that do not contain strong or weak references or other
    ///   forms of indirection are trivial, as are imported C structs and enums.
    ///
    /// If you need to store a copy of a nontrivial value into memory, or to
    /// store a value into memory that contains a nontrivial value, you cannot
    /// use the `storeBytes(of:toByteOffset:as:)` method. Instead, you must know
    /// the type of value previously in memory and initialize or assign the
    /// memory. For example, to replace a value stored in a raw pointer `p`,
    /// where `U` is the current type and `T` is the new type, use a typed
    /// pointer to access and deinitialize the current value before initializing
    /// the memory with a new value.
    ///
    ///     let typedPointer = p.bindMemory(to: U.self, capacity: 1)
    ///     typedPointer.deinitialize(count: 1)
    ///     p.initializeMemory(as: T.self, repeating: newValue, count: 1)
    ///
    /// - Parameters:
    ///   - value: The value to store as raw bytes.
    ///   - offset: The offset from this pointer, in bytes. `offset` must be
    ///     nonnegative. The default is zero.
    ///   - type: The type of `value`.
    @inlinable public func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as type: T.Type)

    /// Copies the specified number of bytes from the given raw pointer's memory
    /// into this pointer's memory.
    ///
    /// If the `byteCount` bytes of memory referenced by this pointer are bound to
    /// a type `T`, then `T` must be a trivial type, this pointer and `source`
    /// must be properly aligned for accessing `T`, and `byteCount` must be a
    /// multiple of `MemoryLayout<T>.stride`.
    ///
    /// The memory in the region `source..<(source + byteCount)` may overlap with
    /// the memory referenced by this pointer.
    ///
    /// After calling `copyMemory(from:byteCount:)`, the `byteCount` bytes of
    /// memory referenced by this pointer are initialized to raw bytes. If the
    /// memory is bound to type `T`, then it contains values of type `T`.
    ///
    /// - Parameters:
    ///   - source: A pointer to the memory to copy bytes from. The memory in the
    ///     region `source..<(source + byteCount)` must be initialized to a
    ///     trivial type.
    ///   - byteCount: The number of bytes to copy. `byteCount` must not be negative.
    @inlinable public func copyMemory(from source: UnsafeRawPointer, byteCount: Int)

    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    ///
    /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    public var hashValue: Int { get }

    /// Creates a new raw pointer from an `AutoreleasingUnsafeMutablePointer`
    /// instance.
    ///
    /// - Parameter other: The pointer to convert.
    public init<T>(_ other: AutoreleasingUnsafeMutablePointer<T>)

    /// Creates a new raw pointer from an `AutoreleasingUnsafeMutablePointer`
    /// instance.
    ///
    /// - Parameter other: The pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?<T>(_ other: AutoreleasingUnsafeMutablePointer<T>?)

    /// A custom playground Quick Look for this instance.
    ///
    /// If this type has value semantics, the `PlaygroundQuickLook` instance
    /// should be unaffected by subsequent mutations.
    @available(swift, deprecated: 4.2, message: "UnsafeMutableRawPointer.customPlaygroundQuickLook will be removed in a future Swift version")
    public var customPlaygroundQuickLook: _PlaygroundQuickLook { get }

    /// Returns a closed range that contains both of its bounds.
    ///
    /// Use the closed range operator (`...`) to create a closed range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `ClosedRange<Character>` from "a" up to, and including, "z".
    ///
    ///     let lowercase = "a"..."z"
    ///     print(lowercase.contains("z"))
    ///     // Prints "true"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ... (minimum: UnsafeMutableRawPointer, maximum: UnsafeMutableRawPointer) -> ClosedRange<UnsafeMutableRawPointer>

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than that of the second argument.
    ///
    /// This is the default implementation of the greater-than operator (`>`) for
    /// any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func > (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is less than or equal to that of the second argument.
    ///
    /// This is the default implementation of the less-than-or-equal-to
    /// operator (`<=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func <= (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Bool

    /// Returns a Boolean value indicating whether the value of the first argument
    /// is greater than or equal to that of the second argument.
    ///
    /// This is the default implementation of the greater-than-or-equal-to operator
    /// (`>=`) for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: `true` if `lhs` is greater than or equal to `rhs`; otherwise,
    ///   `false`.
    @inlinable public static func >= (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Bool

    public static func != (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Bool

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer.
    public init(_ from: OpaquePointer)

    /// Creates a new typed pointer from the given opaque pointer.
    ///
    /// - Parameter from: The opaque pointer to convert to a typed pointer. If
    ///   `from` is `nil`, the result of this initializer is `nil`.
    public init?(_ from: OpaquePointer?)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: Int)

    /// Creates a new pointer from the given address, specified as a bit
    /// pattern.
    ///
    /// The address passed as `bitPattern` must have the correct alignment for
    /// the pointer's `Pointee` type. That is,
    /// `bitPattern % MemoryLayout<Pointee>.alignment` must be `0`.
    ///
    /// - Parameter bitPattern: A bit pattern to use for the address of the new
    ///   pointer. If `bitPattern` is zero, the result is `nil`.
    public init?(bitPattern: UInt)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert.
    public init(_ other: UnsafeMutableRawPointer)

    /// Creates a new pointer from the given pointer.
    ///
    /// - Parameter other: The typed pointer to convert. If `other` is `nil`, the
    ///   result is `nil`.
    public init?(_ other: UnsafeMutableRawPointer?)

    /// Returns a Boolean value indicating whether two pointers are equal.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` and `rhs` reference the same memory address;
    ///   otherwise, `false`.
    public static func == (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Bool

    /// Returns a Boolean value indicating whether the first pointer references
    /// an earlier memory location than the second pointer.
    ///
    /// - Parameters:
    ///   - lhs: A pointer.
    ///   - rhs: Another pointer.
    /// - Returns: `true` if `lhs` references a memory address earlier than
    ///   `rhs`; otherwise, `false`.
    public static func < (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Bool

    /// Returns a pointer to the next consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer advanced from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func successor() -> UnsafeMutableRawPointer

    /// Returns a pointer to the previous consecutive instance.
    ///
    /// The resulting pointer must be within the bounds of the same allocation as
    /// this pointer.
    ///
    /// - Returns: A pointer shifted backward from this pointer by
    ///   `MemoryLayout<Pointee>.stride` bytes.
    public func predecessor() -> UnsafeMutableRawPointer

    /// Returns the distance from this pointer to the given pointer, counted as
    /// instances of the pointer's `Pointee` type.
    ///
    /// With pointers `p` and `q`, the result of `p.distance(to: q)` is
    /// equivalent to `q - p`.
    ///
    /// Typed pointers are required to be properly aligned for their `Pointee`
    /// type. Proper alignment ensures that the result of `distance(to:)`
    /// accurately measures the distance between the two pointers, counted in
    /// strides of `Pointee`. To find the distance in bytes between two
    /// pointers, convert them to `UnsafeRawPointer` instances before calling
    /// `distance(to:)`.
    ///
    /// - Parameter end: The pointer to calculate the distance to.
    /// - Returns: The distance from this pointer to `end`, in strides of the
    ///   pointer's `Pointee` type. To access the stride, use
    ///   `MemoryLayout<Pointee>.stride`.
    public func distance(to end: UnsafeMutableRawPointer) -> Int

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    @inlinable public func hash(into hasher: inout Hasher)

    /// A textual representation of the pointer, suitable for debugging.
    public var debugDescription: String { get }

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror { get }

    public static func + (lhs: UnsafeMutableRawPointer, rhs: Int) -> UnsafeMutableRawPointer

    public static func + (lhs: Int, rhs: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer

    public static func - (lhs: UnsafeMutableRawPointer, rhs: Int) -> UnsafeMutableRawPointer

    public static func - (lhs: UnsafeMutableRawPointer, rhs: UnsafeMutableRawPointer) -> Int

    public static func += (lhs: inout UnsafeMutableRawPointer, rhs: Int)

    public static func -= (lhs: inout UnsafeMutableRawPointer, rhs: Int)

    /// Returns a half-open range that contains its lower bound but not its upper
    /// bound.
    ///
    /// Use the half-open range operator (`..<`) to create a range of any type
    /// that conforms to the `Comparable` protocol. This example creates a
    /// `Range<Double>` from zero up to, but not including, 5.0.
    ///
    ///     let lessThanFive = 0.0..<5.0
    ///     print(lessThanFive.contains(3.14))  // Prints "true"
    ///     print(lessThanFive.contains(5.0))   // Prints "false"
    ///
    /// - Parameters:
    ///   - minimum: The lower bound for the range.
    ///   - maximum: The upper bound for the range.
    ///
    /// - Precondition: `minimum <= maximum`.
    public static func ..< (minimum: UnsafeMutableRawPointer, maximum: UnsafeMutableRawPointer) -> Range<UnsafeMutableRawPointer>

    /// Returns a partial range up to, but not including, its upper bound.
    ///
    /// Use the prefix half-open range operator (prefix `..<`) to create a
    /// partial range of any type that conforms to the `Comparable` protocol.
    /// This example creates a `PartialRangeUpTo<Double>` instance that includes
    /// any value less than `5.0`.
    ///
    ///     let upToFive = ..<5.0
    ///
    ///     upToFive.contains(3.14)       // true
    ///     upToFive.contains(6.28)       // false
    ///     upToFive.contains(5.0)        // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, but not
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[..<3])
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ..< (maximum: UnsafeMutableRawPointer) -> PartialRangeUpTo<UnsafeMutableRawPointer>

    /// Returns a partial range up to, and including, its upper bound.
    ///
    /// Use the prefix closed range operator (prefix `...`) to create a partial
    /// range of any type that conforms to the `Comparable` protocol. This
    /// example creates a `PartialRangeThrough<Double>` instance that includes
    /// any value less than or equal to `5.0`.
    ///
    ///     let throughFive = ...5.0
    ///
    ///     throughFive.contains(4.0)     // true
    ///     throughFive.contains(5.0)     // true
    ///     throughFive.contains(6.0)     // false
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the start of the collection up to, and
    /// including, the partial range's upper bound.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[...3])
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter maximum: The upper bound for the range.
    ///
    /// - Precondition: `maximum` must compare equal to itself (i.e. cannot be NaN).
    prefix public static func ... (maximum: UnsafeMutableRawPointer) -> PartialRangeThrough<UnsafeMutableRawPointer>

    /// Returns a partial range extending upward from a lower bound.
    ///
    /// Use the postfix range operator (postfix `...`) to create a partial range
    /// of any type that conforms to the `Comparable` protocol. This example
    /// creates a `PartialRangeFrom<Double>` instance that includes any value
    /// greater than or equal to `5.0`.
    ///
    ///     let atLeastFive = 5.0...
    ///
    ///     atLeastFive.contains(4.0)     // false
    ///     atLeastFive.contains(5.0)     // true
    ///     atLeastFive.contains(6.0)     // true
    ///
    /// You can use this type of partial range of a collection's indices to
    /// represent the range from the partial range's lower bound up to the end
    /// of the collection.
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60, 70]
    ///     print(numbers[3...])
    ///     // Prints "[40, 50, 60, 70]"
    ///
    /// - Parameter minimum: The lower bound for the range.
    ///
    /// - Precondition: `minimum` must compare equal to itself (i.e. cannot be NaN).
    postfix public static func ... (minimum: UnsafeMutableRawPointer) -> PartialRangeFrom<UnsafeMutableRawPointer>

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func < (x: UnsafeMutableRawPointer, y: UnsafeMutableRawPointer) -> Bool

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable public static func == (x: UnsafeMutableRawPointer, y: UnsafeMutableRawPointer) -> Bool
}

extension UnsafeMutableRawPointer : Strideable {

    /// Returns a value that is offset the specified distance from this value.
    ///
    /// Use the `advanced(by:)` method in generic code to offset a value by a
    /// specified distance. If you're working directly with numeric values, use
    /// the addition operator (`+`) instead of this method.
    ///
    ///     func addOne<T: Strideable>(to x: T) -> T
    ///         where T.Stride: ExpressibleByIntegerLiteral
    ///     {
    ///         return x.advanced(by: 1)
    ///     }
    ///
    ///     let x = addOne(to: 5)
    ///     // x == 6
    ///     let y = addOne(to: 3.5)
    ///     // y = 4.5
    ///
    /// If this type's `Stride` type conforms to `BinaryInteger`, then for a
    /// value `x`, a distance `n`, and a value `y = x.advanced(by: n)`,
    /// `x.distance(to: y) == n`. Using this method with types that have a
    /// noninteger `Stride` may result in an approximation.
    ///
    /// - Parameter n: The distance to advance this value.
    /// - Returns: A value that is offset from this value by `n`.
    ///
    /// - Complexity: O(1)
    public func advanced(by n: Int) -> UnsafeMutableRawPointer

    /// A type that represents the distance between two values.
    public typealias Stride = Int
}

@frozen public struct UnsafeMutableBufferPointer<Element> {

    /// The number of elements in the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    public let count: Int

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    public typealias Iterator = UnsafeBufferPointer<Element>.Iterator

    /// Creates a new buffer pointer over the specified number of contiguous
    /// instances beginning at the given pointer.
    ///
    /// - Parameters:
    ///   - start: A pointer to the start of the buffer, or `nil`. If `start` is
    ///     `nil`, `count` must be zero. However, `count` may be zero even for a
    ///     non-`nil` `start`. The pointer passed as `start` must be aligned to
    ///     `MemoryLayout<Element>.alignment`.
    ///   - count: The number of instances in the buffer. `count` must not be
    ///     negative.
    @inlinable public init(start: UnsafeMutablePointer<Element>?, count: Int)

    /// Creates a mutable typed buffer pointer referencing the same memory as the
    /// given immutable buffer pointer.
    ///
    /// - Parameter other: The immutable buffer pointer to convert.
    @inlinable public init(mutating other: UnsafeBufferPointer<Element>)

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// mutable contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of mutable contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// Often, the optimizer can eliminate bounds- and uniqueness-checks
    /// within an algorithm, but when that fails, invoking the
    /// same algorithm on `body`\ 's argument lets you trade safety for
    /// speed.
    @inlinable public mutating func withContiguousMutableStorageIfAvailable<R>(_ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R?

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R?

    /// Creates a buffer over the same memory as the given buffer slice.
    ///
    /// The new buffer represents the same region of memory as `slice`, but is
    /// indexed starting at zero instead of sharing indices with the original
    /// buffer. For example:
    ///
    ///     let buffer = returnsABuffer()
    ///     let n = 5
    ///     let slice = buffer[n...]
    ///     let rebased = UnsafeMutableBufferPointer(rebasing: slice)
    ///
    /// After rebasing `slice` as the `rebased` buffer, the following are true:
    ///
    /// - `rebased.startIndex == 0`
    /// - `rebased[0] == slice[n]`
    /// - `rebased[0] == buffer[n]`
    /// - `rebased.count == slice.count`
    ///
    /// - Parameter slice: The buffer slice to rebase.
    @inlinable public init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>)

    /// Deallocates the memory block previously allocated at this buffer pointer’s
    /// base address.
    ///
    /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory
    /// block previously returned by a Swift allocation method. If `baseAddress` is
    /// `nil`, this function does nothing. Otherwise, the memory must not be initialized
    /// or `Pointee` must be a trivial type. This buffer pointer's `count` must
    /// be equal to the originally allocated size of the memory block.
    @inlinable public func deallocate()

    /// Allocates uninitialized memory for the specified number of instances of
    /// type `Element`.
    ///
    /// The resulting buffer references a region of memory that is bound to
    /// `Element` and is `count * MemoryLayout<Element>.stride` bytes in size.
    ///
    /// The following example allocates a buffer that can store four `Int`
    /// instances and then initializes that memory with the elements of a range:
    ///
    ///     let buffer = UnsafeMutableBufferPointer<Int>.allocate(capacity: 4)
    ///     _ = buffer.initialize(from: 1...4)
    ///     print(buffer[2])
    ///     // Prints "3"
    ///
    /// When you allocate memory, always remember to deallocate once you're
    /// finished.
    ///
    ///     buffer.deallocate()
    ///
    /// - Parameter count: The amount of memory to allocate, counted in instances
    ///   of `Element`.
    @inlinable public static func allocate(capacity count: Int) -> UnsafeMutableBufferPointer<Element>

    /// Initializes every element in this buffer's memory to a copy of the given value.
    ///
    /// The destination memory must be uninitialized or the buffer's `Element`
    /// must be a trivial type. After a call to `initialize(repeating:)`, the
    /// entire region of memory referenced by this buffer is initialized.
    ///
    /// - Parameters:
    ///   - repeatedValue: The instance to initialize this buffer's memory with.
    @inlinable public func initialize(repeating repeatedValue: Element)

    /// Assigns every element in this buffer's memory to a copy of the given value.
    ///
    /// The buffer’s memory must be initialized or the buffer's `Element`
    /// must be a trivial type.
    ///
    /// - Parameters:
    ///   - repeatedValue: The instance to assign this buffer's memory to.
    ///
    /// Warning: All buffer elements must be initialized before calling this.
    /// Assigning to part of the buffer must be done using the `assign(repeating:count:)`
    /// method on the buffer’s `baseAddress`.
    @inlinable public func assign(repeating repeatedValue: Element)

    /// Executes the given closure while temporarily binding the memory referenced
    /// by this buffer to the given type.
    ///
    /// Use this method when you have a buffer of memory bound to one type and
    /// you need to access that memory as a buffer of another type. Accessing
    /// memory as type `T` requires that the memory be bound to that type. A
    /// memory location may only be bound to one type at a time, so accessing
    /// the same memory as an unrelated type without first rebinding the memory
    /// is undefined.
    ///
    /// The entire region of memory referenced by this buffer must be initialized.
    ///
    /// Because this buffer's memory is no longer bound to its `Element` type
    /// while the `body` closure executes, do not access memory using the
    /// original buffer from within `body`. Instead, use the `body` closure's
    /// buffer argument to access the values in memory as instances of type
    /// `T`.
    ///
    /// After executing `body`, this method rebinds memory back to the original
    /// `Element` type.
    ///
    /// - Note: Only use this method to rebind the buffer's memory to a type
    ///   with the same size and stride as the currently bound `Element` type.
    ///   To bind a region of memory to a type that is a different size, convert
    ///   the buffer to a raw buffer and use the `bindMemory(to:)` method.
    ///
    /// - Parameters:
    ///   - type: The type to temporarily bind the memory referenced by this
    ///     buffer. The type `T` must have the same size and be layout compatible
    ///     with the pointer's `Element` type.
    ///   - body: A closure that takes a mutable typed buffer to the
    ///     same memory as this buffer, only bound to type `T`. The buffer argument
    ///     contains the same number of complete instances of `T` as the original
    ///     buffer’s `count`. The closure's buffer argument is valid only for the
    ///     duration of the closure's execution. If `body` has a return value, that
    ///     value is also used as the return value for the `withMemoryRebound(to:_:)`
    ///     method.
    /// - Returns: The return value, if any, of the `body` closure parameter.
    @inlinable public func withMemoryRebound<T, Result>(to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws -> Result) rethrows -> Result

    /// A pointer to the first element of the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    @inlinable public var baseAddress: UnsafeMutablePointer<Element>? { get }

    /// Initializes the buffer's memory with the given elements.
    ///
    /// When calling the `initialize(from:)` method on a buffer `b`, the memory
    /// referenced by `b` must be uninitialized or the `Element` type must be a
    /// trivial type. After the call, the memory referenced by this buffer up
    /// to, but not including, the returned index is initialized. The buffer
    /// must contain sufficient memory to accommodate
    /// `source.underestimatedCount`.
    ///
    /// The returned index is the position of the element in the buffer one past
    /// the last element written. If `source` contains no elements, the returned
    /// index is equal to the buffer's `startIndex`. If `source` contains an
    /// equal or greater number of elements than the buffer can hold, the
    /// returned index is equal to the buffer's `endIndex`.
    ///
    /// - Parameter source: A sequence of elements with which to initializer the
    ///   buffer.
    /// - Returns: An iterator to any elements of `source` that didn't fit in the
    ///   buffer, and an index to the point in the buffer one past the last
    ///   element written.
    @inlinable public func initialize<S>(from source: S) -> (S.Iterator, UnsafeMutableBufferPointer<Element>.Index) where Element == S.Element, S : Sequence

    /// Returns a subsequence containing all but the specified number of final
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in the
    /// collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropLast(2))
    ///     // Prints "[1, 2, 3]"
    ///     print(numbers.dropLast(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop off the end of the
    ///   collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence that leaves off `k` elements from the end.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop.
    @inlinable public func dropLast(_ k: Int) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence, up to the given maximum length, containing the
    /// final elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains the entire collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.suffix(2))
    ///     // Prints "[4, 5]"
    ///     print(numbers.suffix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence terminating at the end of the collection with at
    ///   most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is equal to
    ///   `maxLength`.
    @inlinable public func suffix(_ maxLength: Int) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    @inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]

    /// Returns a subsequence containing all but the given number of initial
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in
    /// the collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropFirst(2))
    ///     // Prints "[3, 4, 5]"
    ///     print(numbers.dropFirst(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop from the beginning of
    ///   the collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence starting after the specified number of
    ///   elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop from the beginning of the collection.
    @inlinable public func dropFirst(_ k: Int = 1) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence by skipping elements while `predicate` returns
    /// `true` and returning the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be skipped or `false` if it should be included. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func drop(while predicate: (Element) throws -> Bool) rethrows -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence, up to the specified maximum length, containing
    /// the initial elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains all the elements in the collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.prefix(2))
    ///     // Prints "[1, 2]"
    ///     print(numbers.prefix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence starting at the beginning of this collection
    ///   with at most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to select from the beginning of the collection.
    @inlinable public func prefix(_ maxLength: Int) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence containing the initial elements until `predicate`
    /// returns `false` and skipping the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be included or `false` if it should be excluded. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func prefix(while predicate: (Element) throws -> Bool) rethrows -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence from the start of the collection up to, but not
    /// including, the specified position.
    ///
    /// The resulting subsequence *does not include* the element at the position
    /// `end`. The following example searches for the index of the number `40`
    /// in an array of integers, and then prints the prefix of the array up to,
    /// but not including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(upTo: i))
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// Passing the collection's starting index as the `end` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.prefix(upTo: numbers.startIndex))
    ///     // Prints "[]"
    ///
    /// Using the `prefix(upTo:)` method is equivalent to using a partial
    /// half-open range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(upTo:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[..<i])
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter end: The "past the end" index of the resulting subsequence.
    ///   `end` must be a valid index of the collection.
    /// - Returns: A subsequence up to, but not including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(upTo end: Int) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence from the specified position to the end of the
    /// collection.
    ///
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the suffix of the array starting at
    /// that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.suffix(from: i))
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// Passing the collection's `endIndex` as the `start` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.suffix(from: numbers.endIndex))
    ///     // Prints "[]"
    ///
    /// Using the `suffix(from:)` method is equivalent to using a partial range
    /// from the index as the collection's subscript. The subscript notation is
    /// preferred over `suffix(from:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[i...])
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// - Parameter start: The index at which to start the resulting subsequence.
    ///   `start` must be a valid index of the collection.
    /// - Returns: A subsequence starting at the `start` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func suffix(from start: Int) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns a subsequence from the start of the collection through the
    /// specified position.
    ///
    /// The resulting subsequence *includes* the element at the position `end`.
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the prefix of the array up to, and
    /// including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(through: i))
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// Using the `prefix(through:)` method is equivalent to using a partial
    /// closed range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(through:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[...i])
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter end: The index of the last element to include in the
    ///   resulting subsequence. `end` must be a valid index of the collection
    ///   that is not equal to the `endIndex` property.
    /// - Returns: A subsequence up to, and including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(through position: Int) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Returns the longest possible subsequences of the collection, in order,
    /// that don't contain elements satisfying the given predicate.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string using a
    /// closure that matches spaces. The first use of `split` returns each word
    /// that was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(maxSplits: 1, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(omittingEmptySubsequences: false, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each pair of consecutive elements
    ///     satisfying the `isSeparator` predicate and for each element at the
    ///     start or end of the collection satisfying the `isSeparator`
    ///     predicate. The default value is `true`.
    ///   - isSeparator: A closure that takes an element as an argument and
    ///     returns a Boolean value indicating whether the collection should be
    ///     split at that element.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (Element) throws -> Bool) rethrows -> [Slice<UnsafeMutableBufferPointer<Element>>]

    /// The last element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let lastNumber = numbers.last {
    ///         print(lastNumber)
    ///     }
    ///     // Prints "50"
    ///
    /// - Complexity: O(1)
    @inlinable public var last: Element? { get }

    /// Returns the first index in which an element of the collection satisfies
    /// the given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. Here's an example that finds a student name that
    /// begins with the letter "A":
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.firstIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Abena starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the first element for which `predicate` returns
    ///   `true`. If no elements in the collection satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?

    /// Returns the last element of the sequence that satisfies the given
    /// predicate.
    ///
    /// This example uses the `last(where:)` method to find the last
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let lastNegative = numbers.last(where: { $0 < 0 }) {
    ///         print("The last negative number is \(lastNegative).")
    ///     }
    ///     // Prints "The last negative number is -6."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The last element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func last(where predicate: (Element) throws -> Bool) rethrows -> Element?

    /// Returns the index of the last element in the collection that matches the
    /// given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. This example finds the index of the last name that
    /// begins with the letter *A:*
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.lastIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Akosua starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the last element in the collection that matches
    ///   `predicate`, or `nil` if no elements match.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?

    /// Reorders the elements of the collection such that all the elements
    /// that match the given predicate are after all the elements that don't
    /// match.
    ///
    /// After partitioning a collection, there is a pivot index `p` where
    /// no element before `p` satisfies the `belongsInSecondPartition`
    /// predicate and every element at or after `p` satisfies
    /// `belongsInSecondPartition`.
    ///
    /// In the following example, an array of numbers is partitioned by a
    /// predicate that matches elements greater than 30.
    ///
    ///     var numbers = [30, 40, 20, 30, 30, 60, 10]
    ///     let p = numbers.partition(by: { $0 > 30 })
    ///     // p == 5
    ///     // numbers == [30, 10, 20, 30, 30, 60, 40]
    ///
    /// The `numbers` array is now arranged in two partitions. The first
    /// partition, `numbers[..<p]`, is made up of the elements that
    /// are not greater than 30. The second partition, `numbers[p...]`,
    /// is made up of the elements that *are* greater than 30.
    ///
    ///     let first = numbers[..<p]
    ///     // first == [30, 10, 20, 30, 30]
    ///     let second = numbers[p...]
    ///     // second == [60, 40]
    ///
    /// - Parameter belongsInSecondPartition: A predicate used to partition
    ///   the collection. All elements satisfying this predicate are ordered
    ///   after all elements not satisfying it.
    /// - Returns: The index of the first element in the reordered collection
    ///   that matches `belongsInSecondPartition`. If no elements in the
    ///   collection match `belongsInSecondPartition`, the returned index is
    ///   equal to the collection's `endIndex`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Int

    /// Reorders the elements of the collection such that all the elements
    /// that match the given predicate are after all the elements that don't
    /// match.
    ///
    /// After partitioning a collection, there is a pivot index `p` where
    /// no element before `p` satisfies the `belongsInSecondPartition`
    /// predicate and every element at or after `p` satisfies
    /// `belongsInSecondPartition`.
    ///
    /// In the following example, an array of numbers is partitioned by a
    /// predicate that matches elements greater than 30.
    ///
    ///     var numbers = [30, 40, 20, 30, 30, 60, 10]
    ///     let p = numbers.partition(by: { $0 > 30 })
    ///     // p == 5
    ///     // numbers == [30, 10, 20, 30, 30, 60, 40]
    ///
    /// The `numbers` array is now arranged in two partitions. The first
    /// partition, `numbers[..<p]`, is made up of the elements that
    /// are not greater than 30. The second partition, `numbers[p...]`,
    /// is made up of the elements that *are* greater than 30.
    ///
    ///     let first = numbers[..<p]
    ///     // first == [30, 10, 20, 30, 30]
    ///     let second = numbers[p...]
    ///     // second == [60, 40]
    ///
    /// - Parameter belongsInSecondPartition: A predicate used to partition
    ///   the collection. All elements satisfying this predicate are ordered
    ///   after all elements not satisfying it.
    /// - Returns: The index of the first element in the reordered collection
    ///   that matches `belongsInSecondPartition`. If no elements in the
    ///   collection match `belongsInSecondPartition`, the returned index is
    ///   equal to the collection's `endIndex`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Int

    /// Returns the elements of the sequence, shuffled using the given generator
    /// as a source for randomness.
    ///
    /// You use this method to randomize the elements of a sequence when you are
    /// using a custom random number generator. For example, you can shuffle the
    /// numbers between `0` and `9` by calling the `shuffled(using:)` method on
    /// that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled(using: &myGenerator)
    ///     // shuffledNumbers == [8, 9, 4, 3, 2, 6, 7, 0, 5, 1]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the sequence.
    /// - Returns: An array of this sequence's elements in a shuffled order.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    /// - Note: The algorithm used to shuffle a sequence may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public func shuffled<T>(using generator: inout T) -> [Element] where T : RandomNumberGenerator

    /// Returns the elements of the sequence, shuffled.
    ///
    /// For example, you can shuffle the numbers between `0` and `9` by calling
    /// the `shuffled()` method on that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled()
    ///     // shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]
    ///
    /// This method is equivalent to calling `shuffled(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Returns: A shuffled array of this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func shuffled() -> [Element]

    /// Shuffles the collection in place, using the given generator as a source
    /// for randomness.
    ///
    /// You use this method to randomize the elements of a collection when you
    /// are using a custom random number generator. For example, you can use the
    /// `shuffle(using:)` method to randomly reorder the elements of an array.
    ///
    ///     var names = ["Alejandro", "Camila", "Diego", "Luciana", "Luis", "Sofía"]
    ///     names.shuffle(using: &myGenerator)
    ///     // names == ["Sofía", "Alejandro", "Camila", "Luis", "Diego", "Luciana"]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the collection.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    /// - Note: The algorithm used to shuffle a collection may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public mutating func shuffle<T>(using generator: inout T) where T : RandomNumberGenerator

    /// Shuffles the collection in place.
    ///
    /// Use the `shuffle()` method to randomly reorder the elements of an array.
    ///
    ///     var names = ["Alejandro", "Camila", "Diego", "Luciana", "Luis", "Sofía"]
    ///     names.shuffle(using: myGenerator)
    ///     // names == ["Luis", "Camila", "Luciana", "Sofía", "Alejandro", "Diego"]
    ///
    /// This method is equivalent to calling `shuffle(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public mutating func shuffle()

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection, using the given predicate as an
    /// equivalence test.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///   - areEquivalent: A closure that returns a Boolean value indicating
    ///     whether two elements are equivalent.
    ///
    /// - Returns: The difference needed to produce the reciever's state from
    ///   the parameter's state.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C, by areEquivalent: (C.Element, Element) -> Bool) -> CollectionDifference<Element> where C : BidirectionalCollection, Element == C.Element

    /// A sequence containing the same elements as this sequence,
    /// but on which some operations, such as `map` and `filter`, are
    /// implemented lazily.
    @inlinable public var lazy: LazySequence<UnsafeMutableBufferPointer<Element>> { get }

    @available(swift, deprecated: 4.1, renamed: "compactMap(_:)", message: "Please use compactMap(_:) for the case where closure returns an optional value")
    public func flatMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// mutable contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of mutable contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// Often, the optimizer can eliminate bounds- and uniqueness-checks
    /// within an algorithm, but when that fails, invoking the
    /// same algorithm on `body`\ 's argument lets you trade safety for
    /// speed.
    @inlinable public mutating func withContiguousMutableStorageIfAvailable<R>(_ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R) rethrows -> R?

    /// Accesses a contiguous subrange of the collection's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice of an array of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original array.
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2 ..< streets.endIndex]
    ///     print(streetsSlice)
    ///     // Prints "["Channing", "Douglas", "Evarts"]"
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     streets[index!] = "Eustace"
    ///     print(streets[index!])
    ///     // Prints "Eustace"
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Accesses the contiguous subrange of the collection's elements specified
    /// by a range expression.
    ///
    /// The range expression is converted to a concrete subrange relative to this
    /// collection. For example, using a `PartialRangeFrom` range expression
    /// with an array accesses the subrange from the start of the range
    /// expression until the end of the array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2...]
    ///     print(streetsSlice)
    ///     // ["Channing", "Douglas", "Evarts"]
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection uses. This example searches `streetsSlice` for one
    /// of the strings in the slice, and then uses that index in the original
    /// array.
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // "Evarts"
    ///
    /// Always use the slice's `startIndex` property instead of assuming that its
    /// indices start at a particular value. Attempting to access an element by
    /// using an index outside the bounds of the slice's indices may result in a
    /// runtime error, even if that index is valid for the original collection.
    ///
    ///     print(streetsSlice.startIndex)
    ///     // 2
    ///     print(streetsSlice[2])
    ///     // "Channing"
    ///
    ///     print(streetsSlice[0])
    ///     // error: Index out of bounds
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript<R>(r: R) -> Slice<UnsafeMutableBufferPointer<Element>> where R : RangeExpression, Int == R.Bound { get }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> Slice<UnsafeMutableBufferPointer<Element>> { get }

    @inlinable public subscript<R>(r: R) -> Slice<UnsafeMutableBufferPointer<Element>> where R : RangeExpression, Int == R.Bound

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> Slice<UnsafeMutableBufferPointer<Element>>

    /// Reverses the elements of the collection in place.
    ///
    /// The following example reverses the elements of an array of characters:
    ///
    ///     var characters: [Character] = ["C", "a", "f", "é"]
    ///     characters.reverse()
    ///     print(characters)
    ///     // Prints "["é", "f", "a", "C"]
    ///
    /// - Complexity: O(*n*), where *n* is the number of elements in the
    ///   collection.
    @inlinable public mutating func reverse()

    /// Returns a view presenting the elements of the collection in reverse
    /// order.
    ///
    /// You can reverse a collection without allocating new space for its
    /// elements by calling this `reversed()` method. A `ReversedCollection`
    /// instance wraps an underlying collection and provides access to its
    /// elements in reverse order. This example prints the characters of a
    /// string in reverse order:
    ///
    ///     let word = "Backwards"
    ///     for char in word.reversed() {
    ///         print(char, terminator: "")
    ///     }
    ///     // Prints "sdrawkcaB"
    ///
    /// If you need a reversed collection of the same type, you may be able to
    /// use the collection's sequence-based or collection-based initializer. For
    /// example, to get the reversed version of a string, reverse its
    /// characters and initialize a new `String` instance from the result.
    ///
    ///     let reversedWord = String(word.reversed())
    ///     print(reversedWord)
    ///     // Prints "sdrawkcaB"
    ///
    /// - Complexity: O(1)
    @inlinable public func reversed() -> ReversedCollection<UnsafeMutableBufferPointer<Element>>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]

    /// Returns an array containing, in order, the elements of the sequence
    /// that satisfy the given predicate.
    ///
    /// In this example, `filter(_:)` is used to include only names shorter than
    /// five characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let shortNames = cast.filter { $0.count < 5 }
    ///     print(shortNames)
    ///     // Prints "["Kim", "Karl"]"
    ///
    /// - Parameter isIncluded: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be included in the returned array.
    /// - Returns: An array of the elements that `isIncluded` allowed.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]

    /// A value less than or equal to the number of elements in the sequence,
    /// calculated nondestructively.
    ///
    /// The default implementation returns 0. If you provide your own
    /// implementation, make sure to compute the value nondestructively.
    ///
    /// - Complexity: O(1), except if the sequence also conforms to `Collection`.
    ///   In this case, see the documentation of `Collection.underestimatedCount`.
    @inlinable public var underestimatedCount: Int { get }

    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEach(_ body: (Element) throws -> Void) rethrows

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `first(where:)` method to find the first
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let firstNegative = numbers.first(where: { $0 < 0 }) {
    ///         print("The first negative number is \(firstNegative).")
    ///     }
    ///     // Prints "The first negative number is -2."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The first element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func first(where predicate: (Element) throws -> Bool) rethrows -> Element?

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R?

    /// Returns a sequence of pairs (*n*, *x*), where *n* represents a
    /// consecutive integer starting at zero and *x* represents an element of
    /// the sequence.
    ///
    /// This example enumerates the characters of the string "Swift" and prints
    /// each character along with its place in the string.
    ///
    ///     for (n, c) in "Swift".enumerated() {
    ///         print("\(n): '\(c)'")
    ///     }
    ///     // Prints "0: 'S'"
    ///     // Prints "1: 'w'"
    ///     // Prints "2: 'i'"
    ///     // Prints "3: 'f'"
    ///     // Prints "4: 't'"
    ///
    /// When you enumerate a collection, the integer part of each pair is a counter
    /// for the enumeration, but is not necessarily the index of the paired value.
    /// These counters can be used as indices only in instances of zero-based,
    /// integer-indexed collections, such as `Array` and `ContiguousArray`. For
    /// other collections the counters may be out of range or of the wrong type
    /// to use as an index. To iterate over the elements of a collection with its
    /// indices, use the `zip(_:_:)` function.
    ///
    /// This example iterates over the indices and elements of a set, building a
    /// list consisting of indices of names with five or fewer letters.
    ///
    ///     let names: Set = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     var shorterIndices: [Set<String>.Index] = []
    ///     for (i, name) in zip(names.indices, names) {
    ///         if name.count <= 5 {
    ///             shorterIndices.append(i)
    ///         }
    ///     }
    ///
    /// Now that the `shorterIndices` array holds the indices of the shorter
    /// names in the `names` set, you can use those indices to access elements in
    /// the set.
    ///
    ///     for i in shorterIndices {
    ///         print(names[i])
    ///     }
    ///     // Prints "Sofia"
    ///     // Prints "Mateo"
    ///
    /// - Returns: A sequence of pairs enumerating the sequence.
    ///
    /// - Complexity: O(1)
    @inlinable public func enumerated() -> EnumeratedSequence<UnsafeMutableBufferPointer<Element>>

    /// Returns the minimum element in the sequence, using the given predicate as
    /// the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `min(by:)` method on a
    /// dictionary to find the key-value pair with the lowest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let leastHue = hues.min { a, b in a.value < b.value }
    ///     print(leastHue)
    ///     // Prints "Optional((key: "Coral", value: 16))"
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true`
    ///   if its first argument should be ordered before its second
    ///   argument; otherwise, `false`.
    /// - Returns: The sequence's minimum element, according to
    ///   `areInIncreasingOrder`. If the sequence has no elements, returns
    ///   `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element?

    /// Returns the maximum element in the sequence, using the given predicate
    /// as the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `max(by:)` method on a
    /// dictionary to find the key-value pair with the highest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let greatestHue = hues.max { a, b in a.value < b.value }
    ///     print(greatestHue)
    ///     // Prints "Optional((key: "Heliotrope", value: 296))"
    ///
    /// - Parameter areInIncreasingOrder:  A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: The sequence's maximum element if the sequence is not empty;
    ///   otherwise, `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element?

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are equivalent to the elements in another sequence, using
    /// the given predicate as the equivalence test.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - possiblePrefix: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if the initial elements of the sequence are equivalent
    ///   to the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix, by areEquivalent: (Element, PossiblePrefix.Element) throws -> Bool) rethrows -> Bool where PossiblePrefix : Sequence

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain equivalent elements in the same order, using the given
    /// predicate as the equivalence test.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if this sequence and `other` contain equivalent items,
    ///   using `areEquivalent` as the equivalence test; otherwise, `false.`
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence, by areEquivalent: (Element, OtherSequence.Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the given
    /// predicate to compare elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areInIncreasingOrder:  A predicate that returns `true` if its first
    ///     argument should be ordered before its second argument; otherwise,
    ///     `false`.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering as ordered by `areInIncreasingOrder`; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that perform
    ///   localized comparison instead.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains an
    /// element that satisfies the given predicate.
    ///
    /// You can use the predicate to check for an element of a type that
    /// doesn't conform to the `Equatable` protocol, such as the
    /// `HTTPResponse` enumeration in this example.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]
    ///     let hadError = lastThreeResponses.contains { element in
    ///         if case .error = element {
    ///             return true
    ///         } else {
    ///             return false
    ///         }
    ///     }
    ///     // 'hadError' == true
    ///
    /// Alternatively, a predicate can be satisfied by a range of `Equatable`
    /// elements or a general condition. This example shows how you can check an
    /// array for an expense greater than $100.
    ///
    ///     let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
    ///     let hasBigPurchase = expenses.contains { $0 > 100 }
    ///     // 'hasBigPurchase' == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element represents a match.
    /// - Returns: `true` if the sequence contains an element that satisfies
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether every element of a sequence
    /// satisfies a given predicate.
    ///
    /// The following code uses this method to test whether all the names in an
    /// array have at least five characters:
    ///
    ///     let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
    ///     // allHaveAtLeastFive == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element satisfies a condition.
    /// - Returns: `true` if the sequence contains only elements that satisfy
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(_:_:)` method to produce a single value from the elements
    /// of an entire sequence. For example, you can use this method on an array
    /// of numbers to find their sum or product.
    ///
    /// The `nextPartialResult` closure is called sequentially with an
    /// accumulating value initialized to `initialResult` and each element of
    /// the sequence. This example shows how to find the sum of an array of
    /// numbers.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///     let numberSum = numbers.reduce(0, { x, y in
    ///         x + y
    ///     })
    ///     // numberSum == 10
    ///
    /// When `numbers.reduce(_:_:)` is called, the following steps occur:
    ///
    /// 1. The `nextPartialResult` closure is called with `initialResult`---`0`
    ///    in this case---and the first element of `numbers`, returning the sum:
    ///    `1`.
    /// 2. The closure is called again repeatedly with the previous call's return
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the last value returned from the
    ///    closure is returned to the caller.
    ///
    /// If the sequence has no elements, `nextPartialResult` is never executed
    /// and `initialResult` is the result of the call to `reduce(_:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///     `initialResult` is passed to `nextPartialResult` the first time the
    ///     closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and
    ///     an element of the sequence into a new accumulating value, to be used
    ///     in the next call of the `nextPartialResult` closure or returned to
    ///     the caller.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(into:_:)` method to produce a single value from the
    /// elements of an entire sequence. For example, you can use this method on an
    /// array of integers to filter adjacent equal entries or count frequencies.
    ///
    /// This method is preferred over `reduce(_:_:)` for efficiency when the
    /// result is a copy-on-write type, for example an Array or a Dictionary.
    ///
    /// The `updateAccumulatingResult` closure is called sequentially with a
    /// mutable accumulating value initialized to `initialResult` and each element
    /// of the sequence. This example shows how to build a dictionary of letter
    /// frequencies of a string.
    ///
    ///     let letters = "abracadabra"
    ///     let letterCount = letters.reduce(into: [:]) { counts, letter in
    ///         counts[letter, default: 0] += 1
    ///     }
    ///     // letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1]
    ///
    /// When `letters.reduce(into:_:)` is called, the following steps occur:
    ///
    /// 1. The `updateAccumulatingResult` closure is called with the initial
    ///    accumulating value---`[:]` in this case---and the first character of
    ///    `letters`, modifying the accumulating value by setting `1` for the key
    ///    `"a"`.
    /// 2. The closure is called again repeatedly with the updated accumulating
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the accumulating value is returned to
    ///    the caller.
    ///
    /// If the sequence has no elements, `updateAccumulatingResult` is never
    /// executed and `initialResult` is the result of the call to
    /// `reduce(into:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating
    ///     value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result

    /// Returns an array containing the concatenated results of calling the
    /// given transformation with each element of this sequence.
    ///
    /// Use this method to receive a single-level collection when your
    /// transformation produces a sequence or collection for each element.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns an array.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///
    ///     let mapped = numbers.map { Array(repeating: $0, count: $0) }
    ///     // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
    ///
    ///     let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
    ///     // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
    ///
    /// In fact, `s.flatMap(transform)`  is equivalent to
    /// `Array(s.map(transform).joined())`.
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns a sequence or collection.
    /// - Returns: The resulting flattened array.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func flatMap<SegmentOfResult>(_ transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence

    /// Returns an array containing the non-`nil` results of calling the given
    /// transformation with each element of this sequence.
    ///
    /// Use this method to receive an array of non-optional values when your
    /// transformation produces an optional value.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `compactMap` with a transformation that returns an optional `Int` value.
    ///
    ///     let possibleNumbers = ["1", "2", "three", "///4///", "5"]
    ///
    ///     let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
    ///     // [1, 2, nil, nil, 5]
    ///
    ///     let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
    ///     // [1, 2, 5]
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-`nil` results of calling `transform`
    ///   with each element of the sequence.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the elements of the sequence, sorted using the given predicate as
    /// the comparison between elements.
    ///
    /// When you want to sort a sequence of elements that don't conform to the
    /// `Comparable` protocol, pass a predicate to this method that returns
    /// `true` when the first element should be ordered before the second. The
    /// elements of the resulting array are ordered according to the given
    /// predicate.
    ///
    /// In the following example, the predicate provides an ordering for an array
    /// of a custom `HTTPResponse` type. The predicate orders errors before
    /// successes and sorts the error responses by their error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     let sortedResponses = responses.sorted {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(sortedResponses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// You also use this method to sort elements that conform to the
    /// `Comparable` protocol in descending order. To sort your sequence in
    /// descending order, pass the greater-than operator (`>`) as the
    /// `areInIncreasingOrder` parameter.
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// Calling the related `sorted()` method is equivalent to calling this
    /// method and passing the less-than operator (`<`) as the predicate.
    ///
    ///     print(students.sorted())
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///     print(students.sorted(by: <))
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element]

    /// Sorts the collection in place, using the given predicate as the
    /// comparison between elements.
    ///
    /// When you want to sort a collection of elements that don't conform to
    /// the `Comparable` protocol, pass a closure to this method that returns
    /// `true` when the first element should be ordered before the second.
    ///
    /// In the following example, the closure provides an ordering for an array
    /// of a custom enumeration that describes an HTTP response. The predicate
    /// orders errors before successes and sorts the error responses by their
    /// error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     var responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     responses.sort {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(responses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// Alternatively, use this method to sort a collection of elements that do
    /// conform to `Comparable` when you want the sort to be descending instead
    /// of ascending. Pass the greater-than operator (`>`) operator as the
    /// predicate.
    ///
    ///     var students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     students.sort(by: >)
    ///     print(students)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// `areInIncreasingOrder` must be a *strict weak ordering* over the
    /// elements. That is, for any elements `a`, `b`, and `c`, the following
    /// conditions must hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`. If `areInIncreasingOrder` throws an error during
    ///   the sort, the elements may be in a different order, but none will be
    ///   lost.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the collection.
    @inlinable public mutating func sort(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows
}

/// Default implementation for bidirectional collections.
extension UnsafeMutableBufferPointer {
}

/// Default implementations of core requirements
extension UnsafeMutableBufferPointer {

    /// A Boolean value indicating whether the collection is empty.
    ///
    /// When you need to check whether your collection is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero. For collections that don't conform to
    /// `RandomAccessCollection`, accessing the `count` property iterates
    /// through the elements of the collection.
    ///
    ///     let horseName = "Silver"
    ///     if horseName.isEmpty {
    ///         print("My horse has no name.")
    ///     } else {
    ///         print("Hi ho, \(horseName)!")
    ///     }
    ///     // Prints "Hi ho, Silver!")
    ///
    /// - Complexity: O(1)
    @inlinable public var isEmpty: Bool { get }

    /// The first element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let firstNumber = numbers.first {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "10"
    @inlinable public var first: Element? { get }

    /// A value less than or equal to the number of elements in the collection.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var underestimatedCount: Int { get }

    /// The number of elements in the collection.
    ///
    /// To check whether a collection is empty, use its `isEmpty` property
    /// instead of comparing `count` to zero. Unless the collection guarantees
    /// random-access performance, calculating `count` can be an O(*n*)
    /// operation.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var count: Int { get }
}

/// Supply the default "slicing" `subscript` for `Collection` models
/// that accept the default associated `SubSequence`, `Slice<Self>`.
extension UnsafeMutableBufferPointer {

    /// Accesses a contiguous subrange of the collection's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice of an array of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2 ..< streets.endIndex]
    ///     print(streetsSlice)
    ///     // Prints "["Channing", "Douglas", "Evarts"]"
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // Prints "Evarts"
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeMutableBufferPointer<Element>> { get }
}

/// Default implementation for forward collections.
extension UnsafeMutableBufferPointer {

    /// Offsets the given index by the specified distance.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int)

    /// Offsets the given index by the specified distance, or so that it equals
    /// the given limiting index.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, a limit that is less than `i` has no effect.
    ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
    ///     effect.
    /// - Returns: `true` if `i` has been offset by exactly `distance` steps
    ///   without going beyond `limit`; otherwise, `false`. When the return
    ///   value is `false`, the value of `i` is equal to `limit`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int, limitedBy limit: Int) -> Bool

    /// Returns a random element of the collection, using the given generator as
    /// a source for randomness.
    ///
    /// Call `randomElement(using:)` to select a random element from an array or
    /// another collection when you are using a custom random number generator.
    /// This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement(using: &myGenerator)!
    ///     // randomName == "Amani"
    ///
    /// - Parameter generator: The random number generator to use when choosing a
    ///   random element.
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    /// - Note: The algorithm used to select a random element may change in a
    ///   future version of Swift. If you're passing a generator that results in
    ///   the same sequence of elements each time you run your program, that
    ///   sequence may change when your program is compiled using a different
    ///   version of Swift.
    @inlinable public func randomElement<T>(using generator: inout T) -> Element? where T : RandomNumberGenerator

    /// Returns a random element of the collection.
    ///
    /// Call `randomElement()` to select a random element from an array or
    /// another collection. This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement()!
    ///     // randomName == "Amani"
    ///
    /// This method is equivalent to calling `randomElement(using:)`, passing in
    /// the system's default random generator.
    ///
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public func randomElement() -> Element?
}

extension UnsafeMutableBufferPointer : CustomDebugStringConvertible {

    /// A textual representation of the buffer, suitable for debugging.
    public var debugDescription: String { get }
}

extension UnsafeMutableBufferPointer : Sequence {

    /// Returns an iterator over the elements of this buffer.
    ///
    /// - Returns: An iterator over the elements of this buffer.
    @inlinable public func makeIterator() -> UnsafeMutableBufferPointer<Element>.Iterator
}

extension UnsafeMutableBufferPointer : MutableCollection, RandomAccessCollection {

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Range<Int>

    /// The index of the first element in a nonempty buffer.
    ///
    /// The `startIndex` property of an `UnsafeMutableBufferPointer` instance
    /// is always zero.
    @inlinable public var startIndex: Int { get }

    /// The "past the end" position---that is, the position one greater than the
    /// last valid subscript argument.
    ///
    /// The `endIndex` property of an `UnsafeMutableBufferPointer` instance is
    /// always identical to `count`.
    @inlinable public var endIndex: Int { get }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    @inlinable public func index(after i: Int) -> Int

    /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    @inlinable public func formIndex(after i: inout Int)

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    @inlinable public func index(before i: Int) -> Int

    /// Replaces the given index with its predecessor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    @inlinable public func formIndex(before i: inout Int)

    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example obtains an index advanced four positions from a
    /// string's starting index and then prints the character at that position.
    ///
    ///     let s = "Swift"
    ///     let i = s.index(s.startIndex, offsetBy: 4)
    ///     print(s[i])
    ///     // Prints "t"
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    /// - Returns: An index offset by `distance` from the index `i`. If
    ///   `distance` is positive, this is the same value as the result of
    ///   `distance` calls to `index(after:)`. If `distance` is negative, this
    ///   is the same value as the result of `abs(distance)` calls to
    ///   `index(before:)`.
    ///
    /// - Complexity: O(1)
    @inlinable public func index(_ i: Int, offsetBy n: Int) -> Int

    /// Returns an index that is the specified distance from the given index,
    /// unless that distance is beyond a given limiting index.
    ///
    /// The following example obtains an index advanced four positions from a
    /// string's starting index and then prints the character at that position.
    /// The operation doesn't require going beyond the limiting `s.endIndex`
    /// value, so it succeeds.
    ///
    ///     let s = "Swift"
    ///     if let i = s.index(s.startIndex, offsetBy: 4, limitedBy: s.endIndex) {
    ///         print(s[i])
    ///     }
    ///     // Prints "t"
    ///
    /// The next example attempts to retrieve an index six positions from
    /// `s.startIndex` but fails, because that distance is beyond the index
    /// passed as `limit`.
    ///
    ///     let j = s.index(s.startIndex, offsetBy: 6, limitedBy: s.endIndex)
    ///     print(j)
    ///     // Prints "nil"
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, a limit that is less than `i` has no effect.
    ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
    ///     effect.
    /// - Returns: An index offset by `distance` from the index `i`, unless that
    ///   index would be beyond `limit` in the direction of movement. In that
    ///   case, the method returns `nil`.
    ///
    /// - Complexity: O(1)
    @inlinable public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int?

    /// Returns the distance between two indices.
    ///
    /// Unless the collection conforms to the `BidirectionalCollection` protocol,
    /// `start` must be less than or equal to `end`.
    ///
    /// - Parameters:
    ///   - start: A valid index of the collection.
    ///   - end: Another valid index of the collection. If `end` is equal to
    ///     `start`, the result is zero.
    /// - Returns: The distance between `start` and `end`. The result can be
    ///   negative only if the collection conforms to the
    ///   `BidirectionalCollection` protocol.
    ///
    /// - Complexity: O(1)
    @inlinable public func distance(from start: Int, to end: Int) -> Int

    /// The indices that are valid for subscripting the collection, in ascending
    /// order.
    ///
    /// A collection's `indices` property can hold a strong reference to the
    /// collection itself, causing the collection to be nonuniquely referenced.
    /// If you mutate the collection while iterating over its indices, a strong
    /// reference can result in an unexpected copy of the collection. To avoid
    /// the unexpected copy, use the `index(after:)` method starting with
    /// `startIndex` to produce indices instead.
    ///
    ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
    ///     var i = c.startIndex
    ///     while i != c.endIndex {
    ///         c[i] /= 5
    ///         i = c.index(after: i)
    ///     }
    ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
    @inlinable public var indices: UnsafeMutableBufferPointer<Element>.Indices { get }

    /// Accesses the element at the specified position.
    ///
    /// The following example uses the buffer pointer's subscript to access and
    /// modify the elements of a mutable buffer pointing to the contiguous
    /// contents of an array:
    ///
    ///     var numbers = [1, 2, 3, 4, 5]
    ///     numbers.withUnsafeMutableBufferPointer { buffer in
    ///         for i in stride(from: buffer.startIndex, to: buffer.endIndex - 1, by: 2) {
    ///             let x = buffer[i]
    ///             buffer[i + 1] = buffer[i]
    ///             buffer[i] = x
    ///         }
    ///     }
    ///     print(numbers)
    ///     // Prints "[2, 1, 4, 3, 5]"
    ///
    /// - Note: Bounds checks for `i` are performed only in debug mode.
    ///
    /// - Parameter i: The position of the element to access. `i` must be in the
    ///   range `0..<count`.
    @inlinable public subscript(i: Int) -> Element { get nonmutating set }

    /// Accesses a contiguous subrange of the buffer's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original buffer uses. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice from a buffer of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original buffer.
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     streets.withUnsafeMutableBufferPointer { buffer in
    ///         let streetSlice = buffer[2..<buffer.endIndex]
    ///         print(Array(streetSlice))
    ///         // Prints "["Channing", "Douglas", "Evarts"]"
    ///         let index = streetSlice.firstIndex(of: "Evarts")    // 4
    ///         buffer[index!] = "Eustace"
    ///     }
    ///     print(streets.last!)
    ///     // Prints "Eustace"
    ///
    /// - Note: Bounds checks for `bounds` are performed only in debug mode.
    ///
    /// - Parameter bounds: A range of the buffer's indices. The bounds of
    ///   the range must be valid indices of the buffer.
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeMutableBufferPointer<Element>> { get nonmutating set }

    /// Exchanges the values at the specified indices of the buffer.
    ///
    /// Both parameters must be valid indices of the buffer, and not
    /// equal to `endIndex`. Passing the same index as both `i` and `j` has no
    /// effect.
    ///
    /// - Parameters:
    ///   - i: The index of the first value to swap.
    ///   - j: The index of the second value to swap.
    @inlinable public func swapAt(_ i: Int, _ j: Int)

    /// A sequence that represents a contiguous subrange of the collection's
    /// elements.
    ///
    /// This associated type appears as a requirement in the `Sequence`
    /// protocol, but it is restated here with stricter constraints. In a
    /// collection, the subsequence should also conform to `Collection`.
    public typealias SubSequence = Slice<UnsafeMutableBufferPointer<Element>>
}

extension UnsafeMutableBufferPointer where Element : Equatable {

    /// Returns the longest possible subsequences of the collection, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the collection are not returned as part
    /// of any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " "))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the collection and for each instance of `separator` at
    ///     the start or end of the collection. If `true`, only nonempty
    ///     subsequences are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Slice<UnsafeMutableBufferPointer<Element>>]

    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `firstIndex(of:)` to find the position of a particular element
    /// in a collection, you can use it to access the element by subscripting.
    /// This example shows how you can modify one of the names in an array of
    /// students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Maxime"]
    ///     if let i = students.firstIndex(of: "Maxime") {
    ///         students[i] = "Max"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(of element: Element) -> Int?

    /// Returns the last index where the specified value appears in the
    /// collection.
    ///
    /// After using `lastIndex(of:)` to find the position of the last instance of
    /// a particular element in a collection, you can use it to access the
    /// element by subscripting. This example shows how you can modify one of
    /// the names in an array of students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Ben", "Maxime"]
    ///     if let i = students.lastIndex(of: "Ben") {
    ///         students[i] = "Benjamin"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Benjamin", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The last index where `element` is found. If `element` is not
    ///   found in the collection, this method returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(of element: Element) -> Int?

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///
    /// - Returns: The difference needed to produce this collection's ordered
    ///   elements from the given collection.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements, or
    ///   if `Element` conforms to `Hashable`.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C) -> CollectionDifference<Element> where C : BidirectionalCollection, Element == C.Element

    /// Returns the first index where the specified value appears in the
    /// collection.
    @available(swift, deprecated: 5.0, renamed: "firstIndex(of:)")
    @inlinable public func index(of element: Element) -> Int?

    /// Returns the longest possible subsequences of the sequence, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " ")
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1)
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false)
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the sequence, or one
    ///     less than the number of subsequences to return. If `maxSplits + 1`
    ///     subsequences are returned, the last one is a suffix of the original
    ///     sequence containing the remaining elements. `maxSplits` must be
    ///     greater than or equal to zero. The default value is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the sequence and for each instance of `separator` at the
    ///     start or end of the sequence. If `true`, only nonempty subsequences
    ///     are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [ArraySlice<Element>]

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are the same as the elements in another sequence.
    ///
    /// This example tests whether one countable range begins with the elements
    /// of another countable range.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(b.starts(with: a))
    ///     // Prints "true"
    ///
    /// Passing a sequence with no elements or an empty collection as
    /// `possiblePrefix` always results in `true`.
    ///
    ///     print(b.starts(with: []))
    ///     // Prints "true"
    ///
    /// - Parameter possiblePrefix: A sequence to compare to this sequence.
    /// - Returns: `true` if the initial elements of the sequence are the same as
    ///   the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain the same elements in the same order.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// This example tests whether one countable range shares the same elements
    /// as another countable range and an array.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(a.elementsEqual(b))
    ///     // Prints "false"
    ///     print(a.elementsEqual([1, 2, 3]))
    ///     // Prints "true"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence and `other` contain the same elements
    ///   in the same order.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains the
    /// given element.
    ///
    /// This example checks to see whether a favorite actor is in an array
    /// storing a movie's cast.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     print(cast.contains("Marlon"))
    ///     // Prints "true"
    ///     print(cast.contains("James"))
    ///     // Prints "false"
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: `true` if the element was found in the sequence; otherwise,
    ///   `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(_ element: Element) -> Bool
}

extension UnsafeMutableBufferPointer where Element : Comparable {

    /// Returns the minimum element in the sequence.
    ///
    /// This example finds the smallest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let lowestHeight = heights.min()
    ///     print(lowestHeight)
    ///     // Prints "Optional(58.5)"
    ///
    /// - Returns: The sequence's minimum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min() -> Element?

    /// Returns the maximum element in the sequence.
    ///
    /// This example finds the largest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let greatestHeight = heights.max()
    ///     print(greatestHeight)
    ///     // Prints "Optional(67.5)"
    ///
    /// - Returns: The sequence's maximum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max() -> Element?

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the
    /// less-than operator (`<`) to compare elements.
    ///
    /// This example uses the `lexicographicallyPrecedes` method to test which
    /// array of integers comes first in a lexicographical ordering.
    ///
    ///     let a = [1, 2, 2, 2]
    ///     let b = [1, 2, 3, 4]
    ///
    ///     print(a.lexicographicallyPrecedes(b))
    ///     // Prints "true"
    ///     print(b.lexicographicallyPrecedes(b))
    ///     // Prints "false"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that
    ///   perform localized comparison.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element

    /// Returns the elements of the sequence, sorted.
    ///
    /// You can sort any sequence of elements that conform to the `Comparable`
    /// protocol by calling this method. Elements are sorted in ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let sortedStudents = students.sorted()
    ///     print(sortedStudents)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your sequence in descending order, pass the
    /// greater-than operator (`>`) to the `sorted(by:)` method.
    ///
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted() -> [Element]

    /// Sorts the collection in place.
    ///
    /// You can sort any mutable collection of elements that conform to the
    /// `Comparable` protocol by calling this method. Elements are sorted in
    /// ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     var students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     students.sort()
    ///     print(students)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your collection in descending order, pass the
    /// greater-than operator (`>`) to the `sort(by:)` method.
    ///
    ///     students.sort(by: >)
    ///     print(students)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the collection.
    @inlinable public mutating func sort()
}

extension UnsafeMutableBufferPointer where Element : StringProtocol {

    /// Returns a new string by concatenating the elements of the sequence,
    /// adding the given separator between each element.
    ///
    /// The following example shows how an array of strings can be joined to a
    /// single, comma-separated string:
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let list = cast.joined(separator: ", ")
    ///     print(list)
    ///     // Prints "Vivien, Marlon, Kim, Karl"
    ///
    /// - Parameter separator: A string to insert between each of the elements
    ///   in this sequence. The default separator is an empty string.
    /// - Returns: A single, concatenated string.
    public func joined(separator: String = "") -> String
}

extension UnsafeMutableBufferPointer where Element == String {

    /// Returns a new string by concatenating the elements of the sequence,
    /// adding the given separator between each element.
    ///
    /// The following example shows how an array of strings can be joined to a
    /// single, comma-separated string:
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let list = cast.joined(separator: ", ")
    ///     print(list)
    ///     // Prints "Vivien, Marlon, Kim, Karl"
    ///
    /// - Parameter separator: A string to insert between each of the elements
    ///   in this sequence. The default separator is an empty string.
    /// - Returns: A single, concatenated string.
    public func joined(separator: String = "") -> String
}

extension UnsafeMutableBufferPointer where Element : Sequence {

    /// Returns the elements of this sequence of sequences, concatenated.
    ///
    /// In this example, an array of three ranges is flattened so that the
    /// elements of each range can be iterated in turn.
    ///
    ///     let ranges = [0..<3, 8..<10, 15..<17]
    ///
    ///     // A for-in loop over 'ranges' accesses each range:
    ///     for range in ranges {
    ///       print(range)
    ///     }
    ///     // Prints "0..<3"
    ///     // Prints "8..<10"
    ///     // Prints "15..<17"
    ///
    ///     // Use 'joined()' to access each element of each range:
    ///     for index in ranges.joined() {
    ///         print(index, terminator: " ")
    ///     }
    ///     // Prints: "0 1 2 8 9 15 16"
    ///
    /// - Returns: A flattened view of the elements of this
    ///   sequence of sequences.
    @inlinable public func joined() -> FlattenSequence<UnsafeMutableBufferPointer<Element>>

    /// Returns the concatenated elements of this sequence of sequences,
    /// inserting the given separator between each element.
    ///
    /// This example shows how an array of `[Int]` instances can be joined, using
    /// another `[Int]` instance as the separator:
    ///
    ///     let nestedNumbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    ///     let joined = nestedNumbers.joined(separator: [-1, -2])
    ///     print(Array(joined))
    ///     // Prints "[1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9]"
    ///
    /// - Parameter separator: A sequence to insert between each of this
    ///   sequence's elements.
    /// - Returns: The joined sequence of elements.
    @inlinable public func joined<Separator>(separator: Separator) -> JoinedSequence<UnsafeMutableBufferPointer<Element>> where Separator : Sequence, Separator.Element == Element.Element
}

@frozen public struct UnsafeBufferPointer<Element> {

    /// The number of elements in the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    public let count: Int

    /// An iterator for the elements in the buffer referenced by an
    /// `UnsafeBufferPointer` or `UnsafeMutableBufferPointer` instance.
    @frozen public struct Iterator {
    }

    /// Creates a new buffer pointer over the specified number of contiguous
    /// instances beginning at the given pointer.
    ///
    /// - Parameters:
    ///   - start: A pointer to the start of the buffer, or `nil`. If `start` is
    ///     `nil`, `count` must be zero. However, `count` may be zero even for a
    ///     non-`nil` `start`. The pointer passed as `start` must be aligned to
    ///     `MemoryLayout<Element>.alignment`.
    ///   - count: The number of instances in the buffer. `count` must not be
    ///     negative.
    @inlinable public init(start: UnsafePointer<Element>?, count: Int)

    /// Creates an immutable typed buffer pointer referencing the same memory as the
    /// given mutable buffer pointer.
    ///
    /// - Parameter other: The mutable buffer pointer to convert.
    @inlinable public init(_ other: UnsafeMutableBufferPointer<Element>)

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R?

    /// Creates a buffer over the same memory as the given buffer slice.
    ///
    /// The new buffer represents the same region of memory as `slice`, but is
    /// indexed starting at zero instead of sharing indices with the original
    /// buffer. For example:
    ///
    ///     let buffer = returnsABuffer()
    ///     let n = 5
    ///     let slice = buffer[n...]
    ///     let rebased = UnsafeBufferPointer(rebasing: slice)
    ///
    /// After rebasing `slice` as the `rebased` buffer, the following are true:
    ///
    /// - `rebased.startIndex == 0`
    /// - `rebased[0] == slice[n]`
    /// - `rebased[0] == buffer[n]`
    /// - `rebased.count == slice.count`
    ///
    /// - Parameter slice: The buffer slice to rebase.
    @inlinable public init(rebasing slice: Slice<UnsafeBufferPointer<Element>>)

    /// Creates a buffer over the same memory as the given buffer slice.
    ///
    /// The new buffer represents the same region of memory as `slice`, but is
    /// indexed starting at zero instead of sharing indices with the original
    /// buffer. For example:
    ///
    ///     let buffer = returnsABuffer()
    ///     let n = 5
    ///     let slice = buffer[n...]
    ///     let rebased = UnsafeBufferPointer(rebasing: slice)
    ///
    /// After rebasing `slice` as the `rebased` buffer, the following are true:
    ///
    /// - `rebased.startIndex == 0`
    /// - `rebased[0] == slice[n]`
    /// - `rebased[0] == buffer[n]`
    /// - `rebased.count == slice.count`
    ///
    /// - Parameter slice: The buffer slice to rebase.
    @inlinable public init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>)

    /// Deallocates the memory block previously allocated at this buffer pointer’s
    /// base address.
    ///
    /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory
    /// block previously returned by a Swift allocation method. If `baseAddress` is
    /// `nil`, this function does nothing. Otherwise, the memory must not be initialized
    /// or `Pointee` must be a trivial type. This buffer pointer's `count` must
    /// be equal to the originally allocated size of the memory block.
    @inlinable public func deallocate()

    /// Executes the given closure while temporarily binding the memory referenced
    /// by this buffer to the given type.
    ///
    /// Use this method when you have a buffer of memory bound to one type and
    /// you need to access that memory as a buffer of another type. Accessing
    /// memory as type `T` requires that the memory be bound to that type. A
    /// memory location may only be bound to one type at a time, so accessing
    /// the same memory as an unrelated type without first rebinding the memory
    /// is undefined.
    ///
    /// The entire region of memory referenced by this buffer must be initialized.
    ///
    /// Because this buffer's memory is no longer bound to its `Element` type
    /// while the `body` closure executes, do not access memory using the
    /// original buffer from within `body`. Instead, use the `body` closure's
    /// buffer argument to access the values in memory as instances of type
    /// `T`.
    ///
    /// After executing `body`, this method rebinds memory back to the original
    /// `Element` type.
    ///
    /// - Note: Only use this method to rebind the buffer's memory to a type
    ///   with the same size and stride as the currently bound `Element` type.
    ///   To bind a region of memory to a type that is a different size, convert
    ///   the buffer to a raw buffer and use the `bindMemory(to:)` method.
    ///
    /// - Parameters:
    ///   - type: The type to temporarily bind the memory referenced by this
    ///     buffer. The type `T` must have the same size and be layout compatible
    ///     with the pointer's `Element` type.
    ///   - body: A closure that takes a  typed buffer to the
    ///     same memory as this buffer, only bound to type `T`. The buffer argument
    ///     contains the same number of complete instances of `T` as the original
    ///     buffer’s `count`. The closure's buffer argument is valid only for the
    ///     duration of the closure's execution. If `body` has a return value, that
    ///     value is also used as the return value for the `withMemoryRebound(to:_:)`
    ///     method.
    /// - Returns: The return value, if any, of the `body` closure parameter.
    @inlinable public func withMemoryRebound<T, Result>(to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws -> Result) rethrows -> Result

    /// A pointer to the first element of the buffer.
    ///
    /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    /// a buffer can have a `count` of zero even with a non-`nil` base address.
    @inlinable public var baseAddress: UnsafePointer<Element>? { get }

    /// Returns a subsequence containing all but the specified number of final
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in the
    /// collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropLast(2))
    ///     // Prints "[1, 2, 3]"
    ///     print(numbers.dropLast(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop off the end of the
    ///   collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence that leaves off `k` elements from the end.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop.
    @inlinable public func dropLast(_ k: Int) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence, up to the given maximum length, containing the
    /// final elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains the entire collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.suffix(2))
    ///     // Prints "[4, 5]"
    ///     print(numbers.suffix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence terminating at the end of the collection with at
    ///   most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is equal to
    ///   `maxLength`.
    @inlinable public func suffix(_ maxLength: Int) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    @inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]

    /// Returns a subsequence containing all but the given number of initial
    /// elements.
    ///
    /// If the number of elements to drop exceeds the number of elements in
    /// the collection, the result is an empty subsequence.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.dropFirst(2))
    ///     // Prints "[3, 4, 5]"
    ///     print(numbers.dropFirst(10))
    ///     // Prints "[]"
    ///
    /// - Parameter k: The number of elements to drop from the beginning of
    ///   the collection. `k` must be greater than or equal to zero.
    /// - Returns: A subsequence starting after the specified number of
    ///   elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to drop from the beginning of the collection.
    @inlinable public func dropFirst(_ k: Int = 1) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence by skipping elements while `predicate` returns
    /// `true` and returning the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be skipped or `false` if it should be included. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func drop(while predicate: (Element) throws -> Bool) rethrows -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence, up to the specified maximum length, containing
    /// the initial elements of the collection.
    ///
    /// If the maximum length exceeds the number of elements in the collection,
    /// the result contains all the elements in the collection.
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     print(numbers.prefix(2))
    ///     // Prints "[1, 2]"
    ///     print(numbers.prefix(10))
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///
    /// - Parameter maxLength: The maximum number of elements to return.
    ///   `maxLength` must be greater than or equal to zero.
    /// - Returns: A subsequence starting at the beginning of this collection
    ///   with at most `maxLength` elements.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the number of
    ///   elements to select from the beginning of the collection.
    @inlinable public func prefix(_ maxLength: Int) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence containing the initial elements until `predicate`
    /// returns `false` and skipping the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns `true` if the element should
    ///   be included or `false` if it should be excluded. Once the predicate
    ///   returns `false` it will not be called again.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func prefix(while predicate: (Element) throws -> Bool) rethrows -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence from the start of the collection up to, but not
    /// including, the specified position.
    ///
    /// The resulting subsequence *does not include* the element at the position
    /// `end`. The following example searches for the index of the number `40`
    /// in an array of integers, and then prints the prefix of the array up to,
    /// but not including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(upTo: i))
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// Passing the collection's starting index as the `end` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.prefix(upTo: numbers.startIndex))
    ///     // Prints "[]"
    ///
    /// Using the `prefix(upTo:)` method is equivalent to using a partial
    /// half-open range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(upTo:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[..<i])
    ///     }
    ///     // Prints "[10, 20, 30]"
    ///
    /// - Parameter end: The "past the end" index of the resulting subsequence.
    ///   `end` must be a valid index of the collection.
    /// - Returns: A subsequence up to, but not including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(upTo end: Int) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence from the specified position to the end of the
    /// collection.
    ///
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the suffix of the array starting at
    /// that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.suffix(from: i))
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// Passing the collection's `endIndex` as the `start` parameter results in
    /// an empty subsequence.
    ///
    ///     print(numbers.suffix(from: numbers.endIndex))
    ///     // Prints "[]"
    ///
    /// Using the `suffix(from:)` method is equivalent to using a partial range
    /// from the index as the collection's subscript. The subscript notation is
    /// preferred over `suffix(from:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[i...])
    ///     }
    ///     // Prints "[40, 50, 60]"
    ///
    /// - Parameter start: The index at which to start the resulting subsequence.
    ///   `start` must be a valid index of the collection.
    /// - Returns: A subsequence starting at the `start` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func suffix(from start: Int) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns a subsequence from the start of the collection through the
    /// specified position.
    ///
    /// The resulting subsequence *includes* the element at the position `end`.
    /// The following example searches for the index of the number `40` in an
    /// array of integers, and then prints the prefix of the array up to, and
    /// including, that index:
    ///
    ///     let numbers = [10, 20, 30, 40, 50, 60]
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers.prefix(through: i))
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// Using the `prefix(through:)` method is equivalent to using a partial
    /// closed range as the collection's subscript. The subscript notation is
    /// preferred over `prefix(through:)`.
    ///
    ///     if let i = numbers.firstIndex(of: 40) {
    ///         print(numbers[...i])
    ///     }
    ///     // Prints "[10, 20, 30, 40]"
    ///
    /// - Parameter end: The index of the last element to include in the
    ///   resulting subsequence. `end` must be a valid index of the collection
    ///   that is not equal to the `endIndex` property.
    /// - Returns: A subsequence up to, and including, the `end` position.
    ///
    /// - Complexity: O(1)
    @inlinable public func prefix(through position: Int) -> Slice<UnsafeBufferPointer<Element>>

    /// Returns the longest possible subsequences of the collection, in order,
    /// that don't contain elements satisfying the given predicate.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string using a
    /// closure that matches spaces. The first use of `split` returns each word
    /// that was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(maxSplits: 1, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(omittingEmptySubsequences: false, whereSeparator: { $0 == " " }))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each pair of consecutive elements
    ///     satisfying the `isSeparator` predicate and for each element at the
    ///     start or end of the collection satisfying the `isSeparator`
    ///     predicate. The default value is `true`.
    ///   - isSeparator: A closure that takes an element as an argument and
    ///     returns a Boolean value indicating whether the collection should be
    ///     split at that element.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, whereSeparator isSeparator: (Element) throws -> Bool) rethrows -> [Slice<UnsafeBufferPointer<Element>>]

    /// The last element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let lastNumber = numbers.last {
    ///         print(lastNumber)
    ///     }
    ///     // Prints "50"
    ///
    /// - Complexity: O(1)
    @inlinable public var last: Element? { get }

    /// Returns the first index in which an element of the collection satisfies
    /// the given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. Here's an example that finds a student name that
    /// begins with the letter "A":
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.firstIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Abena starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the first element for which `predicate` returns
    ///   `true`. If no elements in the collection satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?

    /// Returns the last element of the sequence that satisfies the given
    /// predicate.
    ///
    /// This example uses the `last(where:)` method to find the last
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let lastNegative = numbers.last(where: { $0 < 0 }) {
    ///         print("The last negative number is \(lastNegative).")
    ///     }
    ///     // Prints "The last negative number is -6."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The last element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func last(where predicate: (Element) throws -> Bool) rethrows -> Element?

    /// Returns the index of the last element in the collection that matches the
    /// given predicate.
    ///
    /// You can use the predicate to find an element of a type that doesn't
    /// conform to the `Equatable` protocol or to find an element that matches
    /// particular criteria. This example finds the index of the last name that
    /// begins with the letter *A:*
    ///
    ///     let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     if let i = students.lastIndex(where: { $0.hasPrefix("A") }) {
    ///         print("\(students[i]) starts with 'A'!")
    ///     }
    ///     // Prints "Akosua starts with 'A'!"
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the last element in the collection that matches
    ///   `predicate`, or `nil` if no elements match.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?

    /// Returns the elements of the sequence, shuffled using the given generator
    /// as a source for randomness.
    ///
    /// You use this method to randomize the elements of a sequence when you are
    /// using a custom random number generator. For example, you can shuffle the
    /// numbers between `0` and `9` by calling the `shuffled(using:)` method on
    /// that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled(using: &myGenerator)
    ///     // shuffledNumbers == [8, 9, 4, 3, 2, 6, 7, 0, 5, 1]
    ///
    /// - Parameter generator: The random number generator to use when shuffling
    ///   the sequence.
    /// - Returns: An array of this sequence's elements in a shuffled order.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    /// - Note: The algorithm used to shuffle a sequence may change in a future
    ///   version of Swift. If you're passing a generator that results in the
    ///   same shuffled order each time you run your program, that sequence may
    ///   change when your program is compiled using a different version of
    ///   Swift.
    @inlinable public func shuffled<T>(using generator: inout T) -> [Element] where T : RandomNumberGenerator

    /// Returns the elements of the sequence, shuffled.
    ///
    /// For example, you can shuffle the numbers between `0` and `9` by calling
    /// the `shuffled()` method on that range:
    ///
    ///     let numbers = 0...9
    ///     let shuffledNumbers = numbers.shuffled()
    ///     // shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]
    ///
    /// This method is equivalent to calling `shuffled(using:)`, passing in the
    /// system's default random generator.
    ///
    /// - Returns: A shuffled array of this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func shuffled() -> [Element]

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection, using the given predicate as an
    /// equivalence test.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///   - areEquivalent: A closure that returns a Boolean value indicating
    ///     whether two elements are equivalent.
    ///
    /// - Returns: The difference needed to produce the reciever's state from
    ///   the parameter's state.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C, by areEquivalent: (C.Element, Element) -> Bool) -> CollectionDifference<Element> where C : BidirectionalCollection, Element == C.Element

    /// A sequence containing the same elements as this sequence,
    /// but on which some operations, such as `map` and `filter`, are
    /// implemented lazily.
    @inlinable public var lazy: LazySequence<UnsafeBufferPointer<Element>> { get }

    @available(swift, deprecated: 4.1, renamed: "compactMap(_:)", message: "Please use compactMap(_:) for the case where closure returns an optional value")
    public func flatMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Accesses the contiguous subrange of the collection's elements specified
    /// by a range expression.
    ///
    /// The range expression is converted to a concrete subrange relative to this
    /// collection. For example, using a `PartialRangeFrom` range expression
    /// with an array accesses the subrange from the start of the range
    /// expression until the end of the array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2...]
    ///     print(streetsSlice)
    ///     // ["Channing", "Douglas", "Evarts"]
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection uses. This example searches `streetsSlice` for one
    /// of the strings in the slice, and then uses that index in the original
    /// array.
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // "Evarts"
    ///
    /// Always use the slice's `startIndex` property instead of assuming that its
    /// indices start at a particular value. Attempting to access an element by
    /// using an index outside the bounds of the slice's indices may result in a
    /// runtime error, even if that index is valid for the original collection.
    ///
    ///     print(streetsSlice.startIndex)
    ///     // 2
    ///     print(streetsSlice[2])
    ///     // "Channing"
    ///
    ///     print(streetsSlice[0])
    ///     // error: Index out of bounds
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript<R>(r: R) -> Slice<UnsafeBufferPointer<Element>> where R : RangeExpression, Int == R.Bound { get }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> Slice<UnsafeBufferPointer<Element>> { get }

    /// Returns a view presenting the elements of the collection in reverse
    /// order.
    ///
    /// You can reverse a collection without allocating new space for its
    /// elements by calling this `reversed()` method. A `ReversedCollection`
    /// instance wraps an underlying collection and provides access to its
    /// elements in reverse order. This example prints the characters of a
    /// string in reverse order:
    ///
    ///     let word = "Backwards"
    ///     for char in word.reversed() {
    ///         print(char, terminator: "")
    ///     }
    ///     // Prints "sdrawkcaB"
    ///
    /// If you need a reversed collection of the same type, you may be able to
    /// use the collection's sequence-based or collection-based initializer. For
    /// example, to get the reversed version of a string, reverse its
    /// characters and initialize a new `String` instance from the result.
    ///
    ///     let reversedWord = String(word.reversed())
    ///     print(reversedWord)
    ///     // Prints "sdrawkcaB"
    ///
    /// - Complexity: O(1)
    @inlinable public func reversed() -> ReversedCollection<UnsafeBufferPointer<Element>>

    /// Returns an array containing the results of mapping the given closure
    /// over the sequence's elements.
    ///
    /// In this example, `map` is used first to convert the names in the array
    /// to lowercase strings and then to count their characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let lowercaseNames = cast.map { $0.lowercased() }
    ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
    ///     let letterCounts = cast.map { $0.count }
    ///     // 'letterCounts' == [6, 6, 3, 4]
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an
    ///   element of this sequence as its parameter and returns a transformed
    ///   value of the same or of a different type.
    /// - Returns: An array containing the transformed elements of this
    ///   sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]

    /// Returns an array containing, in order, the elements of the sequence
    /// that satisfy the given predicate.
    ///
    /// In this example, `filter(_:)` is used to include only names shorter than
    /// five characters.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let shortNames = cast.filter { $0.count < 5 }
    ///     print(shortNames)
    ///     // Prints "["Kim", "Karl"]"
    ///
    /// - Parameter isIncluded: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be included in the returned array.
    /// - Returns: An array of the elements that `isIncluded` allowed.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]

    /// A value less than or equal to the number of elements in the sequence,
    /// calculated nondestructively.
    ///
    /// The default implementation returns 0. If you provide your own
    /// implementation, make sure to compute the value nondestructively.
    ///
    /// - Complexity: O(1), except if the sequence also conforms to `Collection`.
    ///   In this case, see the documentation of `Collection.underestimatedCount`.
    @inlinable public var underestimatedCount: Int { get }

    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEach(_ body: (Element) throws -> Void) rethrows

    /// Returns the first element of the sequence that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `first(where:)` method to find the first
    /// negative number in an array of integers:
    ///
    ///     let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
    ///     if let firstNegative = numbers.first(where: { $0 < 0 }) {
    ///         print("The first negative number is \(firstNegative).")
    ///     }
    ///     // Prints "The first negative number is -2."
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns a Boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The first element of the sequence that satisfies `predicate`,
    ///   or `nil` if there is no element that satisfies `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func first(where predicate: (Element) throws -> Bool) rethrows -> Element?

    /// Call `body(p)`, where `p` is a pointer to the collection's
    /// contiguous storage.  If no such storage exists, it is
    /// first created.  If the collection does not support an internal
    /// representation in a form of contiguous storage, `body` is not
    /// called and `nil` is returned.
    ///
    /// A `Collection` that provides its own implementation of this method
    /// must also guarantee that an equivalent buffer of its `SubSequence`
    /// can be generated by advancing the pointer by the distance to the
    /// slice's `startIndex`.
    @inlinable public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R?

    /// Returns a sequence of pairs (*n*, *x*), where *n* represents a
    /// consecutive integer starting at zero and *x* represents an element of
    /// the sequence.
    ///
    /// This example enumerates the characters of the string "Swift" and prints
    /// each character along with its place in the string.
    ///
    ///     for (n, c) in "Swift".enumerated() {
    ///         print("\(n): '\(c)'")
    ///     }
    ///     // Prints "0: 'S'"
    ///     // Prints "1: 'w'"
    ///     // Prints "2: 'i'"
    ///     // Prints "3: 'f'"
    ///     // Prints "4: 't'"
    ///
    /// When you enumerate a collection, the integer part of each pair is a counter
    /// for the enumeration, but is not necessarily the index of the paired value.
    /// These counters can be used as indices only in instances of zero-based,
    /// integer-indexed collections, such as `Array` and `ContiguousArray`. For
    /// other collections the counters may be out of range or of the wrong type
    /// to use as an index. To iterate over the elements of a collection with its
    /// indices, use the `zip(_:_:)` function.
    ///
    /// This example iterates over the indices and elements of a set, building a
    /// list consisting of indices of names with five or fewer letters.
    ///
    ///     let names: Set = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     var shorterIndices: [Set<String>.Index] = []
    ///     for (i, name) in zip(names.indices, names) {
    ///         if name.count <= 5 {
    ///             shorterIndices.append(i)
    ///         }
    ///     }
    ///
    /// Now that the `shorterIndices` array holds the indices of the shorter
    /// names in the `names` set, you can use those indices to access elements in
    /// the set.
    ///
    ///     for i in shorterIndices {
    ///         print(names[i])
    ///     }
    ///     // Prints "Sofia"
    ///     // Prints "Mateo"
    ///
    /// - Returns: A sequence of pairs enumerating the sequence.
    ///
    /// - Complexity: O(1)
    @inlinable public func enumerated() -> EnumeratedSequence<UnsafeBufferPointer<Element>>

    /// Returns the minimum element in the sequence, using the given predicate as
    /// the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `min(by:)` method on a
    /// dictionary to find the key-value pair with the lowest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let leastHue = hues.min { a, b in a.value < b.value }
    ///     print(leastHue)
    ///     // Prints "Optional((key: "Coral", value: 16))"
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true`
    ///   if its first argument should be ordered before its second
    ///   argument; otherwise, `false`.
    /// - Returns: The sequence's minimum element, according to
    ///   `areInIncreasingOrder`. If the sequence has no elements, returns
    ///   `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element?

    /// Returns the maximum element in the sequence, using the given predicate
    /// as the comparison between elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// This example shows how to use the `max(by:)` method on a
    /// dictionary to find the key-value pair with the highest value.
    ///
    ///     let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     let greatestHue = hues.max { a, b in a.value < b.value }
    ///     print(greatestHue)
    ///     // Prints "Optional((key: "Heliotrope", value: 296))"
    ///
    /// - Parameter areInIncreasingOrder:  A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: The sequence's maximum element if the sequence is not empty;
    ///   otherwise, `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element?

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are equivalent to the elements in another sequence, using
    /// the given predicate as the equivalence test.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - possiblePrefix: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if the initial elements of the sequence are equivalent
    ///   to the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix, by areEquivalent: (Element, PossiblePrefix.Element) throws -> Bool) rethrows -> Bool where PossiblePrefix : Sequence

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain equivalent elements in the same order, using the given
    /// predicate as the equivalence test.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// The predicate must be a *equivalence relation* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areEquivalent(a, a)` is always `true`. (Reflexivity)
    /// - `areEquivalent(a, b)` implies `areEquivalent(b, a)`. (Symmetry)
    /// - If `areEquivalent(a, b)` and `areEquivalent(b, c)` are both `true`, then
    ///   `areEquivalent(a, c)` is also `true`. (Transitivity)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areEquivalent: A predicate that returns `true` if its two arguments
    ///     are equivalent; otherwise, `false`.
    /// - Returns: `true` if this sequence and `other` contain equivalent items,
    ///   using `areEquivalent` as the equivalence test; otherwise, `false.`
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence, by areEquivalent: (Element, OtherSequence.Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the given
    /// predicate to compare elements.
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also
    ///   `true`. (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// - Parameters:
    ///   - other: A sequence to compare to this sequence.
    ///   - areInIncreasingOrder:  A predicate that returns `true` if its first
    ///     argument should be ordered before its second argument; otherwise,
    ///     `false`.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering as ordered by `areInIncreasingOrder`; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that perform
    ///   localized comparison instead.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence, by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains an
    /// element that satisfies the given predicate.
    ///
    /// You can use the predicate to check for an element of a type that
    /// doesn't conform to the `Equatable` protocol, such as the
    /// `HTTPResponse` enumeration in this example.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]
    ///     let hadError = lastThreeResponses.contains { element in
    ///         if case .error = element {
    ///             return true
    ///         } else {
    ///             return false
    ///         }
    ///     }
    ///     // 'hadError' == true
    ///
    /// Alternatively, a predicate can be satisfied by a range of `Equatable`
    /// elements or a general condition. This example shows how you can check an
    /// array for an expense greater than $100.
    ///
    ///     let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
    ///     let hasBigPurchase = expenses.contains { $0 > 100 }
    ///     // 'hasBigPurchase' == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element represents a match.
    /// - Returns: `true` if the sequence contains an element that satisfies
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool

    /// Returns a Boolean value indicating whether every element of a sequence
    /// satisfies a given predicate.
    ///
    /// The following code uses this method to test whether all the names in an
    /// array have at least five characters:
    ///
    ///     let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
    ///     let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
    ///     // allHaveAtLeastFive == true
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value that indicates whether
    ///   the passed element satisfies a condition.
    /// - Returns: `true` if the sequence contains only elements that satisfy
    ///   `predicate`; otherwise, `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(_:_:)` method to produce a single value from the elements
    /// of an entire sequence. For example, you can use this method on an array
    /// of numbers to find their sum or product.
    ///
    /// The `nextPartialResult` closure is called sequentially with an
    /// accumulating value initialized to `initialResult` and each element of
    /// the sequence. This example shows how to find the sum of an array of
    /// numbers.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///     let numberSum = numbers.reduce(0, { x, y in
    ///         x + y
    ///     })
    ///     // numberSum == 10
    ///
    /// When `numbers.reduce(_:_:)` is called, the following steps occur:
    ///
    /// 1. The `nextPartialResult` closure is called with `initialResult`---`0`
    ///    in this case---and the first element of `numbers`, returning the sum:
    ///    `1`.
    /// 2. The closure is called again repeatedly with the previous call's return
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the last value returned from the
    ///    closure is returned to the caller.
    ///
    /// If the sequence has no elements, `nextPartialResult` is never executed
    /// and `initialResult` is the result of the call to `reduce(_:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///     `initialResult` is passed to `nextPartialResult` the first time the
    ///     closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and
    ///     an element of the sequence into a new accumulating value, to be used
    ///     in the next call of the `nextPartialResult` closure or returned to
    ///     the caller.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result

    /// Returns the result of combining the elements of the sequence using the
    /// given closure.
    ///
    /// Use the `reduce(into:_:)` method to produce a single value from the
    /// elements of an entire sequence. For example, you can use this method on an
    /// array of integers to filter adjacent equal entries or count frequencies.
    ///
    /// This method is preferred over `reduce(_:_:)` for efficiency when the
    /// result is a copy-on-write type, for example an Array or a Dictionary.
    ///
    /// The `updateAccumulatingResult` closure is called sequentially with a
    /// mutable accumulating value initialized to `initialResult` and each element
    /// of the sequence. This example shows how to build a dictionary of letter
    /// frequencies of a string.
    ///
    ///     let letters = "abracadabra"
    ///     let letterCount = letters.reduce(into: [:]) { counts, letter in
    ///         counts[letter, default: 0] += 1
    ///     }
    ///     // letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1]
    ///
    /// When `letters.reduce(into:_:)` is called, the following steps occur:
    ///
    /// 1. The `updateAccumulatingResult` closure is called with the initial
    ///    accumulating value---`[:]` in this case---and the first character of
    ///    `letters`, modifying the accumulating value by setting `1` for the key
    ///    `"a"`.
    /// 2. The closure is called again repeatedly with the updated accumulating
    ///    value and each element of the sequence.
    /// 3. When the sequence is exhausted, the accumulating value is returned to
    ///    the caller.
    ///
    /// If the sequence has no elements, `updateAccumulatingResult` is never
    /// executed and `initialResult` is the result of the call to
    /// `reduce(into:_:)`.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating
    ///     value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements,
    ///   the result is `initialResult`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result

    /// Returns an array containing the concatenated results of calling the
    /// given transformation with each element of this sequence.
    ///
    /// Use this method to receive a single-level collection when your
    /// transformation produces a sequence or collection for each element.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `flatMap` with a transformation that returns an array.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///
    ///     let mapped = numbers.map { Array(repeating: $0, count: $0) }
    ///     // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
    ///
    ///     let flatMapped = numbers.flatMap { Array(repeating: $0, count: $0) }
    ///     // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
    ///
    /// In fact, `s.flatMap(transform)`  is equivalent to
    /// `Array(s.map(transform).joined())`.
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns a sequence or collection.
    /// - Returns: The resulting flattened array.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func flatMap<SegmentOfResult>(_ transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence

    /// Returns an array containing the non-`nil` results of calling the given
    /// transformation with each element of this sequence.
    ///
    /// Use this method to receive an array of non-optional values when your
    /// transformation produces an optional value.
    ///
    /// In this example, note the difference in the result of using `map` and
    /// `compactMap` with a transformation that returns an optional `Int` value.
    ///
    ///     let possibleNumbers = ["1", "2", "three", "///4///", "5"]
    ///
    ///     let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
    ///     // [1, 2, nil, nil, 5]
    ///
    ///     let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
    ///     // [1, 2, 5]
    ///
    /// - Parameter transform: A closure that accepts an element of this
    ///   sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-`nil` results of calling `transform`
    ///   with each element of the sequence.
    ///
    /// - Complexity: O(*m* + *n*), where *n* is the length of this sequence
    ///   and *m* is the length of the result.
    @inlinable public func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]

    /// Returns the elements of the sequence, sorted using the given predicate as
    /// the comparison between elements.
    ///
    /// When you want to sort a sequence of elements that don't conform to the
    /// `Comparable` protocol, pass a predicate to this method that returns
    /// `true` when the first element should be ordered before the second. The
    /// elements of the resulting array are ordered according to the given
    /// predicate.
    ///
    /// In the following example, the predicate provides an ordering for an array
    /// of a custom `HTTPResponse` type. The predicate orders errors before
    /// successes and sorts the error responses by their error code.
    ///
    ///     enum HTTPResponse {
    ///         case ok
    ///         case error(Int)
    ///     }
    ///
    ///     let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
    ///     let sortedResponses = responses.sorted {
    ///         switch ($0, $1) {
    ///         // Order errors by code
    ///         case let (.error(aCode), .error(bCode)):
    ///             return aCode < bCode
    ///
    ///         // All successes are equivalent, so none is before any other
    ///         case (.ok, .ok): return false
    ///
    ///         // Order errors before successes
    ///         case (.error, .ok): return true
    ///         case (.ok, .error): return false
    ///         }
    ///     }
    ///     print(sortedResponses)
    ///     // Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
    ///
    /// You also use this method to sort elements that conform to the
    /// `Comparable` protocol in descending order. To sort your sequence in
    /// descending order, pass the greater-than operator (`>`) as the
    /// `areInIncreasingOrder` parameter.
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// Calling the related `sorted()` method is equivalent to calling this
    /// method and passing the less-than operator (`<`) as the predicate.
    ///
    ///     print(students.sorted())
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///     print(students.sorted(by: <))
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// The predicate must be a *strict weak ordering* over the elements. That
    /// is, for any elements `a`, `b`, and `c`, the following conditions must
    /// hold:
    ///
    /// - `areInIncreasingOrder(a, a)` is always `false`. (Irreflexivity)
    /// - If `areInIncreasingOrder(a, b)` and `areInIncreasingOrder(b, c)` are
    ///   both `true`, then `areInIncreasingOrder(a, c)` is also `true`.
    ///   (Transitive comparability)
    /// - Two elements are *incomparable* if neither is ordered before the other
    ///   according to the predicate. If `a` and `b` are incomparable, and `b`
    ///   and `c` are incomparable, then `a` and `c` are also incomparable.
    ///   (Transitive incomparability)
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements for which
    /// `areInIncreasingOrder` does not establish an order.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument;
    ///   otherwise, `false`.
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element]
}

/// Default implementation for bidirectional collections.
extension UnsafeBufferPointer {
}

/// Default implementations of core requirements
extension UnsafeBufferPointer {

    /// A Boolean value indicating whether the collection is empty.
    ///
    /// When you need to check whether your collection is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero. For collections that don't conform to
    /// `RandomAccessCollection`, accessing the `count` property iterates
    /// through the elements of the collection.
    ///
    ///     let horseName = "Silver"
    ///     if horseName.isEmpty {
    ///         print("My horse has no name.")
    ///     } else {
    ///         print("Hi ho, \(horseName)!")
    ///     }
    ///     // Prints "Hi ho, Silver!")
    ///
    /// - Complexity: O(1)
    @inlinable public var isEmpty: Bool { get }

    /// The first element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let firstNumber = numbers.first {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "10"
    @inlinable public var first: Element? { get }

    /// A value less than or equal to the number of elements in the collection.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var underestimatedCount: Int { get }

    /// The number of elements in the collection.
    ///
    /// To check whether a collection is empty, use its `isEmpty` property
    /// instead of comparing `count` to zero. Unless the collection guarantees
    /// random-access performance, calculating `count` can be an O(*n*)
    /// operation.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public var count: Int { get }
}

/// Supply the default "slicing" `subscript` for `Collection` models
/// that accept the default associated `SubSequence`, `Slice<Self>`.
extension UnsafeBufferPointer {

    /// Accesses a contiguous subrange of the collection's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original collection. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice of an array of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original array.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     let streetsSlice = streets[2 ..< streets.endIndex]
    ///     print(streetsSlice)
    ///     // Prints "["Channing", "Douglas", "Evarts"]"
    ///
    ///     let index = streetsSlice.firstIndex(of: "Evarts")    // 4
    ///     print(streets[index!])
    ///     // Prints "Evarts"
    ///
    /// - Parameter bounds: A range of the collection's indices. The bounds of
    ///   the range must be valid indices of the collection.
    ///
    /// - Complexity: O(1)
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeBufferPointer<Element>> { get }
}

/// Default implementation for forward collections.
extension UnsafeBufferPointer {

    /// Offsets the given index by the specified distance.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int)

    /// Offsets the given index by the specified distance, or so that it equals
    /// the given limiting index.
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, a limit that is less than `i` has no effect.
    ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
    ///     effect.
    /// - Returns: `true` if `i` has been offset by exactly `distance` steps
    ///   without going beyond `limit`; otherwise, `false`. When the return
    ///   value is `false`, the value of `i` is equal to `limit`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func formIndex(_ i: inout Int, offsetBy distance: Int, limitedBy limit: Int) -> Bool

    /// Returns a random element of the collection, using the given generator as
    /// a source for randomness.
    ///
    /// Call `randomElement(using:)` to select a random element from an array or
    /// another collection when you are using a custom random number generator.
    /// This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement(using: &myGenerator)!
    ///     // randomName == "Amani"
    ///
    /// - Parameter generator: The random number generator to use when choosing a
    ///   random element.
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    /// - Note: The algorithm used to select a random element may change in a
    ///   future version of Swift. If you're passing a generator that results in
    ///   the same sequence of elements each time you run your program, that
    ///   sequence may change when your program is compiled using a different
    ///   version of Swift.
    @inlinable public func randomElement<T>(using generator: inout T) -> Element? where T : RandomNumberGenerator

    /// Returns a random element of the collection.
    ///
    /// Call `randomElement()` to select a random element from an array or
    /// another collection. This example picks a name at random from an array:
    ///
    ///     let names = ["Zoey", "Chloe", "Amani", "Amaia"]
    ///     let randomName = names.randomElement()!
    ///     // randomName == "Amani"
    ///
    /// This method is equivalent to calling `randomElement(using:)`, passing in
    /// the system's default random generator.
    ///
    /// - Returns: A random element from the collection. If the collection is
    ///   empty, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*n*), where *n* is the length
    ///   of the collection.
    @inlinable public func randomElement() -> Element?
}

extension UnsafeBufferPointer : CustomDebugStringConvertible {

    /// A textual representation of the buffer, suitable for debugging.
    public var debugDescription: String { get }
}

extension UnsafeBufferPointer : Sequence {

    /// Returns an iterator over the elements of this buffer.
    ///
    /// - Returns: An iterator over the elements of this buffer.
    @inlinable public func makeIterator() -> UnsafeBufferPointer<Element>.Iterator
}

extension UnsafeBufferPointer : Collection, RandomAccessCollection {

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Range<Int>

    /// The index of the first element in a nonempty buffer.
    ///
    /// The `startIndex` property of an `UnsafeBufferPointer` instance
    /// is always zero.
    @inlinable public var startIndex: Int { get }

    /// The "past the end" position---that is, the position one greater than the
    /// last valid subscript argument.
    ///
    /// The `endIndex` property of an `UnsafeBufferPointer` instance is
    /// always identical to `count`.
    @inlinable public var endIndex: Int { get }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    @inlinable public func index(after i: Int) -> Int

    /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    @inlinable public func formIndex(after i: inout Int)

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    @inlinable public func index(before i: Int) -> Int

    /// Replaces the given index with its predecessor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    @inlinable public func formIndex(before i: inout Int)

    /// Returns an index that is the specified distance from the given index.
    ///
    /// The following example obtains an index advanced four positions from a
    /// string's starting index and then prints the character at that position.
    ///
    ///     let s = "Swift"
    ///     let i = s.index(s.startIndex, offsetBy: 4)
    ///     print(s[i])
    ///     // Prints "t"
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    /// - Returns: An index offset by `distance` from the index `i`. If
    ///   `distance` is positive, this is the same value as the result of
    ///   `distance` calls to `index(after:)`. If `distance` is negative, this
    ///   is the same value as the result of `abs(distance)` calls to
    ///   `index(before:)`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func index(_ i: Int, offsetBy n: Int) -> Int

    /// Returns an index that is the specified distance from the given index,
    /// unless that distance is beyond a given limiting index.
    ///
    /// The following example obtains an index advanced four positions from a
    /// string's starting index and then prints the character at that position.
    /// The operation doesn't require going beyond the limiting `s.endIndex`
    /// value, so it succeeds.
    ///
    ///     let s = "Swift"
    ///     if let i = s.index(s.startIndex, offsetBy: 4, limitedBy: s.endIndex) {
    ///         print(s[i])
    ///     }
    ///     // Prints "t"
    ///
    /// The next example attempts to retrieve an index six positions from
    /// `s.startIndex` but fails, because that distance is beyond the index
    /// passed as `limit`.
    ///
    ///     let j = s.index(s.startIndex, offsetBy: 6, limitedBy: s.endIndex)
    ///     print(j)
    ///     // Prints "nil"
    ///
    /// The value passed as `distance` must not offset `i` beyond the bounds of
    /// the collection, unless the index passed as `limit` prevents offsetting
    /// beyond those bounds.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`. `distance` must not be negative
    ///     unless the collection conforms to the `BidirectionalCollection`
    ///     protocol.
    ///   - limit: A valid index of the collection to use as a limit. If
    ///     `distance > 0`, a limit that is less than `i` has no effect.
    ///     Likewise, if `distance < 0`, a limit that is greater than `i` has no
    ///     effect.
    /// - Returns: An index offset by `distance` from the index `i`, unless that
    ///   index would be beyond `limit` in the direction of movement. In that
    ///   case, the method returns `nil`.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the absolute
    ///   value of `distance`.
    @inlinable public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int?

    /// Returns the distance between two indices.
    ///
    /// Unless the collection conforms to the `BidirectionalCollection` protocol,
    /// `start` must be less than or equal to `end`.
    ///
    /// - Parameters:
    ///   - start: A valid index of the collection.
    ///   - end: Another valid index of the collection. If `end` is equal to
    ///     `start`, the result is zero.
    /// - Returns: The distance between `start` and `end`. The result can be
    ///   negative only if the collection conforms to the
    ///   `BidirectionalCollection` protocol.
    ///
    /// - Complexity: O(1) if the collection conforms to
    ///   `RandomAccessCollection`; otherwise, O(*k*), where *k* is the
    ///   resulting distance.
    @inlinable public func distance(from start: Int, to end: Int) -> Int

    /// The indices that are valid for subscripting the collection, in ascending
    /// order.
    ///
    /// A collection's `indices` property can hold a strong reference to the
    /// collection itself, causing the collection to be nonuniquely referenced.
    /// If you mutate the collection while iterating over its indices, a strong
    /// reference can result in an unexpected copy of the collection. To avoid
    /// the unexpected copy, use the `index(after:)` method starting with
    /// `startIndex` to produce indices instead.
    ///
    ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
    ///     var i = c.startIndex
    ///     while i != c.endIndex {
    ///         c[i] /= 5
    ///         i = c.index(after: i)
    ///     }
    ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
    @inlinable public var indices: UnsafeBufferPointer<Element>.Indices { get }

    /// Accesses the element at the specified position.
    ///
    /// The following example uses the buffer pointer's subscript to access every
    /// other element of the buffer:
    ///
    ///     let numbers = [1, 2, 3, 4, 5]
    ///     let sum = numbers.withUnsafeBufferPointer { buffer -> Int in
    ///         var result = 0
    ///         for i in stride(from: buffer.startIndex, to: buffer.endIndex, by: 2) {
    ///             result += buffer[i]
    ///         }
    ///         return result
    ///     }
    ///     // 'sum' == 9
    ///
    /// - Note: Bounds checks for `i` are performed only in debug mode.
    ///
    /// - Parameter i: The position of the element to access. `i` must be in the
    ///   range `0..<count`.
    @inlinable public subscript(i: Int) -> Element { get }

    /// Accesses a contiguous subrange of the buffer's elements.
    ///
    /// The accessed slice uses the same indices for the same elements as the
    /// original buffer uses. Always use the slice's `startIndex` property
    /// instead of assuming that its indices start at a particular value.
    ///
    /// This example demonstrates getting a slice from a buffer of strings, finding
    /// the index of one of the strings in the slice, and then using that index
    /// in the original buffer.
    ///
    ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     streets.withUnsafeBufferPointer { buffer in
    ///         let streetSlice = buffer[2..<buffer.endIndex]
    ///         print(Array(streetSlice))
    ///         // Prints "["Channing", "Douglas", "Evarts"]"
    ///         let index = streetSlice.firstIndex(of: "Evarts")    // 4
    ///         print(buffer[index!])
    ///         // Prints "Evarts"
    ///     }
    ///
    /// - Note: Bounds checks for `bounds` are performed only in debug mode.
    ///
    /// - Parameter bounds: A range of the buffer's indices. The bounds of
    ///   the range must be valid indices of the buffer.
    @inlinable public subscript(bounds: Range<Int>) -> Slice<UnsafeBufferPointer<Element>> { get }

    /// A sequence that represents a contiguous subrange of the collection's
    /// elements.
    ///
    /// This associated type appears as a requirement in the `Sequence`
    /// protocol, but it is restated here with stricter constraints. In a
    /// collection, the subsequence should also conform to `Collection`.
    public typealias SubSequence = Slice<UnsafeBufferPointer<Element>>
}

extension UnsafeBufferPointer where Element : Equatable {

    /// Returns the longest possible subsequences of the collection, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the collection are not returned as part
    /// of any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " "))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the collection, or
    ///     one less than the number of subsequences to return. If
    ///     `maxSplits + 1` subsequences are returned, the last one is a suffix
    ///     of the original collection containing the remaining elements.
    ///     `maxSplits` must be greater than or equal to zero. The default value
    ///     is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the collection and for each instance of `separator` at
    ///     the start or end of the collection. If `true`, only nonempty
    ///     subsequences are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this collection's
    ///   elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Slice<UnsafeBufferPointer<Element>>]

    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `firstIndex(of:)` to find the position of a particular element
    /// in a collection, you can use it to access the element by subscripting.
    /// This example shows how you can modify one of the names in an array of
    /// students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Maxime"]
    ///     if let i = students.firstIndex(of: "Maxime") {
    ///         students[i] = "Max"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func firstIndex(of element: Element) -> Int?

    /// Returns the last index where the specified value appears in the
    /// collection.
    ///
    /// After using `lastIndex(of:)` to find the position of the last instance of
    /// a particular element in a collection, you can use it to access the
    /// element by subscripting. This example shows how you can modify one of
    /// the names in an array of students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Ben", "Maxime"]
    ///     if let i = students.lastIndex(of: "Ben") {
    ///         students[i] = "Benjamin"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Benjamin", "Max"]"
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The last index where `element` is found. If `element` is not
    ///   found in the collection, this method returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @inlinable public func lastIndex(of element: Element) -> Int?

    /// Returns the difference needed to produce this collection's ordered
    /// elements from the given collection.
    ///
    /// This function does not infer element moves. If you need to infer moves,
    /// call the `inferringMoves()` method on the resulting difference.
    ///
    /// - Parameters:
    ///   - other: The base state.
    ///
    /// - Returns: The difference needed to produce this collection's ordered
    ///   elements from the given collection.
    ///
    /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
    ///   count of this collection and *m* is `other.count`. You can expect
    ///   faster execution when the collections share many common elements, or
    ///   if `Element` conforms to `Hashable`.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func difference<C>(from other: C) -> CollectionDifference<Element> where C : BidirectionalCollection, Element == C.Element

    /// Returns the first index where the specified value appears in the
    /// collection.
    @available(swift, deprecated: 5.0, renamed: "firstIndex(of:)")
    @inlinable public func index(of element: Element) -> Int?

    /// Returns the longest possible subsequences of the sequence, in order,
    /// around elements equal to the given element.
    ///
    /// The resulting array consists of at most `maxSplits + 1` subsequences.
    /// Elements that are used to split the sequence are not returned as part of
    /// any subsequence.
    ///
    /// The following examples show the effects of the `maxSplits` and
    /// `omittingEmptySubsequences` parameters when splitting a string at each
    /// space character (" "). The first use of `split` returns each word that
    /// was originally separated by one or more spaces.
    ///
    ///     let line = "BLANCHE:   I don't want realism. I want magic!"
    ///     print(line.split(separator: " ")
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// The second example passes `1` for the `maxSplits` parameter, so the
    /// original string is split just once, into two new strings.
    ///
    ///     print(line.split(separator: " ", maxSplits: 1)
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
    ///
    /// The final example passes `false` for the `omittingEmptySubsequences`
    /// parameter, so the returned array contains empty strings where spaces
    /// were repeated.
    ///
    ///     print(line.split(separator: " ", omittingEmptySubsequences: false)
    ///               .map(String.init))
    ///     // Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
    ///
    /// - Parameters:
    ///   - separator: The element that should be split upon.
    ///   - maxSplits: The maximum number of times to split the sequence, or one
    ///     less than the number of subsequences to return. If `maxSplits + 1`
    ///     subsequences are returned, the last one is a suffix of the original
    ///     sequence containing the remaining elements. `maxSplits` must be
    ///     greater than or equal to zero. The default value is `Int.max`.
    ///   - omittingEmptySubsequences: If `false`, an empty subsequence is
    ///     returned in the result for each consecutive pair of `separator`
    ///     elements in the sequence and for each instance of `separator` at the
    ///     start or end of the sequence. If `true`, only nonempty subsequences
    ///     are returned. The default value is `true`.
    /// - Returns: An array of subsequences, split from this sequence's elements.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func split(separator: Element, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [ArraySlice<Element>]

    /// Returns a Boolean value indicating whether the initial elements of the
    /// sequence are the same as the elements in another sequence.
    ///
    /// This example tests whether one countable range begins with the elements
    /// of another countable range.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(b.starts(with: a))
    ///     // Prints "true"
    ///
    /// Passing a sequence with no elements or an empty collection as
    /// `possiblePrefix` always results in `true`.
    ///
    ///     print(b.starts(with: []))
    ///     // Prints "true"
    ///
    /// - Parameter possiblePrefix: A sequence to compare to this sequence.
    /// - Returns: `true` if the initial elements of the sequence are the same as
    ///   the elements of `possiblePrefix`; otherwise, `false`. If
    ///   `possiblePrefix` has no elements, the return value is `true`.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `possiblePrefix`.
    @inlinable public func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element

    /// Returns a Boolean value indicating whether this sequence and another
    /// sequence contain the same elements in the same order.
    ///
    /// At least one of the sequences must be finite.
    ///
    /// This example tests whether one countable range shares the same elements
    /// as another countable range and an array.
    ///
    ///     let a = 1...3
    ///     let b = 1...10
    ///
    ///     print(a.elementsEqual(b))
    ///     // Prints "false"
    ///     print(a.elementsEqual([1, 2, 3]))
    ///     // Prints "true"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence and `other` contain the same elements
    ///   in the same order.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element

    /// Returns a Boolean value indicating whether the sequence contains the
    /// given element.
    ///
    /// This example checks to see whether a favorite actor is in an array
    /// storing a movie's cast.
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     print(cast.contains("Marlon"))
    ///     // Prints "true"
    ///     print(cast.contains("James"))
    ///     // Prints "false"
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: `true` if the element was found in the sequence; otherwise,
    ///   `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable public func contains(_ element: Element) -> Bool
}

extension UnsafeBufferPointer where Element : Comparable {

    /// Returns the minimum element in the sequence.
    ///
    /// This example finds the smallest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let lowestHeight = heights.min()
    ///     print(lowestHeight)
    ///     // Prints "Optional(58.5)"
    ///
    /// - Returns: The sequence's minimum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func min() -> Element?

    /// Returns the maximum element in the sequence.
    ///
    /// This example finds the largest value in an array of height measurements.
    ///
    ///     let heights = [67.5, 65.7, 64.3, 61.1, 58.5, 60.3, 64.9]
    ///     let greatestHeight = heights.max()
    ///     print(greatestHeight)
    ///     // Prints "Optional(67.5)"
    ///
    /// - Returns: The sequence's maximum element. If the sequence has no
    ///   elements, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @warn_unqualified_access
    @inlinable public func max() -> Element?

    /// Returns a Boolean value indicating whether the sequence precedes another
    /// sequence in a lexicographical (dictionary) ordering, using the
    /// less-than operator (`<`) to compare elements.
    ///
    /// This example uses the `lexicographicallyPrecedes` method to test which
    /// array of integers comes first in a lexicographical ordering.
    ///
    ///     let a = [1, 2, 2, 2]
    ///     let b = [1, 2, 3, 4]
    ///
    ///     print(a.lexicographicallyPrecedes(b))
    ///     // Prints "true"
    ///     print(b.lexicographicallyPrecedes(b))
    ///     // Prints "false"
    ///
    /// - Parameter other: A sequence to compare to this sequence.
    /// - Returns: `true` if this sequence precedes `other` in a dictionary
    ///   ordering; otherwise, `false`.
    ///
    /// - Note: This method implements the mathematical notion of lexicographical
    ///   ordering, which has no connection to Unicode.  If you are sorting
    ///   strings to present to the end user, use `String` APIs that
    ///   perform localized comparison.
    ///
    /// - Complexity: O(*m*), where *m* is the lesser of the length of the
    ///   sequence and the length of `other`.
    @inlinable public func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element

    /// Returns the elements of the sequence, sorted.
    ///
    /// You can sort any sequence of elements that conform to the `Comparable`
    /// protocol by calling this method. Elements are sorted in ascending order.
    ///
    /// Here's an example of sorting a list of students' names. Strings in Swift
    /// conform to the `Comparable` protocol, so the names are sorted in
    /// ascending order according to the less-than operator (`<`).
    ///
    ///     let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
    ///     let sortedStudents = students.sorted()
    ///     print(sortedStudents)
    ///     // Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
    ///
    /// To sort the elements of your sequence in descending order, pass the
    /// greater-than operator (`>`) to the `sorted(by:)` method.
    ///
    ///     let descendingStudents = students.sorted(by: >)
    ///     print(descendingStudents)
    ///     // Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"
    ///
    /// The sorting algorithm is not guaranteed to be stable. A stable sort
    /// preserves the relative order of elements that compare equal.
    ///
    /// - Returns: A sorted array of the sequence's elements.
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    @inlinable public func sorted() -> [Element]
}

extension UnsafeBufferPointer where Element : StringProtocol {

    /// Returns a new string by concatenating the elements of the sequence,
    /// adding the given separator between each element.
    ///
    /// The following example shows how an array of strings can be joined to a
    /// single, comma-separated string:
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let list = cast.joined(separator: ", ")
    ///     print(list)
    ///     // Prints "Vivien, Marlon, Kim, Karl"
    ///
    /// - Parameter separator: A string to insert between each of the elements
    ///   in this sequence. The default separator is an empty string.
    /// - Returns: A single, concatenated string.
    public func joined(separator: String = "") -> String
}

extension UnsafeBufferPointer where Element == String {

    /// Returns a new string by concatenating the elements of the sequence,
    /// adding the given separator between each element.
    ///
    /// The following example shows how an array of strings can be joined to a
    /// single, comma-separated string:
    ///
    ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
    ///     let list = cast.joined(separator: ", ")
    ///     print(list)
    ///     // Prints "Vivien, Marlon, Kim, Karl"
    ///
    /// - Parameter separator: A string to insert between each of the elements
    ///   in this sequence. The default separator is an empty string.
    /// - Returns: A single, concatenated string.
    public func joined(separator: String = "") -> String
}

extension UnsafeBufferPointer where Element : Sequence {

    /// Returns the elements of this sequence of sequences, concatenated.
    ///
    /// In this example, an array of three ranges is flattened so that the
    /// elements of each range can be iterated in turn.
    ///
    ///     let ranges = [0..<3, 8..<10, 15..<17]
    ///
    ///     // A for-in loop over 'ranges' accesses each range:
    ///     for range in ranges {
    ///       print(range)
    ///     }
    ///     // Prints "0..<3"
    ///     // Prints "8..<10"
    ///     // Prints "15..<17"
    ///
    ///     // Use 'joined()' to access each element of each range:
    ///     for index in ranges.joined() {
    ///         print(index, terminator: " ")
    ///     }
    ///     // Prints: "0 1 2 8 9 15 16"
    ///
    /// - Returns: A flattened view of the elements of this
    ///   sequence of sequences.
    @inlinable public func joined() -> FlattenSequence<UnsafeBufferPointer<Element>>

    /// Returns the concatenated elements of this sequence of sequences,
    /// inserting the given separator between each element.
    ///
    /// This example shows how an array of `[Int]` instances can be joined, using
    /// another `[Int]` instance as the separator:
    ///
    ///     let nestedNumbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    ///     let joined = nestedNumbers.joined(separator: [-1, -2])
    ///     print(Array(joined))
    ///     // Prints "[1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9]"
    ///
    /// - Parameter separator: A sequence to insert between each of this
    ///   sequence's elements.
    /// - Returns: The joined sequence of elements.
    @inlinable public func joined<Separator>(separator: Separator) -> JoinedSequence<UnsafeBufferPointer<Element>> where Separator : Sequence, Separator.Element == Element.Element
}

extension UnsafeBufferPointer.Iterator : IteratorProtocol {

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Once `nil` has been returned, all subsequent calls return `nil`.
    @inlinable public mutating func next() -> Element?
}

