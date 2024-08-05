//
//  SupervisorMonitor.swift
//  AquaSKKCore
//
//  Created by mzp on 8/3/24.
//

import AquaSKKIM
import SwiftUI

struct SupervisorMonitor: View {
    var supervisor: SKKSupervisor

    var body: some View {
        Form {
            LabeledContent("Dictionary") {
                VStack(alignment: .leading) {
                    ForEach(self.dictionaryType) { entry in
                        HStack {
                            Text("\(entry.type): \(entry.name)")
                        }
                    }
                }
            }
            LabeledContent("Reload") {
                HStack {
                    Button("Components", systemImage: "arrow.circlepath") {
                        supervisor.reloadDictionarySet()
                    }

                    Button("Blacklist", systemImage: "exclamationmark.octagon.fill") {
                        supervisor.reloadBlacklistApps()
                    }
                    Button("Blacklist", systemImage: "gear") {
                        supervisor.reloadUserDefaults()
                    }

                    Button("Dictionary", systemImage: "books.vertical") {
                        supervisor.reloadDictionarySet()
                    }
                }
            }
        }
    }

    struct DictionaryType: Identifiable {
        var type: Int
        var name: String

        var id: Int { type }
    }

    var dictionaryType: [DictionaryType] {
        let types = supervisor.createDictionaryTypes() ?? []
        return types.map { dictionary in
            let type = dictionary["type"] as! Int
            let name = dictionary["name"] as! String
            return DictionaryType(type: type, name: name)
        }.sorted(by: { $0.type < $1.type })
    }
}

class SupervisorForPreview: SKKSupervisor {
    func reloadBlacklistApps() {}

    func reloadUserDefaults() {}

    func reloadDictionarySet() {}

    func reloadComponents() {}

    func createDictionaryTypes() -> [[AnyHashable: Any]]! {
        [["type": 1 as Any, "name": "foo" as Any]]
    }
}

#Preview {
    SupervisorMonitor(supervisor: SupervisorForPreview())
}
