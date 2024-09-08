
#include <cassert>
#include <errno.h>

#import <XCTest/XCTest.h>

#import <AquaSKKCore/SKKCommonDictionary.h>
#import <AquaSKKCore/SKKEncoding.h>
#import <AquaSKKCore/SKKProxyDictionary.h>

@interface SKKProxyDictionaryTests : XCTestCase
@end

void session(int fd, SKKCommonDictionary &dict) {
    net::socket::tcpstream sock(fd);
    unsigned char cmd;

    do {
        cmd = sock.get();
        switch(cmd) {
        case '0': // 切断
            break;

        case '1': { // 検索
            std::string word;
            std::string key;
            sock >> word;
            sock.get();

            SKKEncoding::convert_eucj_to_utf8(word, key);

            SKKCandidateSuite result;
            SKKEntry entry(key);

            // 検索文字列の最後が [a-z] なら『送りあり』
            if(1 < key.size() && 0x7f < (unsigned)key[0] && std::isalpha(key[key.size() - 1])) {
                entry = SKKEntry(key, "dummy");
            }

            dict.Find(entry, result);

            // 見つかった？
            if(!result.IsEmpty()) {
                std::string candidates;
                SKKEncoding::convert_utf8_to_eucj(result.ToString(), candidates);
                sock << '1' << candidates << std::endl;
            } else {
                sock << '4' << word << std::endl;
            }
            sock << std::flush;
        } break;

        default: // 無効なコマンド
            sock << '0' << std::flush;
            break;
        }
    } while(sock.good() && cmd != '0');
    sock.close();
}

// 正常サーバー
void *normal_server(NSCondition *condition) {
    SKKCommonDictionary dict;

    NSBundle *bundle = [NSBundle bundleForClass:SKKProxyDictionaryTests.class];
    NSString *path = [bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"];
    dict.Initialize(path.UTF8String);

    ushort port = 23000;
    net::socket::tcpserver skkserv(port);

    [condition signal];

    while(true) {
        session(skkserv.accept(), dict);
    }

    return 0;
}

// だんまりサーバー
void *dumb_server(NSCondition *condition) {
    ushort port = 33000;
    net::socket::tcpserver skkserv(port);

    [condition signal];

    while(true) {
        skkserv.accept();
    }

    return 0;
}

// おかしなサーバー
void *mad_server(NSCondition *condition) {
    ushort port = 43000;
    net::socket::tcpserver skkserv(port);

    [condition signal];

    while(true) {
        auto fd = skkserv.accept();
        net::socket::tcpstream session(fd);

        session << "やれやれ" << std::endl << std::flush;
    }

    return 0;
}

// 自殺サーバー
void *suicide_server(NSCondition *condition) {
    ushort port = 53000;
    net::socket::tcpserver skkserv(port);

    [condition signal];

    while(true) {
        close(skkserv.accept());
    }

    return 0;
}

// サーバー起動
void spawn_server(void *(*server)(NSCondition *param)) {
    NSCondition *condition = [[NSCondition alloc] init];
    [NSThread detachNewThreadWithBlock:^{
      server(condition);
    }];
    [condition wait];
}

@implementation SKKProxyDictionaryTests

- (void)setUp {
    spawn_server(normal_server);
    spawn_server(dumb_server);
    spawn_server(mad_server);
    spawn_server(suicide_server);
}

- (void)testNone {
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // 存在しないサーバーテスト
    proxy.Initialize("127.0.0.1:33333");

    proxy.Find(SKKEntry("よi", "い"), suite);
    XCTAssert(suite.IsEmpty());
}

- (void)testNormal {
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;
    // 正常系テスト
    proxy.Initialize("127.0.0.1:23000");

    proxy.Find(SKKEntry("よi", "い"), suite);
    XCTAssert(suite.ToString() == "/良/好/酔/善/");

    suite.Clear();
    proxy.Find(SKKEntry("NOT-EXIST", "i"), suite);
    XCTAssert(suite.IsEmpty());

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.ToString() == "/漢字/寛治/官寺/");

    suite.Clear();

    proxy.Find(SKKEntry("NOT-EXIST"), suite);
    XCTAssert(suite.IsEmpty());
}

- (void)testNoRespond {
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;
    // だんまりサーバーテスト
    proxy.Initialize("127.0.0.1:33000");

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());

    // おかしなサーバーテスト
    proxy.Initialize("127.0.0.1:43000");

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());
}

- (void)testCrash {
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // 自殺サーバーテスト
    proxy.Initialize("127.0.0.1:53000");

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());
}

@end
