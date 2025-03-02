//
//  SKKWindowSelector.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/01.
//


// <Placeholder> SKKCandidateWindow の適切なメソッド定義が必要
protocol CandidateWindowPresenter {
    func setup(candidates: some Collection<SKKCandidate>) -> [Int]
    func labelIndex(label: Character) -> Int
    func update(candidates: some Collection<SKKCandidate>, cursor: Int, position: Int, max: Int)
    func show()
    func hide()
}


class SKKWindowSelectorImpl {
    private var presenter: CandidateWindowPresenter

    // candidates.begin + offset = visibles.begin
    private var candidates:AnyCollection<SKKCandidate>
    private var offset: Int = 0
    private var visibles: AnyCollection<SKKCandidate>

    private var countPerSection: [Int] = []
    private var indexPath: IndexPath



    init(presenter: CandidateWindowPresenter) {
        self.presenter = presenter
        self.indexPath = IndexPath(item: 0, section: 0)
        self.candidates = AnyCollection([])
        self.visibles = candidates
    }

    func setup(container: some Collection<SKKCandidate>, inlineCount: Int) {
        candidates = AnyCollection(Array(container.dropFirst(inlineCount)))
        countPerSection = presenter.setup(candidates: candidates)
        self.indexPath.section = 0
        self.indexPath.item = 0
        offset = 0

        refresh()
    }

    func next() -> Bool {
        if self.indexPath.section == maxPage() {
            return false
        }

        offset += countPerSection[self.indexPath.section]
        self.indexPath.section += 1
        self.indexPath.item = 0

        refresh()
        show()

        return true
    }

    func prev() -> Bool {
        if self.indexPath.section == minPage() {
            return false
        }

        self.indexPath.section -= 1
        offset -= countPerSection[self.indexPath.section]
        self.indexPath.item = 0

        refresh()
        show()

        return true
    }

    var current : SKKCandidate? {
        guard !visibles.isEmpty else {
            return nil
        }
        return visibles[AnyIndex(self.indexPath.item)]
    }

    var isEmpty: Bool {
        return candidates.isEmpty
    }

    func cursorLeft() {
        if self.indexPath.item != minPosition() {
            self.indexPath.item -= 1
            show()
        }
    }

    func cursorRight() {
        if self.indexPath.item != maxPosition() {
            self.indexPath.item += 1
            show()
        }
    }

    func cursorUp() {
        self.indexPath.item = minPosition()
        show()
    }

    func cursorDown() {
        self.indexPath.item = maxPosition()
        show()
    }

    func select(label: Character) -> Bool {
        let index = presenter.labelIndex(label: label)
        if index >= 0 && index < visibles.count {
            self.indexPath.item = index
            show()
            return true
        }
        return false
    }

    func show() {
        presenter.update(candidates: visibles, cursor: self.indexPath.item, position: self.indexPath.section + 1, max: countPerSection.count)
        presenter.show()
    }

    func hide() {
        presenter.hide()
    }

    private func refresh() {
        if !countPerSection.isEmpty {
            let limit = countPerSection[self.indexPath.section]
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

    // <Placeholder> PageRangeの実装が必要
    private func pageRange(range: [SKKCandidate], offset: Int, limit: Int) -> AnyCollection<SKKCandidate> {
        return AnyCollection(range[offset..<min(offset + limit, range.count)])
    }
}
