//
//  MockCompletionHelper.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/15/24.
//

internal import AquaSKKBackend

extension MockCompletionHelper: CompletionHelper {
    public var entry: String {
        String(getEntry())
    }

    public var canContinue: Bool {
        CanContinue()
    }

    public func append(completion: String) {
        Add(std.string(completion))
    }
}
