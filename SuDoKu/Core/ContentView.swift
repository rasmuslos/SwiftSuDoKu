//
//  ContentView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI

struct ContentView: View {
    @Default(.setupComplete) var setupComplete
    
    var body: some View {
        if setupComplete {
            PlayView()
        } else {
            SetupView()
        }
    }
}

#Preview {
    ContentView()
}
