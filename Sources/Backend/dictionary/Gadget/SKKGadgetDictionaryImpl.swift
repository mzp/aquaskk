//
//  SKKGadgetDictionaryImpl.swift
//  TyperTests
//
//  Created by mzp on 2/16/25.
//

public class SKKGadgetDictionaryImpl: SKKBaseDictionaryProtocol {
    // MARK: - BaseDictionary

    public init() {}

    public func initialize(path _: String) async throws {}
    public func initialize(path _: String) {}

    public func reverseLookup(candidate _: String) -> String {
        return ""
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        guard !entry.IsOkuriAri() else {
            // 今のところ「送りあり」のサポートはなし
            return
        }
        let entryString = String(entry.EntryString())
        var candidates = [String]()
        if entryString.hasPrefix("now") {
            candidates.append(contentsOf: now(entry: entryString))
        }
        if entryString.hasPrefix("today") {
            candidates.append(contentsOf: today(entry: entryString))
        }
        if entryString.hasPrefix("=") {
            candidates.append(contentsOf: calculate(entry: entryString))
        }
        for candidate in candidates {
            let cand = SKKCandidate(std.string(candidate), true)
            result.add(candidate: cand)
        }
    }

    public func complete(helper: inout any SKKCompletionHelperProtocol) {
        if "today".hasPrefix(helper.entry) {
            helper.add(completion: "today")
        }
        if "now".hasPrefix(helper.entry) {
            helper.add(completion: "now")
        }
    }

    // MARK: - Handler

    private var nowFormatters: [DateFormatter] = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm:ss"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "HH 時 mm 分 ss 秒"
        return [formatter1, formatter2]
    }()

    private var todayFormatters: [DateFormatter] = {
        let formatter1 = DateFormatter()
        formatter1.locale = Locale(identifier: "en_US")
        formatter1.dateFormat = "yyyy/MM/dd(EEE)"

        let formatter2 = DateFormatter()
        formatter2.locale = Locale(identifier: "ja_JP")
        formatter2.dateFormat = "yyyy 年 MM 月 dd 日 (E)"

        return [formatter1, formatter2]
    }()

    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        return formatter
    }()

    private func now(entry _: String) -> [String] {
        let date = Date()
        return nowFormatters.map { formatter in
            formatter.string(from: date)
        }
    }

    private func today(entry _: String) -> [String] {
        let date = Date()
        return todayFormatters.map { formatter in
            formatter.string(from: date)
        }
    }

    private func calculate(entry: String) -> [String] {
        let engine = SKKCalculator.engine
        do {
            let input = String(entry.dropFirst())
            let number = try engine.objcBridgeRun(input)

            if let string = numberFormatter.string(from: number) {
                return [string]
            } else {
                return []
            }
        } catch {
            return [error.localizedDescription]
        }
    }

    // MARK: ObjC Bridge

    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: SKKCompletionHelperProtocol = helper
        complete(helper: &tmp)
    }
}
