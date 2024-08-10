//
//  ContentView.swift
//  AquaSKK-Preferences
//
//  Created by mzp on 7/31/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gearshape") {
                GeneralPreferenceForm()
            }
            Tab("Extension", systemImage: "puzzlepiece.extension") {
                SubRulePreferenceForm()
            }
            Tab("Completion", systemImage: "rectangle.and.pencil.and.ellipsis") {
                CompletionPreferenceForm()
            }
            Tab("Candidate Window", systemImage: "macwindow") {
                CandidatePreferenceForm()
            }
            Tab("Dictionary", systemImage: "book") {
                JisyoPreferenceForm()
            }
            Tab("Compatibility", systemImage: "wrench.adjustable") {
                // TODO: Compatibily/Per-app workaround setting
                Text("TBD")
            }
            Tab("Other", systemImage: "square.2.layers.3d") {
                OtherPreferenceForm()
            }
            Tab("About", systemImage: "info.circle") {
                AboutForm()
            }
        }
        .navigationTitle("AquaSKK Preferences")
        .formStyle(.grouped)
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
