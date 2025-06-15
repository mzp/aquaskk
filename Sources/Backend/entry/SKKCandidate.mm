/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2008 Tomotaka SUWA <t.suwa@mac.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/

#import "SKKCandidate.h"
#import <AquaSKKBackend/SKKEncoding.h>
#import "AquaSKKBackend-Preamble.h"
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

SKKCandidate::SKKCandidate()
    : avoid_study_(false), impl_([[SKKCandidateImpl alloc] init]) {}

SKKCandidate::SKKCandidate(const std::string &candidate, bool auto_parse)
    : avoid_study_(false) {
    impl_ = [[SKKCandidateImpl alloc] initWithCandidate:SKKUTF8String(candidate) autoParse:auto_parse];
    if(auto_parse) {
        parse(candidate);
    } else {
        word_ = candidate;
    }
}

static std::string org_table[] = {"[", "/", ";", ""};
static std::string enc_table[] = {"[5b]", "[2f]", "[3b]", ""};

static std::string translate(const std::string &str, const std::string *from, const std::string *to) {
    std::string result(str);

    for(int index = 0; !from[index].empty(); ++index) {
        for(std::string::size_type pos = 0; (pos = result.find(from[index], pos)) != std::string::npos;
            pos += to[index].size()) {
            result.replace(pos, from[index].size(), to[index]);
        }
    }

    return result;
}

bool SKKCandidate::IsEmpty() const {
    return word_.empty();
}

const std::string &SKKCandidate::Word() const {
    return word_;
}

const std::string &SKKCandidate::Annotation() const {
    return annotation_;
}

const std::string &SKKCandidate::Variant() const {
    return (variant_.empty() ? Word() : variant_);
}

const std::string SKKCandidate::getAnnotation() const {
    return Annotation();
}

const std::string SKKCandidate::getVariant() const {
    return Variant();
}

const std::string SKKCandidate::getWord() const {
    return Word();
}

bool SKKCandidate::AvoidStudy() const {
    return avoid_study_;
}

void SKKCandidate::SetVariant(const std::string str) {
    variant_ = str;
}

void SKKCandidate::SetAvoidStudy() {
    avoid_study_ = true;
}

std::string SKKCandidate::ToString() const {
    return word_ + (annotation_.empty() ? "" : (";" + annotation_));
}

bool SKKCandidate::operator==(const SKKCandidate &rhs) const {
    return Variant() == rhs.Variant(); // 注釈は比較しない
}

bool SKKCandidate::operator!=(const SKKCandidate &rhs) const {
    return !this->operator==(rhs);
}

void SKKCandidate::Encode() {
    word_ = Encode(word_);
}

void SKKCandidate::Decode() {
    word_ = Decode(word_);
}

std::string SKKCandidate::Encode(const std::string &src) {
    return translate(src, org_table, enc_table);
}

std::string SKKCandidate::Decode(const std::string &src) {
    return translate(src, enc_table, org_table);
}
