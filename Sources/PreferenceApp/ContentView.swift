//
//  ContentView.swift
//  AquaSKK-Preferences
//
//  Created by mzp on 7/31/24.
//

import SwiftUI
import AquaSKKService

enum FormType {
    case general
    case subrule
    case completion
    case candidate
    case dictionary
    case compatibility
    case other
    case about
}

struct ContentView: View {
    @State var selection: FormType = .general
    @ObservedObject var store : PreferenceStore = .default

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: FormType.general) {
                    Label("General", systemImage: "gearshape")
                }
                NavigationLink(value: FormType.subrule) {
                    Label("Extension", systemImage: "puzzlepiece.extension")
                }

                NavigationLink(value: FormType.completion) {
                    Label("Completion", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
                NavigationLink(value: FormType.candidate) {
                    Label("Candidate Window", systemImage: "macwindow")
                }
                NavigationLink(value: FormType.dictionary) {
                    Label("Dictionary", systemImage: "book")
                }
                NavigationLink(value: FormType.compatibility) {
                    Label("Compatibility", systemImage: "wrench.adjustable")
                }
                NavigationLink(value: FormType.other) {
                    Label("Other", systemImage: "square.2.layers.3d")

                }
                NavigationLink(value: FormType.about) {
                    Label("About", systemImage: "info.circle")
                }
            }
        } detail: {
            switch selection {
            case .general:
                GeneralPreferenceForm()
            case .subrule:
                SubRulePreferenceForm()
            case .completion:
                CompletionPreferenceForm()
            case .candidate:
                CandidatePreferenceForm()
            case .dictionary:
                JisyoPreferenceForm()
            case .compatibility:
                Text("TBD")
            case .other:
                OtherPreferenceForm()
            case .about:
                AboutForm()
            }
        }
        .formStyle(.grouped)
        .environmentObject(store)
    }
}

#Preview {
    ContentView()
}
