import AquaSKKBackend

/// SKKSelector の相棒クラス
@objc public protocol SKKSelectorBuddyProtcol {
    @objc func update(candidate: SKKCandidateBridge)
}
