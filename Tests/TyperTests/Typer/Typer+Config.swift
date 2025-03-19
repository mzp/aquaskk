//
//  Typer+Config.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/19.
//
internal import AquaSKKTesting

extension TyperConfig {
    static func defaults(annotation: Bool = true) -> TyperConfig {
        let object = TyperConfig.newInstannce()!
        object.SetEnableAnnotation(annotation)
        return object
    }
}
