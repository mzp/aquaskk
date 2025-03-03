//
//  SKKWindowSelector.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/01.
//

class SKKWindowSelectorImpl {
    private var presenter: SKKCandidatePresenter

    // candidates.begin + offset = visibles.begin
    private var candidates: AnyCollection<SKKCandidate>
    private var offset: Int = 0
    private var visibles: AnyCollection<SKKCandidate>

    private var countPerSection: [Int] = []
    private var indexPath: IndexPath

    init(presenter: SKKCandidatePresenter) {
        self.presenter = presenter
        indexPath = IndexPath(item: 0, section: 0)
        candidates = AnyCollection([])
        visibles = candidates
    }

    /// SKKCandidateはObjective-C <-> Swift間ではやり取りできないので、必要な情報だけ抜き出す
    func bridgeArray(_ value: any Collection<SKKCandidate>) -> [String] {
        value.map {
            String($0.variant)
        }
    }

    func setup(container: some Collection<SKKCandidate>, inlineCount: Int) {
        candidates = AnyCollection(Array(container.dropFirst(inlineCount)))
        countPerSection = presenter.setup(candidates: bridgeArray(candidates))
        indexPath.section = 0
        indexPath.item = 0
        offset = 0

        refresh()
    }

    func next() -> Bool {
        if indexPath.section == maxPage() {
            return false
        }
        guard countPerSection.isEmpty == false else {
            return false
        }

        offset += countPerSection[indexPath.section]
        indexPath.section += 1
        indexPath.item = 0

        refresh()
        show()

        return true
    }

    func prev() -> Bool {
        if indexPath.section == minPage() {
            return false
        }

        indexPath.section -= 1
        offset -= countPerSection[indexPath.section]
        indexPath.item = 0

        refresh()
        show()

        return true
    }

    var current: SKKCandidate? {
        guard !visibles.isEmpty else {
            return nil
        }
        return Array(visibles)[indexPath.item]
    }

    var isEmpty: Bool {
        return candidates.isEmpty
    }

    func cursorLeft() {
        if indexPath.item != minPosition() {
            indexPath.item -= 1
            show()
        }
    }

    func cursorRight() {
        if indexPath.item != maxPosition() {
            indexPath.item += 1
            show()
        }
    }

    func cursorUp() {
        indexPath.item = minPosition()
        show()
    }

    func cursorDown() {
        indexPath.item = maxPosition()
        show()
    }

    func select(label: Int) -> Bool {
        let index = presenter.labelIndex(of: label)
        if index >= 0 && index < visibles.count {
            indexPath.item = index
            show()
            return true
        }
        return false
    }

    func show() {
        presenter.update(candidates: bridgeArray(visibles), cursor: indexPath.item, position: indexPath.section + 1, max: countPerSection.count)
        presenter.show()
    }

    func hide() {
        presenter.hide()
    }

    private func refresh() {
        if !countPerSection.isEmpty {
            let limit = countPerSection[indexPath.section]
            let visibleRange = AnyIndex(offset) ..< AnyIndex(min(offset + limit, candidates.count))
            visibles = candidates[visibleRange]
        }
    }

    func minPage() -> Int {
        return 0
    }

    func maxPage() -> Int {
        return countPerSection.count - 1
    }

    func minPosition() -> Int {
        return 0
    }

    func maxPosition() -> Int {
        return visibles.count - 1
    }

    /// <Placeholder> PageRangeの実装が必要
    private func pageRange(range: [SKKCandidate], offset: Int, limit: Int) -> AnyCollection<SKKCandidate> {
        return AnyCollection(range[offset ..< min(offset + limit, range.count)])
    }
}
