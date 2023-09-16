//
//  Array+Ext.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//


import Foundation

public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (lhs?, rhs?):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}

extension Array {

//    ///EZSE: Get a sub array from range of index
//    public func get(at range: ClosedRange<Int>) -> Array {
//        let halfOpenClampedRange = Range(range).clamped(to: Range(indices))
//        return Array(self[halfOpenClampedRange])
//    }

    /// EZSE: Checks if array contains at least 1 item which type is same with given element's type
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType}
    }

    /// EZSE: Decompose an array to a tuple with first element and the rest
    public func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        (count > 0) ? (self[0], self[1..<count]) : nil
    }

    /// EZSE: Iterates on each element of the array with its index. (Index, Element)
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }

    /// EZSE: Gets the object at the specified index, if it exists.
    public func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }

    /// EZSE: Prepends an object to the array.
    public mutating func insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// EZSE: Returns a random element from the array.
    public func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }

    /// EZSE: Reverse the given index. i.g.: reverseIndex(2) would be 2 to the last
    public func reverseIndex(_ index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }
        return Swift.max(count - 1 - index, 0)
    }

//    /// EZSE: Shuffles the array in-place using the Fisher-Yates-Durstenfeld algorithm.
//    public mutating func shuffle() {
//        guard count > 1 else { return }
//        var j: Int
//        for i in 0..<(count-2) {
//            j = Int(arc4random_uniform(UInt32(count - i)))
//            if i != i+j { self.swapAt(i, i+j) }
//        }
//    }

//    /// EZSE: Shuffles copied array using the Fisher-Yates-Durstenfeld algorithm, returns shuffled array.
//    public func shuffled() -> Array {
//        var result = self
//        result.shuffle()
//        return result
//    }

    /// EZSE: Returns an array with the given number as the max number of elements.
    public func takeMax(_ n: Int) -> Array {
        Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }

    /// EZSE: Checks if test returns true for all the elements in self
    public func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        !contains { !body($0) }
    }

    /// EZSE: Checks if all elements in the array are true or false
    public func testAll(is condition: Bool) -> Bool {
        testAll { ($0 as? Bool) ?? !condition == condition }
    }
    
    public func union(_ arrays: Array...) -> Array {
        var result = self
        arrays.forEach { array in
            array.forEach { item in
                result.append(item)
            }
        }
        return result
    }
}

extension Array where Element: Equatable {

//    /// EZSE: Checks if the main array contains the parameter array
//    public func contains(_ array: [Element]) -> Bool {
//        return array.testAll { self.index(of: $0) ?? -1 >= 0 }
//    }

//    /// EZSE: Checks if self contains a list of items.
//    public func contains(_ elements: Element...) -> Bool {
//        return elements.testAll { self.index(of: $0) ?? -1 >= 0 }
//    }

    /// EZSE: Returns the indexes of the object
    public func indexes(of element: Element) -> [Int] {
        enumerated().compactMap { ($0.element == element) ? $0.offset : nil }
    }

//    /// EZSE: Returns the last index of the object
//    public func lastIndex(of element: Element) -> Int? {
//        return indexes(of: element).last
//    }

    /// EZSE: Removes the first given object
    public mutating func removeFirst(_ element: Element) {
        guard let index = firstIndex(of: element) else { return }
        self.remove(at: index)
    }

    /// EZSE: Removes all occurrences of the given object(s), at least one entry is needed.
    public mutating func removeAll(_ firstElement: Element?, _ elements: Element...) {
        var removeAllArr = [Element]()
        
        if let firstElementVal = firstElement {
            removeAllArr.append(firstElementVal)
        }
        
        elements.forEach({element in removeAllArr.append(element)})
        
        removeAll(removeAllArr)
    }

//    /// EZSE: Removes all occurrences of the given object(s)
//    public mutating func removeAll(_ elements: [Element]) {
//        // COW ensures no extra copy in case of no removed elements
//        self = filter { !elements.contains($0) }
//    }

    /// EZSE: Difference of self and the input arrays.
    public func difference(_ values: [Element]...) -> [Element] {
        var result = [Element]()
        elements: for element in self {
            for value in values {
                //  if a value is in both self and one of the values arrays
                //  jump to the next iteration of the outer loop
                if value.contains(element) {
                    continue elements
                }
            }
            //  element it's only in self
            result.append(element)
        }
        return result
    }

