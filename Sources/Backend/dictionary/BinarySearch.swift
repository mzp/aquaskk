//
//  BinarySearch.swift
//  AquaSKKBackend
//
//  Created by mzp on 10/6/24.
//

import Foundation

public func binarySearch<T: RandomAccessCollection>(_ element: T.Element,  from source: T, startIndex: T.Index, endIndex: T.Index, by lessThan: (T.Element, T.Element) -> Bool) -> T.Element? {
    let distance = source.distance(from: startIndex, to: endIndex)
    guard 0 <= distance else {
        return nil
    }
    let middleIndex = source.index(startIndex, offsetBy:distance / 2)

    guard middleIndex < source.endIndex else {
        return nil
    }

    let middle = source[middleIndex]

    if lessThan(element, middle) {
        let next = source.index(before: middleIndex)
        return binarySearch(
            element,
            from: source,
            startIndex: startIndex,
            endIndex: next,
            by: lessThan
        )
    } else if lessThan(middle, element) {
        let next = source.index(after: middleIndex)
        return binarySearch(
            element,
            from: source,
            startIndex: next,
            endIndex: endIndex,
            by: lessThan
        )
    } else {
        return middle
    }
}
