
//
//  CandidatePreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct CandidatePreferenceForm: View {
    @EnvironmentObject var store: PreferenceStore

    var body: some View {
        Form {
            Section("Inline") {
                LabeledContent("Max count", content: {
                    Stepper("Count(s)", value: $store.maxCountOfInlineCandidates)
                })
            }

            Section("Window") {
                TextField("Candidate labels", text: $store.candidateWindowLabels)
                // TODO: Font
                Toggle("Put upwoard", isOn: $store.putCandidateWindowUpward)
            }

            Section("Annotation") {
                Toggle("Enable", isOn: $store.enableAnnotation)
            }
        }
    }
}

#Preview {
    CandidatePreferenceForm()
        .formStyle(.grouped)
        .environmentObject(PreferenceStore.default)
}
