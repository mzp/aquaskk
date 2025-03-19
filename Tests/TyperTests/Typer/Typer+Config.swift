//
//  Typer+Config.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/19.
//
internal import AquaSKKTesting

extension TyperConfig {
    static func defaults(annotation: Bool = true, suppressNewlineOnCommit: Bool = true) -> TyperConfig {
        let config = TyperConfig.newInstannce()!
        config.SetEnableAnnotation(annotation)
        config.SetSuppressNewlineOnCommit(suppressNewlineOnCommit)
        return config
    }
}
