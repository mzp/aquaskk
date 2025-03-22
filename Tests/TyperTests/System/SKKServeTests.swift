//
//  SKKServeTests.swift
//  TyperTests
//
//  Created by mzp on 2025/03/22.
//

import AquaSKKService
import Testing

struct SKKServeTests {
    @Test func test() async {
        let session = Typer.Session()
        await session.run { typer in
            UserDefaults.standard.set(true, forKey: SKKUserDefaultKeys.enable_skkserv)
            typer.reloadUserDefaults()
        }
    }
}
