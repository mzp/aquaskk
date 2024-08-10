//
//  AboutForm.swift
//  Preferences
//
//  Created by mzp on 8/7/24.
//

import SwiftUI

struct AboutForm: View {
    var body: some View {
        VStack(spacing: 10) {
            // TODO: AppIcon Image
            Section {
                VStack(spacing: 0) {
                    Text("AquaSKK").font(.title)
                    Text("swifty")
                        .foregroundStyle(.secondary)
                }
            }
            Section {
                VStack(spacing: 0) {
                    Text("Copyright © 2002-2005, phonohawk ")
                    Text("Copyright © 2005-2013, AquaSKK Project(t.suwa)")
                    Text("Copyright © 2014-, Codefirst")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    AboutForm()
}
