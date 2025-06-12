#include <cassert>
#include <fstream>
#include <ios>
#include <iostream>
#import <InputMethodKit/InputMethodKit.h>
#import <XCTest/XCTest.h>
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKEngine/AquaSKKEngine.h>
#import <AquaSKKService/AquaSKKService.h>
#import <AquaSKKTesting/AquaSKKTesting.h>
#import <AquaSKKInput/AquaSKKInput-Preamble.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#import <AquaSKKInput/AquaSKKInput-Swift.h>
#import <AquaSKKTesting/AquaSKKTesting-Swift.h>
#include "TestData.h"

@interface SKKInputSessionTests : XCTestCase
@end

class TestRunner {
    MockInputSessionParameterImpl *param;
    SKKInputSessionImpl *session;
    AquaSKKInput::SKKKeymapImpl map;
    TestData test;

    SKKEvent getEvent(TestEntry &entry) {
        TestEvent &input = entry.input;

        auto array = map.bridgedFetch(input.code, 0, input.mods);
        return SKKEvent((int)array[0], (int)array[1], (int)array[2], (int)array[3]);
    }

    void initialize() {
        SKKDictionaryKeyContainer keys;
        std::string userdict("skk.jisyo");
        std::ofstream ofs(userdict.c_str(), std::ios_base::trunc);
        ofs.close();

        auto backend = AquaSKKBackend::SKKBackendImpl::shared();
        backend.bridgeInitialize(userdict, keys);

        [[SKKRomanKanaConverterImpl sharedInstance] initialize:@"kana-rule.conf"];
        map.initialize("keymap.conf");

        [session addInputModeListener:param.listener];
    }

    void execute() {
        int total = 0;
        int success = 0;
        TestEntry entry;

        while(test >> entry) {
            ++total;
            TestResult actual;
            actual.fixed = std::string(param.resultFixed.UTF8String);
            actual.marked = std::string(param.resultMarked.UTF8String);
            actual.mode = param.resultMode;
            actual.pos = static_cast<int>(param.resultPos);
            actual.Clear();

            [param setSelectedString:SKKUTF8String(entry.input.selection)];
            [param setYankString:SKKUTF8String(entry.input.yank)];

            SKKEvent event = getEvent(entry);

            actual.ret = [session handleWithEvent:event];

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
    MockInputSessionParameterImpl *mockParam;

    TestRunner(const std::string &path)
        : param([MockInputSessionParameterImpl new]), map(AquaSKKInput::SKKKeymapImpl::init()) {
        session = [[SKKInputSessionImpl alloc] initWithParam:param];
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
