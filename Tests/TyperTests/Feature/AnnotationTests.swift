//
//  AnnotationTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/21.
//

import Testing

struct AnnotationTests {
    @Test func annotation() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            let annotation = typer.annotation
            #expect(annotation.entry == "今日")
            #expect(annotation.visible == true)
        }
    }

    @Test func enablement() async {
        let session = Typer.Session()
        await session.run(config: .defaults(annotation: false)) { typer in
            await typer.type(text: "Kyou ")
            let annotation = typer.annotation
            #expect(annotation.visible == false)
        }
    }
}
