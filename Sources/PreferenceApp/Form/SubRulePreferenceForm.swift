//
//  SubRulePreferenceForm.swift
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

import AquaSKKService
import SwiftUI

extension SubRule: @retroactive Identifiable {
    public var id: String { path }
}

struct SubRuleTable: View {
    var rules: [SubRule]
    var storage: PreferenceStore
    var body: some View {
        Table(rules) {
            TableColumn("Enabled") { rule in
                Toggle("Enable", isOn: Binding(get: {
                    rule.enabled
                }, set: { value in
                    storage.set(rule: rule, enabled: value)
                })).labelsHidden()
            }.width(20)
            TableColumn("Name", value: \.name).width(150)
            TableColumn("Description", value: \.ruleDescription)
        }.tableColumnHeaders(.hidden)
    }
}

struct SubRulePreferenceForm: View {
    @ObservedObject private var storage = PreferenceStore.default

    var body: some View {
        Form {
            Section("System") {
                SubRuleTable(rules: storage.availableSystemSubRules, storage: storage)
            }
            Section("User") {
                SubRuleTable(rules: storage.availableUserSubRules, storage: storage)
            }
        }
    }
}

#Preview {
    SubRulePreferenceForm().formStyle(.grouped)
}
