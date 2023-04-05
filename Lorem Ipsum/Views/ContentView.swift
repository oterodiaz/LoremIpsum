//
//  ContentView.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    @State private var opacity = 1.0
    @State private var textHeight: CGFloat = .zero
    @State private var copyAllImageSystemName = "doc.on.doc"

    private var navigationTitle: String {
        String.localizedStringWithFormat("state.\(state.unit.name).amount".localized,
                                         state.amount)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Spacer()

                    TextView(text: .constant(state.text),
                             textHeight: $textHeight,
                             isEditable: false)
                    .frame(height: textHeight) // We need to tell the text size to the ScrollView
                    .frame(minWidth: 400, maxWidth: 550)
                    .disabled(state.showingPreferences)

                    Spacer()
                }
                .padding(24)
            }
        }
        .frame(minHeight: 350)
        .navigationTitle(navigationTitle)
        .opacity(opacity)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button() {
                    state.copyText()

                    copyAllImageSystemName = "checkmark"
                    Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { _ in
                        copyAllImageSystemName = "doc.on.doc"
                    }
                } label: {
                    Label("Copy All", systemImage: copyAllImageSystemName)
                }
                .help("Copy All")

                Button() {
                    state.showingPreferences.toggle()
                } label: {
                    Label("Preferences", systemImage: "slider.horizontal.3")
                }
                .help("Preferences")
                .keyboardShortcut(",")
                .disabled(state.showingPreferences)
                .popover(isPresented: $state.showingPreferences, arrowEdge: .bottom) {
                    PreferencesView()
                }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: NSApplication.didBecomeActiveNotification)) { _ in
                    self.opacity = 1.0
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: NSApplication.didResignActiveNotification)) { _ in
                    self.opacity = 0.5
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
