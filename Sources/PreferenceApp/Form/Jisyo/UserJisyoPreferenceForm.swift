//
//  UserJisyoPreferenceForm.swift
//  Preferences
//
//  Created by mzp on 8/10/24.
//

import AquaSKKService
import SwiftUI

struct UserJisyoPreferenceForm: View {
    @ObservedObject private var storage = PreferenceStorage.default
    @State private var isPresenting: Bool = false

    var body: some View {
        FilePathTextField("Location", location: $storage.userJisyoPath)
    }
}

#Preview {
    UserJisyoPreferenceForm()
}
