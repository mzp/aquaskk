#import <XCTest/XCTest.h>
#import <AquaSKKBackend/socketutil.h>

@interface SocketUtilTests : XCTestCase
@end

@implementation SocketUtilTests

- (void)testMain {
    net::socket::endpoint ep1("localhost", "http");
    XCTAssert(ep1.node() == "localhost" && ep1.service() == "http");

    net::socket::endpoint ep2("localhost", 80);
    XCTAssert(ep2.node() == "localhost" && ep2.service() == "80");

    ep1.parse("localhost:80", "8080");
    XCTAssert(ep1.node() == "localhost" && ep1.service() == "80");

    ep1.parse("localhost", "8080");
    XCTAssert(ep1.node() == "localhost" && ep1.service() == "8080");
}

@end
