#import <XCTest/XCTest.h>
#import <AquaSKKBackend/SKKDistributedUserDictionary.h>
#import <AquaSKKBackend/pthreadutil.h>
#import <AquaSKKBackend/socketutil.h>
#import <AquaSKKTesting/MockCompletionHelper.h>
#include "stringutil.h"

@interface SKKDistributedUserDictionaryTests : XCTestCase
@end

class param {
    string::splitter splitter_;

public:
    param(const std::string &line) {
        splitter_.split(line, " ");

        splitter_ >> command >> entry;

        if(command == "PUT" || command == "DELETE") {
            splitter_ >> candidate;
        }

        splitter_ >> okuri;
    }

    std::string command;
    std::string entry;
    std::string candidate;
    std::string okuri;
};

class server : public pthread::task {
    net::socket::tcpserver server_;

    void session(std::iostream &stream) {
        std::string line;

        while(std::getline(stream, line)) {
            param param(line);

            stream << "OK" << "\r\n" << std::flush;

            if(param.command == "GET" || param.command == "COMPLETE") {
                stream << "\r\n" << std::flush;
            }
        }
    }

public:
    server() {
        server_.open(10789);
    }

    virtual bool run() {
        while(int fd = server_.accept()) {
            net::socket::tcpstream stream(fd);

            session(stream);
        }

        return false;
    }
};

@implementation SKKDistributedUserDictionaryTests

- (void)testMain {
    server server;
    pthread::timer timer(&server, 0);
    SKKDistributedUserDictionary dict;
    SKKCandidateSuite suite;
    MockCompletionHelper helper;

    dict.Initialize("127.0.0.1:10789");

    dict.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());

    XCTAssert(dict.ReverseLookup("not found") == "");

    helper.Initialize("かんじ");

    dict.Complete(helper);

    XCTAssert(helper.Result().empty());

    dict.Register(SKKEntry("かんじ"), SKKCandidate("漢字"));

    dict.Remove(SKKEntry("かんじ"), SKKCandidate("漢字"));

    dict.SetPrivateMode(true);
}

@end
