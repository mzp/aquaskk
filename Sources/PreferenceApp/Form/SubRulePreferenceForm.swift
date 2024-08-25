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
    var store: PreferenceStore
    var body: some View {
        Table(rules) {
            TableColumn("Enabled") { rule in
                Toggle("Enable", isOn: Binding(get: {
                    rule.enabled
                }, set: { value in
                    store.set(rule: rule, enabled: value)
                })).labelsHidden()
            }.width(20)
            TableColumn("Name", value: \.name).width(150)
            TableColumn("Description", value: \.ruleDescription)
        }.tableColumnHeaders(.hidden)
    }
}

struct SubRulePreferenceForm: View {
    @EnvironmentObject var store: PreferenceStore

    var body: some View {
        Form {
            Section("System") {
                SubRuleTable(rules: store.availableSystemSubRules, store: store)
            }
            Section("User") {
                SubRuleTable(rules: store.availableUserSubRules, store: store)
            }
        }
    }
}

#Preview {
    SubRulePreferenceForm()
        .environmentObject(PreferenceStore.default)
        .formStyle(.grouped)
}
