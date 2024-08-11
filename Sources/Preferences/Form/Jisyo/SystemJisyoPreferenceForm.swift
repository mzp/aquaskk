//
//  SystemJisyoPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/10/24.
//

import AquaSKKService
import SwiftUI

extension Jisyo: @retroactive Identifiable {
    public var id: String { location }
}

struct SystemJisyoPreferenceForm: View {
    var jisyo: Jisyo
    var selected: Bool
    @ObservedObject var storage: PreferenceStorage
    @State var isPresenting: Bool = false

    var enabled: Binding<Bool> {
        Binding(
            get: { jisyo.enabled },
            set: { storage.set(jisyo: jisyo, enabled: $0) }
        )
    }

    var location: Binding<String> {
        Binding(
            get: { jisyo.location },
            set: { storage.set(jisyo: jisyo, location: $0) }
        )
    }

    var jisyoType: Binding<Int> {
        Binding(
            get: { jisyo.type.rawValue },
            set: { storage.set(jisyo: jisyo, type: $0) }
        )
    }

    static let allJisyoType: [JisyoType] = [
        .common,
        .autoUpdate,
        .proxy,
        .kotoeri,
        .gadget,
        .commonUTF8,
    ]

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(jisyo.displayLocation).font(.headline)
                Text(jisyo.displayType).font(.subheadline)
            }.frame(width: 200, alignment: .leading)
            if selected {
                Button("Components", systemImage: "ellipsis.circle") {
                    isPresenting = true
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .popover(isPresented: $isPresenting, content: {
                    Form {
                        FilePathTextField("Location", location: location)
                        Picker("Dictionary Type", selection: jisyoType) {
                            ForEach(Self.allJisyoType, id: \.rawValue) { type in
                                Text(Jisyo.displayName(for: type)).tag(type.rawValue)
                            }
                        }
                    }
                    .padding(10)
                    .frame(width: 300)
                })
            }
            Spacer()
            Toggle("Enabled", isOn: enabled)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding(3)
    }
}

#Preview {
    SystemJisyoPreferenceForm(
        jisyo: .init(type: .common, location: "SKK-JISYO.L", enabled: true),
        selected: true,
        storage: .default
    )
}
