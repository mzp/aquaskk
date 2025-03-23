//
//  SKKServeTests.swift
//  TyperTests
//
//  Created by mzp on 2025/03/22.
//

import AquaSKKService
import Testing
internal import AquaSKKTesting

struct SKKServeTests {
    @Test func lanuch() async {
        let configuration = try! BundledServerConfiguration(bundle: Bundle.main)
        let defaults = AISUserDefaults(serverConfiguration: configuration)
        defaults.standard.set(true, forKey: SKKUserDefaultKeys.enable_skkserv)
        defaults.standard.set(11178, forKey: SKKUserDefaultKeys.skkserv_port)
        defaults.saveChanges()

        let session = Typer.Session()
        await session.run { typer in
            typer.reloadUserDefaults()

            // TODO: Check connection
        }

        defaults.standard.set(false, forKey: SKKUserDefaultKeys.enable_skkserv)
        defaults.saveChanges()
        await session.run { typer in
            typer.reloadUserDefaults()

            // TODO: Check connection
        }
    }
}
