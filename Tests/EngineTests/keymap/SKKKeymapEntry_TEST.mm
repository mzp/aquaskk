#include <cassert>
#include <iostream>
#import <AquaSKKEngine/SKKEvent.h>
#import <AquaSKKEngine/SKKKeyState.h>
#import <AquaSKKEngine/SKKKeymapEntry.h>
#import <XCTest/XCTest.h>

@interface SKKKeymapEntryTests: XCTestCase
@end

@implementation SKKKeymapEntryTests

- (void)testMain {
    SKKKeymapEntry entry;
    int key;

    entry = SKKKeymapEntry("Unknown", "a");
    XCTAssert(!(entry >> key));

    entry = SKKKeymapEntry("SKK_JMODE", "a");
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('a', false));
    XCTAssert(entry.Symbol() == SKK_JMODE);
    XCTAssert(!(entry >> key));

    entry = SKKKeymapEntry("SKK_JMODE", "keycode::0x0a");
    entry >> key;
    XCTAssert(key == SKKKeyState::KeyCode(0x0a, false));

    entry = SKKKeymapEntry("SKK_ENTER", "hex::0x03");
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode(0x03, false));

    entry = SKKKeymapEntry("SKK_ENTER", "ctrl::m");
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('m', SKKKeyState::CTRL));

    entry = SKKKeymapEntry("Direct", "group::a,c,d-f");
    XCTAssert(!entry.IsNot());
    XCTAssert(!entry.IsEvent());
    XCTAssert(entry.Symbol() == Direct);
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('a', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('c', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('d', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('e', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('f', false));

    entry = SKKKeymapEntry("NotDirect", "group::a,c,d-f");
    XCTAssert(entry.IsNot());
    XCTAssert(!entry.IsEvent());
    XCTAssert(entry.Symbol() == Direct);
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('a', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('c', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('d', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('e', false));
    entry >> key;
    XCTAssert(key == SKKKeyState::CharCode('f', false));
}

@end
