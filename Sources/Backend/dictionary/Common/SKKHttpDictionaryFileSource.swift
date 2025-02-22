//
//  SKKHttpDictionaryFileSource.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import AquaSKKLogging
import Foundation
import OSLog

public class SKKHttpDictionaryFileSource: SKKDictionarySourceFileProtocol {
    var path: String?
    let session: URLSession
    public init() {
        var configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }

    var url: URL?
    ///
    /// 引数の形式は "host:port url path" とする。":port" は省略化。
    ///
    /// 例)
    ///
    /// "openlab.jp /skk/skk/dic/SKK-JISYO.L /path/to/the/SKK-JISYO.L"
    ///
    public func initialize(location: String) {
        let array = location.split(separator: " ", maxSplits: 3)
        guard array.count == 3 else {
            Logger.skkBackend.error("\(#function, privacy: .public): invalid location: \(location, privacy: .private)")
            return
        }
        url = URL(string: "https://\(array[0])/\(array[1])")
        path = String(array[2])
    }

    public var interval: TimeInterval {
        60 * 60 * 6
    }

    public var timeout: TimeInterval {
        3
    }

    public func refresh() async throws {
        guard let url = url else {
            Logger.skkBackend.error("\(#function, privacy: .public): url is nil")
            return
        }
        guard let path = path else {
            Logger.skkBackend.error("\(#function, privacy: .public): path is nil")
            return
        }
        let (data, response) = try await session.data(for: .init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout))
        if let response = response as? HTTPURLResponse {
            if response.statusCode != 200 {
                Logger.skkBackend.error("\(#function, privacy: .public): status code is \(response.statusCode, privacy: .public)")
                return
            }
            if response.expectedContentLength != data.count {
                Logger.skkBackend.error("\(#function, privacy: .public): expected content length is \(response.expectedContentLength, privacy: .public), but actual is \(data.count, privacy: .public)")
                return
            }
        }
        Logger.skkBackend.log("\(#function, privacy: .public): Wrote to \(path, privacy: .private)")
        try data.write(to: URL(fileURLWithPath: path))
    }
}
