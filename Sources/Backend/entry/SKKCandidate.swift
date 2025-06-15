//
//  SKKCandidate.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/06/14.
//

@objc public class SKKCandidateImpl: NSObject {
    @objc public private(set) var avoidStudy = false
    @objc public private(set) var word: String
    @objc public let annotation: String
    private var variantValue: String = ""
    @objc public var variant: String {
        set { variantValue = newValue }
        get {
            variantValue.isEmpty ? word : variantValue
        }
    }

    override public init() {
        word = ""
        annotation = ""
    }

    @objc public init(candidate: String, autoParse: Bool) {
        if autoParse {
            if let index = candidate.firstIndex(of: ";") {
                word = String(candidate[candidate.startIndex ..< index])
                annotation = String(candidate[candidate.index(after: index) ..< candidate.endIndex])
            } else {
                word = ""
                annotation = ""
            }
        } else {
            word = candidate
            annotation = ""
        }
    }

    @objc public var isEmpty: Bool {
        word.isEmpty
    }

    @objc public func setAvoidStudy() {
        avoidStudy = true
    }

    override public var description: String {
        if annotation.isEmpty {
            return word
        } else {
            return "\(word);\(annotation)"
        }
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SKKCandidateImpl else {
            return false
        }
        return word == other.word
    }

    static let table = [
        ("[", "[5b]"),
        ("/", "[2f]"),
        (";", "[3b]"),
    ]

    @objc public func encode() {
        var tmp = word
        for (from, to) in Self.table {
            tmp.replace(from, with: to)
        }
        word = tmp
    }

    @objc public func decode() {
        var tmp = word
        for (from, to) in Self.table {
            tmp.replace(to, with: from)
        }
        word = tmp
    }
}

// std::string word_;
// std::string annotation_;
// std::string variant_; // 数値変換用
// bool avoid_study_;    // 動的変換は学習しない
//
// void parse(const std::string &str) {
//     std::string::size_type pos = str.find_first_of(';');
//
//     if(pos != std::string::npos) {
//         annotation_ = str.substr(pos + 1);
//     }
//
//     word_ = str.substr(0, pos);
// }
//
// public:
// SKKCandidate()
//     : avoid_study_(false) {}
//
// SKKCandidate(const std::string &candidate, bool auto_parse = true)
//     : avoid_study_(false) {
//     if(auto_parse) {
//         parse(candidate);
//     } else {
//         word_ = candidate;
//     }
// }
//
// bool IsEmpty() const {
//     return word_.empty();
// }
//
// const std::string &Word() const {
//     return word_;
// }
//
// const std::string &Annotation() const {
//     return annotation_;
// }
//
// const std::string &Variant() const {
//     return (variant_.empty() ? Word() : variant_);
// }
//
// const std::string getAnnotation() const SWIFT_COMPUTED_PROPERTY {
//     return Annotation();
// }
//
// const std::string getVariant() const SWIFT_COMPUTED_PROPERTY {
//     return Variant();
// }
//
// const std::string getWord() const SWIFT_COMPUTED_PROPERTY {
//     return Word();
// }
//
// bool AvoidStudy() const {
//     return avoid_study_;
// }
//
// void SetVariant(const std::string str) SWIFT_COMPUTED_PROPERTY {
//     variant_ = str;
// }
//
// void SetAvoidStudy() {
//     avoid_study_ = true;
// }
//
// std::string ToString() const {
//     return word_ + (annotation_.empty() ? "" : (";" + annotation_));
// }
//
// bool operator==(const SKKCandidate &rhs) const {
//     return Variant() == rhs.Variant(); // 注釈は比較しない
// }
//
// bool operator!=(const SKKCandidate &rhs) const {
//     return !this->operator==(rhs);
// }
//
// // 候補のエンコードとデコード
// static std::string Encode(const std::string &src);
// static std::string Decode(const std::string &src);
//
// void Encode() {
//     word_ = Encode(word_);
// }
//
// void Decode() {
//     word_ = Decode(word_);
// }
// #import "SKKCandidate.h"
//
// static std::string org_table[] = {"[", "/", ";", ""};
// static std::string enc_table[] = {"[5b]", "[2f]", "[3b]", ""};
//
// static std::string translate(const std::string &str, const std::string *from, const std::string *to) {
//     std::string result(str);
//
//     for(int index = 0; !from[index].empty(); ++index) {
//         for(std::string::size_type pos = 0; (pos = result.find(from[index], pos)) != std::string::npos;
//             pos += to[index].size()) {
//             result.replace(pos, from[index].size(), to[index]);
//         }
//     }
//
//     return result;
// }
//
// std::string SKKCandidate::Encode(const std::string &src) {
//     return translate(src, org_table, enc_table);
// }
//
// std::string SKKCandidate::Decode(const std::string &src) {
//     return translate(src, enc_table, org_table);
// }
//
//
