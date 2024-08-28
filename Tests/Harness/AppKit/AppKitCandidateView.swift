//
//  AppKitCandidateView.swift
//  Harness
//
//  Created by mzp on 8/27/24.
//

import AquaSKKUI
import SwiftUI

struct AppKitCandidateView: NSViewRepresentable {
    func makeNSView(context _: Context) -> CandidateView {
        return CandidateView()
    }

    func updateNSView(_ nsView: CandidateView, context _: Context) {
        nsView.prepare(with: NSFont.systemFont(ofSize: 16), labels: "ABCDEFG")
        nsView.setPage(.init(location: 2, length: 3))
        nsView.setCandidates(["A", "B", "C", "D", "E"], selectedIndex: 0)
    }
}

#Preview {
    AppKitCandidateView()
}
