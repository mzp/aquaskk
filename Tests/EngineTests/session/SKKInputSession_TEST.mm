#include <cassert>
#include <fstream>
#include <ios>
#include <iostream>
#import <InputMethodKit/InputMethodKit.h>
#import <XCTest/XCTest.h>
#import <AquaSKKBackend/SKKBackEnd.h>
#import <AquaSKKEngine/AquaSKKEngine.h>
#import <AquaSKKService/AquaSKKService.h>
#import <AquaSKKTesting/AquaSKKTesting.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>
#include "SKKRomanKanaConverter.h"
#include "TestData.h"

@interface SKKInputSessionTests : XCTestCase
@end

class TestRunner {
    MockInputSessionParameter *param;
    SKKInputSession session;
    AquaSKKInput::SKKKeymapImpl map;
    TestData test;

    SKKEvent getEvent(TestEntry &entry) {
        TestEvent &input = entry.input;

        return map.fetch(input.code, 0, input.mods);
    }

    void initialize() {
        SKKDictionaryKeyContainer keys;
        std::string userdict("skk.jisyo");
        std::ofstream ofs(userdict.c_str(), std::ios_base::trunc);
        ofs.close();

        SKKBackEnd::theInstance().Initialize(userdict, keys);

        SKKRomanKanaConverter::theInstance().Initialize("kana-rule.conf");

        map.initialize("keymap.conf");

        session.AddInputModeListener(param->Listener());
    }

    void execute() {
        int total = 0;
        int success = 0;
        TestEntry entry;

        while(test >> entry) {
            ++total;
            TestResult &actual = param->Result();

            actual.Clear();

            param->SetSelectedString(entry.input.selection);
            param->SetYankString(entry.input.yank);

            SKKEvent event = getEvent(entry);

            actual.ret = session.HandleEvent(event);

            if(actual != entry.expected) {
                std::cerr << std::endl;
                std::cerr << "*** test failed *** line=" << entry.line << std::endl;
                std::cerr << "\t" << event.dump() << std::endl;
                entry.expected.Dump("\texpected: ");
                actual.Dump("\t  actual: ");
                std::cerr << std::endl;
            } else {
                ++success;
            }
        }

        std::cerr << "success=" << success << " / "
                  << "total=" << total << ", (" << (double)success / total * 100 << "%)" << std::endl;
    }

public:
    TestRunner(const std::string &path)
        : param(new MockInputSessionParameter()), session(param), map(AquaSKKInput::SKKKeymapImpl::init()) {
        initialize();
        test.Load(path);
    }

    void Run() {
        execute();
    }
};

@implementation SKKInputSessionTests

- (void)testMain {
    TestRunner test("test.dat");

    test.Run();
}

@end
