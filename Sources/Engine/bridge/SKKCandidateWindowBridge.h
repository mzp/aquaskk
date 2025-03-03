//
//  SKKCandidateWindowBridge.h
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#import <AquaSKKEngine/IntrusiveRefCounted.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>

// 純粋仮装関数を持つクラスはSwiftからは攫われないのでブリッジする。
class SKKCandidateWindowBridge : public IntrusiveRefCounted<SKKCandidateWindowBridge>, public SKKCandidateWindow {
    SKKCandidateWindow *impl_;

public:
    SKKCandidateWindowBridge(SKKCandidateWindow *impl);
    virtual ~SKKCandidateWindowBridge();

    virtual void Setup(SKKCandidateIterator begin, SKKCandidateIterator end, std::vector<int> &pages);
    virtual void Update(SKKCandidateIterator begin, SKKCandidateIterator end, int cursor, int page_pos, int page_max);
    virtual int LabelIndex(char label);
    virtual void Show();
    virtual void Hide();

    // Swiftから使いやすくするためのメンバ関数
    std::vector<int> Setup(SKKCandidateContainer container);
    void Update(SKKCandidateContainer container, int cursor, int page_pos, int page_max);
} SWIFT_SHARED_REFERENCE(retainSKKCandidateWindowBridge, releaseSKKCandidateWindowBridge);

void retainSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj);
void releaseSKKCandidateWindowBridge(SKKCandidateWindowBridge *obj);