    /// EZSE: Intersection of self and the input arrays.
    public func intersection(_ values: [Element]...) -> Array {
        var result = self
        var intersection = Array()

        for (i, value) in values.enumerated() {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if i > 0 {
                result = intersection
                intersection = Array()
            }

            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.forEach { (item: Element) -> Void in
                if result.contains(item) {
                    intersection.append(item)
                }
            }
        }
        return intersection
    }

    /// EZSE: Union of self and the input arrays.
    public func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }
}

extension Array where Element: Hashable {

    /// EZSE: Removes all occurrences of the given object(s)
    public mutating func removeAll(_ elements: [Element]) {
        let elementsSet = Set(elements)
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elementsSet.contains($0) }
    }
}

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Deprecated 1.8

extension Array {

    /// EZSE: Checks if array contains at least 1 instance of the given object type
    @available(*, deprecated, renamed: "containsType(of:)")
    public func containsInstanceOf<T>(_ element: T) -> Bool {
        containsType(of: element)
    }

    /// EZSE: Gets the object at the specified index, if it exists.
    @available(*, deprecated, renamed: "get(at:)")
    public func get(_ index: Int) -> Element? {
        get(at: index)
    }

    /// EZSE: Checks if all elements in the array are true of false
    @available(*, deprecated, renamed: "testAll(is:)")
    public func testIfAllIs(_ condition: Bool) -> Bool {
        testAll(is: condition)
    }

}

extension Array where Element: Equatable {

    /// EZSE: Removes the first given object
    @available(*, deprecated, renamed: "removeFirst(_:)")
    public mutating func removeFirstObject(_ object: Element) {
        removeFirst(object)
    }
}

// MARK: - Deprecated 1.7

extension Array {

    /// EZSE: Prepends an object to the array.
    @available(*, deprecated, renamed: "insertFirst(_:)")
    public mutating func insertAsFirst(_ newElement: Element) {
        insertFirst(newElement)
    }

}

extension Array where Element: Equatable {

//    /// EZSE: Checks if the main array contains the parameter array
//    @available(*, deprecated: 1.7, renamed: "contains(_:)")
//    public func containsArray(_ array: [Element]) -> Bool {
//        return contains(array)
//    }

    /// EZSE: Returns the indexes of the object
    @available(*, deprecated, renamed: "indexes(of:)")
    public func indexesOf(_ object: Element) -> [Int] {
        indexes(of: object)
    }

//    /// EZSE: Returns the last index of the object
//    @available(*, deprecated: 1.7, renamed: "lastIndex(_:)")
//    public func lastIndexOf(_ object: Element) -> Int? {
//        return lastIndex(of: object)
//    }

    /// EZSE: Removes the first given object
    @available(*, deprecated, renamed: "removeFirstObject(_:)")
   
    mutating func removeObject(_ object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}

// MARK: - Deprecated 1.6

extension Array {

    /// EZSE: Creates an array with values generated by running each value of self
    /// through the mapFunction and discarding nil return values.
    @available(*, deprecated, renamed: "flatMap(_:)")
    public func mapFilter<V>(mapFunction map: (Element) -> (V)?) -> [V] {
        flatMap { map($0) }
    }

    /// EZSE: Iterates on each element of the array with its index.  (Index, Element)
    @available(*, deprecated, renamed: "forEachEnumerated(_:)")
    public func each(_ call: @escaping (Int, Element) -> Void) {
        forEachEnumerated(call)
    }

}

// MARK: - Methods (Integer)
public extension Array where Element: Numeric {
    
    /// SwifterSwift: Sum of all elements in array.
    ///
    ///        [1, 2, 3, 4, 5].sum() -> 15
    ///
    /// - Returns: sum of the array's elements.
    func sum() -> Element {
        var total: Element = 0
        for i in 0..<count {
            total += self[i]
        }
        return total
    }
    
}

// MARK: - Methods (FloatingPoint)
public extension Array where Element: FloatingPoint {
    
    /// SwifterSwift: Average of all elements in array.
    ///
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].average() = 3.18
    ///
    /// - Returns: average of the array's elements.
    func average() -> Element {
        guard !isEmpty else { return 0 }
        var total: Element = 0
        for i in 0..<count {
            total += self[i]
        }
        return total / Element(count)
    }
    
}

// MARK: - Methods
public extension Array {
    
