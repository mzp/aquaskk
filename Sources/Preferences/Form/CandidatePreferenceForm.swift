
//
//  CandidatePreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import AquaSKKService
import SwiftUI

struct CandidatePreferenceForm: View {
    @ObservedObject private var storage = PreferenceStorage()

    var body: some View {
        Form {
            Section("Inline") {
                LabeledContent("Max count", content: {
                    Stepper("Count(s)", value: $storage.maxCountOfInlineCandidates)
                })
            }

            Section("Window") {
                TextField("Candidate labels", text: $storage.candidateWindowLabels)
                // TODO: Font
                Toggle("Put upwoard", isOn: $storage.putCandidateWindowUpward)
            }

            Section("Annotation") {
                Toggle("Enable", isOn: $storage.enableAnnotation)
            }
        }
    }
}

#Preview {
    CandidatePreferenceForm().formStyle(.grouped)
}
