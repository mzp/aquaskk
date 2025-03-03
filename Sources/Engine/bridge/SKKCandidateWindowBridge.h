//
//  SKKCandidateWindowBridge.h
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>

class SKKCandidateWindowBridge : public IntrusiveRefCounted<SKKCandidateWindowBridge>, public SKKCandidateWindow {
    SKKCandidateWindow* impl_;
public:
    SKKCandidateWindowBridge(SKKCandidateWindow *impl): impl_(impl) {}
    virtual ~SKKCandidateWindowBridge() {}

    // 各ページ毎に表示可能な候補数を求める
    virtual void Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages) {
        impl_->Setup(begin, end, pages);
    }

    virtual void
    Update(SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max) {
        impl_->Update(begin, end, cursor, page_pos, page_max);
    }

    // 候補ラベルのインデックス取得(一致しない場合には -1)
    virtual int LabelIndex(char label) {
        return impl_->LabelIndex(label);
    }
} SWIFT_SHARED_REFERENCE(retainSKKCandidateWindowBridge, releaseSKKCandidateWindowBridge);

void retainSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj);
void releaseSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj);