    /// SwifterSwift: Element at the given index if it exists.
    ///
    ///        [1, 2, 3, 4, 5].item(at: 2) -> 3
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].item(at: 3) -> 3.4
    ///        ["h", "e", "l", "l", "o"].item(at: 10) -> nil
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    func item(at index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
    
    /// SwifterSwift: Remove last element from array and return it.
    ///
    ///        [1, 2, 3, 4, 5].pop() // returns 5 and remove it from the array.
    ///        [].pop() // returns nil since the array is empty.
    ///
    /// - Returns: last element in array (if applicable).
    @discardableResult mutating func pop() -> Element? {
        popLast()
    }
    
    /// SwifterSwift: Insert an element at the beginning of array.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    /// SwifterSwift: Insert an element to the end of array.
    ///
    ///        [1, 2, 3, 4].push(5) -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l"].push("o") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    mutating func push(_ newElement: Element) {
        append(newElement)
    }
    
    /// SwifterSwift: Safely Swap values at index positions.
    ///
    ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func safeSwap(from index: Int, to otherIndex: Int) {
        guard index != otherIndex,
            startIndex..<endIndex ~= index,
            startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
    
    /// SwifterSwift: Swap values at index positions.
    ///
    ///        [1, 2, 3, 4, 5].swap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].swap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func swap(from index: Int, to otherIndex: Int) {
        swapAt(index, otherIndex)
    }
    
    /// SwifterSwift: Get first index where condition is met.
    ///
    ///        [1, 7, 1, 2, 4, 1, 6].firstIndex { $0 % 2 == 0 } -> 3
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: first index where the specified condition evaluates to true. (optional)
    func firstIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
        for (index, value) in lazy.enumerated() {
            if try condition(value) { return index }
        }
        return nil
    }
    
    /// SwifterSwift: Get last index where condition is met.
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].lastIndex { $0 % 2 == 0 } -> 6
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: last index where the specified condition evaluates to true. (optional)
    func lastIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
        for (index, value) in lazy.enumerated().reversed() {
            if try condition(value) { return index }
        }
        return nil
    }
    
    /// SwifterSwift: Get all indices where condition is met.
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].indices(where: { $0 == 1 }) -> [0, 2, 5]
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: all indices where the specified condition evaluates to true. (optional)
    func indices(where condition: (Element) throws -> Bool) rethrows -> [Int]? {
        var indicies: [Int] = []
        for (index, value) in lazy.enumerated() {
            if try condition(value) { indicies.append(index) }
        }
        return indicies.isEmpty ? nil : indicies
    }
    
    /// SwifterSwift: Check if all elements in array match a conditon.
    ///
    ///        [2, 2, 4].all(matching: {$0 % 2 == 0}) -> true
    ///        [1,2, 2, 4].all(matching: {$0 % 2 == 0}) -> false
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when all elements in the array match the specified condition.
    func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try !condition($0) }
    }
    
    /// SwifterSwift: Check if no elements in array match a conditon.
    ///
    ///        [2, 2, 4].none(matching: {$0 % 2 == 0}) -> false
    ///        [1, 3, 5, 7].none(matching: {$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when no elements in the array match the specified condition.
    func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try condition($0) }
    }
    
    /// SwifterSwift: Get last element that satisfies a conditon.
    ///
    ///        [2, 2, 4, 7].last(where: {$0 % 2 == 0}) -> 4
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: the last element in the array matching the specified condition. (optional)
    func last(where condition: (Element) throws -> Bool) rethrows -> Element? {
        for element in reversed() {
            if try condition(element) { return element }
        }
        return nil
    }
    
    /// SwifterSwift: Filter elements based on a rejection condition.
    ///
    ///        [2, 2, 4, 7].reject(where: {$0 % 2 == 0}) -> [7]
    ///
    /// - Parameter condition: to evaluate the exclusion of an element from the array.
    /// - Returns: the array with rejected values filtered from it.
    func reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !condition($0) }
    }
    
    /// SwifterSwift: Get element count based on condition.
    ///
    ///        [2, 2, 4, 7].count(where: {$0 % 2 == 0}) -> 3
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: number of times the condition evaluated to true.
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try condition(element) { count += 1 }
        }
        return count
    }
    
    /// SwifterSwift: Iterate over a collection in reverse order. (right to left)
    ///
    ///        [0, 2, 4, 7].forEachReversed({ print($0)}) -> //Order of print: 7,4,2,0
    ///
    /// - Parameter body: a closure that takes an element of the array as a parameter.
    func forEachReversed(_ body: (Element) throws -> Void) rethrows {
        try reversed().forEach { try body($0) }
    }
    
    /// SwifterSwift: Calls given closure with each element where condition is true.
    ///
    ///        [0, 2, 4, 7].forEach(where: {$0 % 2 == 0}, body: { print($0)}) -> //print: 0, 2, 4
    ///
    /// - Parameters:
    ///   - condition: condition to evaluate each element against.
    ///   - body: a closure that takes an element of the array as a parameter.
    func forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        for element in self where try condition(element) {
            try body(element)
        }
    }
    
    /// SwifterSwift: Reduces an array while returning each interim combination.
    ///
    ///     [1, 2, 3].accumulate(initial: 0, next: +) -> [1, 3, 6]
    ///
    /// - Parameters:
    ///   - initial: initial value.
    ///   - next: closure that combines the accumulating value and next element of the array.
    /// - Returns: an array of the final accumulated value and each interim combination.
    func accumulate<U>(initial: U, next: (U, Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }
    
    /// SwifterSwift: Filtered and map in a single operation.
    ///
    ///     [1,2,3,4,5].filtered({ $0 % 2 == 0 }, map: { $0.string }) -> ["2", "4"]
    ///
    /// - Parameters:
    ///   - isIncluded: condition of inclusion to evaluate each element against.
    ///   - transform: transform element function to evaluate every element.
    /// - Returns: Return an filtered and mapped array.
    func filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows ->  [T] {
        try compactMap({
            if try isIncluded($0) {
                return try transform($0)
            }
            return nil
        })
    }
    
    /// SwifterSwift: Keep elements of Array while condition is true.
    ///
    ///        [0, 2, 4, 7].keep( where: {$0 % 2 == 0}) -> [0, 2, 4]
    ///
    /// - Parameter condition: condition to evaluate each element against.
    mutating func keep(while condition: (Element) throws -> Bool) rethrows {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                self = Array(self[startIndex..<index])
                break
            }
        }
    }
    
    /// SwifterSwift: Take element of Array while condition is true.
    ///
    ///        [0, 2, 4, 7, 6, 8].take( where: {$0 % 2 == 0}) -> [0, 2, 4]
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: All elements up until condition evaluates to false.
    func take(while condition: (Element) throws -> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[startIndex..<index])
            }
        }
        return self
    }
    
    /// SwifterSwift: Skip elements of Array while condition is true.
    ///
    ///        [0, 2, 4, 7, 6, 8].skip( where: {$0 % 2 == 0}) -> [6, 8]
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: All elements after the condition evaluates to false.
    func skip(while condition: (Element) throws-> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[index..<endIndex])
            }
        }
        return [Element]()
    }
    
    /// SwifterSwift: Calls given closure with an array of size of the parameter slice where condition is true.
    ///
    ///     [0, 2, 4, 7].forEach(slice: 2) { print($0) } -> //print: [0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].forEach(slice: 2) { print($0) } -> //print: [0, 2], [4, 7], [6]
    ///
    /// - Parameters:
    ///   - slice: size of array in each interation.
    ///   - body: a closure that takes an array of slice size as a parameter.
    func forEach(slice: Int, body: ([Element]) throws -> Void) rethrows {
        guard slice > 0, !isEmpty else { return }
        
        var value: Int = 0
        while value < count {
            try body(Array(self[Swift.max(value, startIndex)..<Swift.min(value + slice, endIndex)]))
            value += slice
        }
    }
    
    /// SwifterSwift: Returns an array of slices of length "size" from the array.  If array can't be split evenly, the final slice will be the remaining elements.
    ///
    ///     [0, 2, 4, 7].group(by: 2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].group(by: 2) -> [[0, 2], [4, 7], [6]]
    ///
    /// - Parameters:
    ///   - size: The size of the slices to be returned.
    func group(by size: Int) -> [[Element]]? {
        //Inspired by: https://lodash.com/docs/4.17.4#chunk
        guard size > 0, !isEmpty else { return nil }
        var value: Int = 0
        var slices: [[Element]] = []
        while value < count {
            slices.append(Array(self[Swift.max(value, startIndex)..<Swift.min(value + size, endIndex)]))
            value += size
        }
        return slices
    }
    
    /// SwifterSwift: Group the elements of the array in a dictionary.
    ///
    ///     [0, 2, 5, 4, 7].groupByKey { $0%2 ? "evens" : "odds" } -> [ "evens" : [0, 2, 4], "odds" : [5, 7] ]
    ///
    /// - Parameter getKey: Clousure to define the key for each element.
    /// - Returns: A dictionary with values grouped with keys.
    func groupByKey<K: Hashable>(keyForValue: (_ element: Element) throws -> K) rethrows -> [K: [Element]] {
        var group = [K: [Element]]()
        for value in self {
            let key = try keyForValue(value)
            group[key] = (group[key] ?? []) + [value]
        }
        return group
    }
    
    /// SwifterSwift: Separates an array into 2 arrays based on a predicate.
    ///
    ///     [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 } -> ( [0, 2, 4], [1, 3, 5] )
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: Two arrays, the first containing the elements for which the specified condition evaluates to true, the second containing the rest.
    func divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        //Inspired by: http://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-partition
        var matching = [Element]()
        var nonMatching = [Element]()
        for element in self {
            if try condition(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        return (matching, nonMatching)
    }
    
    /// SwifterSwift: Returns a new rotated array by the given places.
    ///
    ///     [1, 2, 3, 4].rotated(by: 1) -> [4,1,2,3]
    ///     [1, 2, 3, 4].rotated(by: 3) -> [2,3,4,1]
    ///     [1, 2, 3, 4].rotated(by: -1) -> [2,3,4,1]
    ///
    /// - Parameter places: Number of places that the array be rotated. If the value is positive the end becomes the start, if it negative it's that start becom the end.
    /// - Returns: The new rotated array
    func rotated(by places: Int) -> [Element] {
        //Inspired by: https://ruby-doc.org/core-2.2.0/Array.html#method-i-rotate
        guard places != 0 && places < count else {
            return self
        }
        var array: [Element] = self
        if places > 0 {
            let range = (array.count - places)..<array.endIndex
            let slice = array[range]
            array.removeSubrange(range)
            array.insert(contentsOf: slice, at: 0)
        } else {
            let range = array.startIndex..<(places * -1)
            let slice = array[range]
            array.removeSubrange(range)
            array.append(contentsOf: slice)
        }
        return array
    }
    
    /// SwifterSwift: Rotate the array by the given places.
    ///
    ///     [1, 2, 3, 4].rotate(by: 1) -> [4,1,2,3]
    ///     [1, 2, 3, 4].rotate(by: 3) -> [2,3,4,1]
    ///     [1, 2, 3, 4].rotated(by: -1) -> [2,3,4,1]
    ///
    /// - Parameter places: Number of places that the array should be rotated. If the value is positive the end becomes the start, if it negative it's that start becom the end.
    mutating func rotate(by places: Int) {
        self = rotated(by: places)
    }
    
    /// SwifterSwift: Shuffle array. (Using Fisher-Yates Algorithm)
    ///
    ///        [1, 2, 3, 4, 5].shuffle() // shuffles array
    ///
    mutating func shuffle() {
        // http://stackoverflow.com/questions/37843647/shuffle-array-swift-3
        guard count > 1 else { return }
        for index in startIndex..<endIndex - 1 {
            let randomIndex = Int(arc4random_uniform(UInt32(endIndex - index))) + index
            if index != randomIndex { swapAt(index, randomIndex) }
        }
    }
    
    /// SwifterSwift: Shuffled version of array. (Using Fisher-Yates Algorithm)
    ///
    ///        [1, 2, 3, 4, 5].shuffled // return a shuffled version from given array e.g. [2, 4, 1, 3, 5].
    ///
    /// - Returns: the array with its elements shuffled.
    func shuffled() -> [Element] {
        var array = self
        array.shuffle()
        return array
    }
    
    /// SwifterSwift: Return a sorted array based on an optional keypath.
    ///
    /// - Parameter path: Key path to sort. The key path type must be Comparable.
    /// - Parameter ascending: If order must be ascending.
    /// - Returns: Sorted array based on keyPath.
    func sorted<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        sorted(by: { (lhs, rhs) -> Bool in
            guard let lhsValue = lhs[keyPath: path], let rhsValue = rhs[keyPath: path] else { return false }
            if ascending {
                return lhsValue < rhsValue
            }
            return lhsValue > rhsValue
        })
    }
    
    /// SwifterSwift: Return a sorted array based on a keypath.
    ///
    /// - Parameter path: Key path to sort. The key path type must be Comparable.
    /// - Parameter ascending: If order must be ascending.
    /// - Returns: Sorted array based on keyPath.
    func sorted<T: Comparable>(by path: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        sorted(by: { (lhs, rhs) -> Bool in
            if ascending {
                return lhs[keyPath: path] < rhs[keyPath: path]
            }
            return lhs[keyPath: path] > rhs[keyPath: path]
        })
    }
    
    /// SwifterSwift: Sort the array based on an optional keypath.
    ///
    /// - Parameter path: Key path to sort. The key path type must be Comparable.
    /// - Parameter ascending: If order must be ascending.
    mutating func sort<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) {
        self = sorted(by: path, ascending: ascending)
    }
    
    /// SwifterSwift: Sort the array based on a keypath.
    ///
    /// - Parameter path: Key path to sort. The key path type must be Comparable.
    /// - Parameter ascending: If order must be ascending.
    mutating func sort<T: Comparable>(by path: KeyPath<Element, T>, ascending: Bool = true) {
        self = sorted(by: path, ascending: ascending)
    }
    
}

