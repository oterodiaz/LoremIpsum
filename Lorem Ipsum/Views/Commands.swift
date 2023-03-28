//
//  Commands.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-21.
//

import SwiftUI

struct NewItemCommandsView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        Button("Generate New Text") {
            state.generateText()
        }
        .keyboardShortcut("r")
        .disabled(state.unit == .words && state.beginWithLoremIpsum && state.amount <= 17)
    }
}

struct PasteboardCommandsView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        Button("Copy All") {
            state.copyText()
        }
        .keyboardShortcut("c", modifiers: [.command, .shift])
    }
}

struct SidebarCommandsView: View {
    @EnvironmentObject var state: AppState

    private func pickerOptionLabel(for unit: Unit) -> String {
        switch unit {
        case .paragraphs:
            return String(localized: "Paragraphs",
                          comment: "Unit to measure the text's length (i.e. 20 paragraphs)")
        case .words:
            return String(localized: "Words",
                          comment: "Unit to measure the text's length (i.e. 20 words)")
        }
    }

    private func amountOfUnitsButtonLabel(increase: Bool) -> String {
        switch (increase, state.unit) {
        case (true, .paragraphs):
            return String(localized: "Show More Paragraphs")
        case (true, .words):
            return String(localized: "Show More Words")
        case (false, .paragraphs):
            return String(localized: "Show Less Paragraphs")
        case (false, .words):
            return String(localized: "Show Less Words")
        }
    }

    var body: some View {
        Group {
            Picker("Unit of Measurement", selection: $state.unit) {
                ForEach(Unit.allCases, id: \.self) { unit in
                    Text(pickerOptionLabel(for: unit))
                }
            }

            Button("Toggle Unit of Measurement") {
                switch state.unit {
                case .paragraphs:
                    state.unit = .words
                case .words:
                    state.unit = .paragraphs
                }
            }
            .keyboardShortcut(.tab, modifiers: [.command, .control])

            Divider()

            Button(amountOfUnitsButtonLabel(increase: true)) {
                state.setAmountWithDelay(to: state.amount + 1)
            }
            .keyboardShortcut("+")
            .disabled(state.amount == Unit.maxAmount)

            Button(amountOfUnitsButtonLabel(increase: false)) {
                state.setAmountWithDelay(to: state.amount - 1)
            }
            .keyboardShortcut("-")
            .disabled(state.amount == Unit.minAmount)

        }
        .disabled(state.showingPreferences)
    }
}
