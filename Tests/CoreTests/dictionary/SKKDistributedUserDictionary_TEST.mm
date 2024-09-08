#import <AquaSKKCore/SKKDistributedUserDictionary.h>
#import <AquaSKKCore/pthreadutil.h>
#import <AquaSKKCore/socketutil.h>
#import <XCTest/XCTest.h>

#include "stringutil.h"
#import <AquaSKKTesting/MockCompletionHelper.h>

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

@interface Server : NSObject {
    net::socket::tcpserver server_;
}
@end

@implementation Server

- (instancetype)init {
    self = [super init];
    if(self) {
        server_.open(10789);
    }
    return self;
}

- (void)run:(id)sender {
    while(int fd = server_.accept()) {
        net::socket::tcpstream stream(fd);
        session(stream);
    }
}

@end

@implementation SKKDistributedUserDictionaryTests

- (void)testMain {
    Server *server = [[Server alloc] init];

    [NSThread detachNewThreadSelector:@selector(run:) toTarget:server withObject:nil];
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