// MARK: - Methods (Equatable)
public extension Array where Element: Equatable {
    
    /// SwifterSwift: Check if array contains an array of elements.
    ///
    ///        [1, 2, 3, 4, 5].contains([1, 2]) -> true
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].contains([2, 6]) -> false
    ///        ["h", "e", "l", "l", "o"].contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else { return true }
        var found = true
        for element in elements {
            if !contains(element) {
                found = false
            }
        }
        return found
    }
    
    /// SwifterSwift: All indices of specified item.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].indices(of 2) -> [1, 2, 5]
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].indices(of 2.3) -> [1]
    ///        ["h", "e", "l", "l", "o"].indices(of "l") -> [2, 3]
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indices of the given item.
    func indices(of item: Element) -> [Int] {
        var indices: [Int] = []
        for index in startIndex..<endIndex where self[index] == item {
            indices.append(index)
        }
        return indices
    }
    
    /// SwifterSwift: Remove all instances of an item from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"].removeAll("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: item to remove.
    mutating func removeAll(_ item: Element) {
        self = filter { $0 != item }
    }
    
    /// SwifterSwift: Remove all instances contained in items parameter from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
    ///        ["h", "e", "l", "l", "o"].removeAll(["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter items: items to remove.
    mutating func removeAll(_ items: [Element]) {
        guard !items.isEmpty else { return }
        self = filter { !items.contains($0) }
    }
    
    /// SwifterSwift: Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    mutating func removeDuplicates() {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    /// SwifterSwift: Return array with all duplicate elements removed.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].duplicatesRemoved() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].duplicatesRemoved() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    func duplicatesRemoved() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the property
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    /// SwifterSwift: First index of a given item in an array.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].firstIndex(of: 2) -> 1
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].firstIndex(of: 6.5) -> nil
    ///        ["h", "e", "l", "l", "o"].firstIndex(of: "l") -> 2
    ///
    /// - Parameter item: item to check.
    /// - Returns: first index of item in array (if exists).
    func firstIndex(of item: Element) -> Int? {
        for (index, value) in lazy.enumerated() where value == item {
            return index
        }
        return nil
    }
    
    /// SwifterSwift: Last index of element in array.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].lastIndex(of: 2) -> 5
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].lastIndex(of: 6.5) -> nil
    ///        ["h", "e", "l", "l", "o"].lastIndex(of: "l") -> 3
    ///
    /// - Parameter item: item to check.
    /// - Returns: last index of item in array (if exists).
    func lastIndex(of item: Element) -> Int? {
        for (index, value) in lazy.enumerated().reversed() where value == item {
            return index
        }
        return nil
    }
    
}

public extension Array where Element: Comparable {
    
     func merge(_ elements: [Element]) {
        guard !elements.isEmpty else { return }
        
        for i in self {
            for j in elements where i > j {
            }
        }
    }
}

public extension Array {
    var data: Data {
        let data = try? JSONSerialization.data(withJSONObject: self)
        return data ?? Data()
    }
}

