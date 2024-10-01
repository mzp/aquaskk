//
//  DictionaryKeeper.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/30/24.
//

import Foundation
import OSLog

class DictionaryKeeper {
    enum Encoding {
        case eucjp
        case utf8
    }
    var timer: Timer?
    var file = DictionaryFile()
    var loaded: Bool = false
    var needsConversion: Bool
    var timeout: TimeInterval = 0
    var condition = NSCondition()

    init(encoding: Encoding) {
        needsConversion = (encoding == .eucjp)
    }

    func initialize(loader: DictionaryLoader) {
        guard timer == nil else {
            Logger.backend.warning("\(#function): already initilazed")
            return
        }
        loader.delegate = self
        timeout = loader.timeout()
        self.timer = .init(
            timeInterval: loader.interval(),
            repeats: true,
            block: { _ in
                loader.run()
            }
        )
    }

    func findOkuriAri(query: String) -> String {
        return fetch(query: query, container: file.okuriAri)
    }
    func findOkuriNasi(query: String) -> String {
        return fetch(query: query, container: file.okuriNasi)
    }

    var ready: Bool {
        if loaded {
            return true
        }
        if !condition.wait(until: Date(timeIntervalSinceNow: timeout)) {
            return false
        }
        return true
    }

    func reverseLookup(candidate: String) -> String {
        condition.lock()
        defer { condition.unlock() }
//        pthread::lock scope(condition_);
        guard ready else {
            return ""
        }
        let container = file.okuriNasi
        var parser = SKKCandidateParser()

        let key = "\(externalEncoding(from: candidate))"
        let entries = container.filter({ entry in
            entry.rawValue.contains(key)
        })
        for entry in entries {
            parser.Parse(std.string(internalEncoding(from: entry.rawValue)))
            let suite = parser.getCandidates()
            if suite.contains(where: {
                $0 == SKKCandidate(std.string(candidate), true)
            }) {
                return internalEncoding(from: entry.entry)
            }
        }
/*        std::remove_copy_if(
            container.begin(), container.end(), std::back_inserter(entries), NotInclude("/" + eucj_from_utf8(candidate)));

        for(unsigned i = 0; i < entries.size(); ++i) {
            parser.Parse(utf8_from_eucj(entries[i].second));
            const SKKCandidateContainer &suite = parser.Candidates();

            if(std::find(suite.begin(), suite.end(), candidate) != suite.end()) {
                return utf8_from_eucj(entries[i].first);
            }
        }*/

        return "";
    }


    func complete(helper: inout CompletionHelper) {
        // pthread::lock scope(condition_);
        guard ready else {
            return
        }
        let container = file.okuriNasi
        let query = externalEncoding(from: helper.entry)
        
        for entry in container {
            let completion = internalEncoding(from: entry.entry)
            helper.append(completion: completion)
            if !helper.canContinue {
                return
            }
        }
/*
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wshorten-64-to-32"
 EntryRange range = std::equal_range(container.begin(), container.end(), query, CompareFunctor(query.size()));
 #pragma clang diagnostic pop
 for(SKKDictionaryEntryIterator iter = range.first; iter != range.second; ++iter) {
 std::string completion = utf8_from_eucj(iter->first);

 helper.Add(completion);

 if(!helper.CanContinue())
 return;
 }
 */
    }


    private func externalEncoding(from src: String) -> String {
        if needsConversion {
//            return SKKEncoding::eucj_from_utf8(src);
            return src
        }

        return src
    }

    private func internalEncoding(from src: String) -> String {
        if needsConversion {
            // return SKKEncoding::utf8_from_eucj(src);
            return src
        }
        return src
    }

    private func fetch(query: String, container: DictionaryEntryContainer) -> String {
        condition.lock()
        defer { condition.unlock() }

        guard ready else {
            return ""
        }
        return ""
//            pthread::lock scope(condition_);
/*
            if(!ready())
                return "";

            std::string index = eucj_from_utf8(query);

            if(!std::binary_search(container.begin(), container.end(), index, SKKDictionaryEntryCompare())) {
                return "";
            }*/
    }
    /*
     std::unique_ptr<pthread::timer> timer_;
     pthread::condition condition_;
     SKKDictionaryFile file_;
     bool loaded_;
     bool needs_conversion_;
     int timeout_;
     */
}

