//
//  SKKEvent.m
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/15.
//

#import "SKKEvent.h"
#import "AquaSKKEngine-Preamble.h"
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKEvent::SKKEvent()
    : id(0), code(0), attribute(0), option(0) {}
SKKEvent::SKKEvent(int e, unsigned char c, int a)
    : id(e), code(c), attribute(a), option(0) {}

SKKEvent::SKKEvent(int id, unsigned char code, int attribute, int option)
    : id(id), code(code), attribute(attribute), option(option) {}

bool SKKEvent::IsDirect() const {
    return attribute & [SKKAttributeValue direct];
}
bool SKKEvent::IsUpperCases() const {
    return attribute & [SKKAttributeValue upperCases];
}
bool SKKEvent::IsToggleKana() const {
    return attribute & [SKKAttributeValue toggleKana];
}
bool SKKEvent::IsToggleJisx0201Kana() const {
    return attribute & [SKKAttributeValue toggleJisx0201Kana];
}
bool SKKEvent::IsSwitchToAscii() const {
    return attribute & [SKKAttributeValue switchToAscii];
}
bool SKKEvent::IsSwitchToJisx0208Latin() const {
    return attribute & [SKKAttributeValue switchToJisx0208Latin];
}
bool SKKEvent::IsEnterJapanese() const {
    return attribute & [SKKAttributeValue enterJapanese];
}
bool SKKEvent::IsEnterAbbrev() const {
    return attribute & [SKKAttributeValue enterAbbrev];
}
bool SKKEvent::IsNextCompletion() const {
    return attribute & [SKKAttributeValue nextCompletion];
}
bool SKKEvent::IsPrevCompletion() const {
    return attribute & [SKKAttributeValue prevCompletion];
}
bool SKKEvent::IsNextCandidate() const {
    return attribute & [SKKAttributeValue nextCandidate];
}
bool SKKEvent::IsPrevCandidate() const {
    return attribute & [SKKAttributeValue prevCandidate];
}
bool SKKEvent::IsRemoveTrigger() const {
    return attribute & [SKKAttributeValue removeTrigger];
}
bool SKKEvent::IsInputChars() const {
    return attribute & [SKKAttributeValue inputChars];
}
bool SKKEvent::IsCompConversion() const {
    return attribute & [SKKAttributeValue compConversion];
}
bool SKKEvent::IsStickyKey() const {
    return attribute & [SKKAttributeValue stickyKey];
}

const SKKEvent &SKKEvent::Null() {
    auto skk_null = AquaSKKEngine::SKKEventID::null().getRawValue();
    static SKKEvent obj(skk_null, 0, 0);
    return obj;
}

bool SKKEvent::operator==(const SKKEvent &rhs) const {
    return (id == rhs.id && code == rhs.code && attribute == rhs.attribute);
}

std::string SKKEvent::attr() const {
    std::string result;

#define TEST_attribute(attr)                                                                                           \
    if(Is##attr())                                                                                                     \
    result += "," #attr

    TEST_attribute(Direct);
    TEST_attribute(UpperCases);
    TEST_attribute(ToggleKana);
    TEST_attribute(ToggleJisx0201Kana);
    TEST_attribute(SwitchToAscii);
    TEST_attribute(SwitchToJisx0208Latin);
    TEST_attribute(EnterJapanese);
    TEST_attribute(EnterAbbrev);
    TEST_attribute(NextCompletion);
    TEST_attribute(PrevCompletion);
    TEST_attribute(NextCandidate);
    TEST_attribute(PrevCandidate);
    TEST_attribute(RemoveTrigger);
    TEST_attribute(InputChars);
    TEST_attribute(CompConversion);

#undef TEST_attribute

    if(result.empty()) {
        result = "attr=none";
    } else {
        result = "attr=" + result.substr(1);
    }

    return result;
}

std::string SKKEvent::dump() const {
    const char *eventName[] = {
        "SKK_NULL",
        "SKK_JMODE",
        "SKK_ENTER",
        "SKK_CANCEL",
        "SKK_BACKSPACE",
        "SKK_DELETE",
        "SKK_TAB",
        "SKK_PASTE",
        "SKK_LEFT",
        "SKK_RIGHT",
        "SKK_UP",
        "SKK_DOWN",
        "SKK_CHAR",
        "SKK_PING",
        "SKK_UNDO",
        "SKK_ASCII_MODE",
        "SKK_HIRAKANA_MODE",
        "SKK_KATAKANA_MODE",
        "SKK_JISX0201KANA_MODE",
        "SKK_JISX0208LATIN_MODE",
        "SKK_YES",
        "SKK_NO",
        "SKK_ON",
        "SKK_OFF"};

    auto skk_null = AquaSKKEngine::SKKEventID::null().getRawValue();
    std::ostringstream buf;
    if(0 <= id - skk_null) {
        buf << "event=" << eventName[id - skk_null] << ", ";
    } else {
        buf << "event=" << id << "(UNKNOWN), ";
    }

    buf << "code=0x" << std::hex << (unsigned)code << ", " << attr();

    return buf.str();
}
