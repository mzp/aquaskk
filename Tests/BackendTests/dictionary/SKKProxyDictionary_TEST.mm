
#include <cassert>
#import <XCTest/XCTest.h>
#import <os/log.h>
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKServer/socketutil.h>
#import <AquaSKKTesting/pthreadutil.h>
#include <errno.h>

@interface SKKProxyDictionaryTests : XCTestCase
@end

void session(int fd, SKKCommonDictionary &dict) {
    net::socket::tcpstream sock(fd);
    unsigned char cmd;

    do {
        cmd = sock.get();
        switch(cmd) {
        case '0': // 切断
            os_log_error(OS_LOG_DEFAULT, "%s: disconnect", __FUNCTION__);
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
            os_log_error(OS_LOG_DEFAULT, "%s: lookup with %s", __FUNCTION__, entry.EntryString().c_str());
            dict.Find(entry, result);

            // 見つかった？
            if(!result.IsEmpty()) {
                os_log_error(OS_LOG_DEFAULT, "%s: Found", __FUNCTION__);
                std::string candidates;
                SKKEncoding::convert_utf8_to_eucj(result.ToString(), candidates);
                sock << '1' << candidates << std::endl;
            } else {
                os_log_error(OS_LOG_DEFAULT, "%s: Not found", __FUNCTION__);
                sock << '4' << word << std::endl;
            }
            sock << std::flush;
        } break;

        default: // 無効なコマンド
            os_log_error(OS_LOG_DEFAULT, "%s: invalid", __FUNCTION__);
            sock << '0' << std::flush;
            break;
        }
    } while(sock.good() && cmd != '0');
    sock.close();
}

void notify_ok(void *param) {
    auto *condition = (pthread::condition *)param;
    pthread::lock lock(*condition);

    condition->signal();
}

// 正常サーバー
void *normal_server(void *param) {
    SKKCommonDictionary dict;

    NSBundle *bundle = [NSBundle bundleForClass:SKKProxyDictionaryTests.class];
    NSString *path = [bundle pathForResource:@"SKK-JISYO" ofType:@"TEST"];
    dict.Initialize(path.UTF8String);

    ushort port = 23000;
    net::socket::tcpserver skkserv(port);

    notify_ok(param);

    while(true) {
        session(skkserv.accept(), dict);
    }

    return 0;
}

// だんまりサーバー
void *dumb_server(void *param) {
    ushort port = 33000;
    net::socket::tcpserver skkserv(port);

    notify_ok(param);

    while(true) {
        skkserv.accept();
    }

    return 0;
}

// おかしなサーバー
void *mad_server(void *param) {
    ushort port = 43000;
    net::socket::tcpserver skkserv(port);

    notify_ok(param);

    while(true) {
        auto fd = skkserv.accept();
        net::socket::tcpstream session(fd);

        session << "やれやれ" << std::endl << std::flush;
    }

    return 0;
}

// 自殺サーバー
void *suicide_server(void *param) {
    ushort port = 53000;
    net::socket::tcpserver skkserv(port);

    notify_ok(param);

    while(true) {
        close(skkserv.accept());
    }

    return 0;
}

// サーバー起動
void spawn_server(void *(*server)(void *param)) {
    pthread_t thread;
    pthread::condition ready;
    pthread::lock lock(ready);

    pthread_create(&thread, 0, server, &ready);
    pthread_detach(thread);

    ready.wait();
}

@implementation SKKProxyDictionaryTests

- (void)testNoExist {
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // 存在しないサーバーテスト
    proxy.Initialize("127.0.0.1:33333");
    [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    proxy.Find(SKKEntry("よi", "い"), suite);
    XCTAssert(suite.IsEmpty());
}

- (void)testNormal {
    spawn_server(normal_server);
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // 正常系テスト
    proxy.Initialize("127.0.0.1:23000");
    [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
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

- (void)testDump {
    spawn_server(dumb_server);
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // だんまりサーバーテスト
    proxy.Initialize("127.0.0.1:33000");
    [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());
}

- (void)testMad {
    spawn_server(mad_server);
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // おかしなサーバーテスト
    proxy.Initialize("127.0.0.1:43000");
    [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());
}

- (void)testSuicide {
    spawn_server(suicide_server);
    SKKProxyDictionary proxy;
    SKKCandidateSuite suite;

    // 自殺サーバーテスト
    proxy.Initialize("127.0.0.1:53000");
    [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];

    proxy.Find(SKKEntry("かんじ"), suite);
    XCTAssert(suite.IsEmpty());
}

@end