extension DictionaryKeeper: DictionaryLoaderDelegate {
    func dictionaryLoaderDidUpdate(file: DictionaryFile) {
        self.file = file
        loaded = true
        condition.signal()
//        condition_.signal();
    }
}


/*

 SKKDictionaryKeeper::SKKDictionaryKeeper(Encoding encoding)
 : timer_(nullptr), loaded_(false), needs_conversion_(encoding == EUC_JP) {}

 void SKKDictionaryKeeper::Initialize(SKKDictionaryLoader *loader) {
 if(timer_.get())
 return;

 loader->Connect(this);

 timeout_ = loader->Timeout();
 timer_ = std::unique_ptr<pthread::timer>(new pthread::timer(loader, loader->Interval()));
 }

 std::string SKKDictionaryKeeper::FindOkuriAri(const std::string &query) {
 return fetch(query, file_.OkuriAri());
 }

 std::string SKKDictionaryKeeper::FindOkuriNasi(const std::string &query) {
 return fetch(query, file_.OkuriNasi());
 }

 std::string SKKDictionaryKeeper::ReverseLookup(const std::string &candidate) {
 pthread::lock scope(condition_);

 if(!ready())
 return "";

 SKKDictionaryEntryContainer &container = file_.OkuriNasi();
 SKKDictionaryEntryContainer entries;
 SKKCandidateParser parser;

 std::remove_copy_if(
 container.begin(), container.end(), std::back_inserter(entries), NotInclude("/" + eucj_from_utf8(candidate)));

 for(unsigned i = 0; i < entries.size(); ++i) {
 parser.Parse(utf8_from_eucj(entries[i].second));
 const SKKCandidateContainer &suite = parser.Candidates();

 if(std::find(suite.begin(), suite.end(), candidate) != suite.end()) {
 return utf8_from_eucj(entries[i].first);
 }
 }

 return "";
 }

 void SKKDictionaryKeeper::Complete(SKKCompletionHelper &helper) {
 pthread::lock scope(condition_);

 if(!ready())
 return;

 typedef std::pair<SKKDictionaryEntryIterator, SKKDictionaryEntryIterator> EntryRange;

 SKKDictionaryEntryContainer &container = file_.OkuriNasi();
 std::string query = eucj_from_utf8(helper.Entry());
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wshorten-64-to-32"
 EntryRange range = std::equal_range(container.begin(), container.end(), query, CompareFunctor(query.size()));
 #pragma clang diagnostic pop
 for(SKKDictionaryEntryIterator iter = range.first; iter != range.second; ++iter) {
 std::string completion = utf8_from_eucj(iter->first);

 helper.Add(completion);

 if(!helper.CanContinue())
 return;
 }
 }

 // ------------------------------------------------------------

 void SKKDictionaryKeeper::SKKDictionaryLoaderUpdate(const SKKDictionaryFile &file) {
 pthread::lock scope(condition_);

 file_ = file;

 loaded_ = true;

 condition_.signal();
 }

 std::string SKKDictionaryKeeper::fetch(const std::string &query, SKKDictionaryEntryContainer &container) {
 pthread::lock scope(condition_);

 if(!ready())
 return "";

 std::string index = eucj_from_utf8(query);

 if(!std::binary_search(container.begin(), container.end(), index, SKKDictionaryEntryCompare())) {
 return "";
 }

 SKKDictionaryEntryIterator iter =
 std::lower_bound(container.begin(), container.end(), index, SKKDictionaryEntryCompare());

 return utf8_from_eucj(iter->second);
 }

 bool SKKDictionaryKeeper::ready() {
 // 辞書のロードが完了するまで待つ
 if(!loaded_) {
 if(!condition_.wait(timeout_))
 return false;
 }

 return true;
 }

 std::string SKKDictionaryKeeper::eucj_from_utf8(const std::string &src) {
 if(needs_conversion_) {
 return SKKEncoding::eucj_from_utf8(src);
 }

 return src;
 }

 std::string SKKDictionaryKeeper::utf8_from_eucj(const std::string &src) {
 if(needs_conversion_) {
 return SKKEncoding::utf8_from_eucj(src);
 }

 return src;
 }

 */
