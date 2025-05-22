//
//  SKKParsersBase.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/15/25.
//

class SKKParsersBase {
    struct UnexpectedTokenError: Error {}

    private var content: any StringProtocol

    init(source: String) {
        content = source
    }

    // MARK: Primitive

    func peek<T>(with parser: () throws -> T) -> T? {
        let original = content
        defer { self.content = original }
        return try? parser()
    }

    func consume(where predicate: (Character) -> Bool) throws -> Character {
        guard let character = content.first else {
            throw UnexpectedTokenError()
        }
        guard predicate(character) else {
            throw UnexpectedTokenError()
        }
        content = content.dropFirst()
        return character
    }

    // MARK: Predicate

    func expect(character: Character) throws -> Character {
        return try self.consume {
            $0 == character
        }
    }

    func oneOf(_ string: String) throws -> Character {
        return try consume {
            string.contains($0)
        }
    }

    func noneOf(_ string: String) throws -> Character {
        return try consume {
            !string.contains($0)
        }
    }

    // MARK: - Collection

    func many<T>(parser: () throws -> T) rethrows -> [T] {
        var result = [T]()
        do {
            while true {
                let value = try parser()
                result.append(value)
            }
        } catch _ as UnexpectedTokenError {}
        return result
    }

    func attempt<T>(parser: () throws -> T) rethrows -> T? {
        let original = content
        do {
            return try parser()
        } catch _ as UnexpectedTokenError {
            content = original
            return nil
        }
    }
}
