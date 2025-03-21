///
///  Typer+Config.swift
///  AquaSKK
///
///  Created by mzp on 2025/03/19.
///
public extension TyperConfig {
    static func defaults(
        annotation: Bool = true,
        dynamicCompletion: Bool = true,
        suppressNewlineOnCommit: Bool = true,
        inlineBackSpaceImpliesCommit: Bool = false,
        handleRecursiveEntryAsOkuri: Bool = false
    ) -> TyperConfig {
        let config = TyperConfig.newInstannce()!
        config.SetEnableAnnotation(annotation)
        config.SetEnableDynamicCompletion(dynamicCompletion)
        config.SetSuppressNewlineOnCommit(suppressNewlineOnCommit)
        config.SetInlineBackSpaceImpliesCommit(inlineBackSpaceImpliesCommit)
        config.SetHandleRecursiveEntryAsOkuri(handleRecursiveEntryAsOkuri)
        return config
    }
}
