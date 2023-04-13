//
//  Commands.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-21.
//

import SwiftUI

struct NewItemCommandsView: View {
    @EnvironmentObject var contentViewState: ContentViewState

    var body: some View {
        Button("Generate New Text") {
            contentViewState.regenerateText()
        }
        .keyboardShortcut("r")
        .disabled(contentViewState.regenerateTextDisabled)
    }
}

struct PasteboardCommandsView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        Button("Copy All") {
            state.contentViewState.copyText()
        }
        .keyboardShortcut("c", modifiers: [.command, .shift])
    }
}

struct SidebarCommandsView: View {
    @EnvironmentObject var contentViewState: ContentViewState

    private func pickerOptionLabel(for unit: LipsumGenerator.Unit) -> String {
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
        switch (increase, contentViewState.lipsum.unit) {
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
            Picker("Unit of Measurement", selection: $contentViewState.lipsum.unit) {
                ForEach(LipsumGenerator.Unit.allCases, id: \.self) { unit in
                    Text(pickerOptionLabel(for: unit))
                }
            }

            Button("Toggle Unit of Measurement") {
                switch contentViewState.lipsum.unit {
                case .paragraphs:
                    contentViewState.lipsum.unit = .words
                case .words:
                    contentViewState.lipsum.unit = .paragraphs
                }
            }
            .keyboardShortcut(.tab, modifiers: [.command, .control])

            Divider()

            Button(amountOfUnitsButtonLabel(increase: true)) {
                contentViewState.lipsum.amount += 1
            }
            .keyboardShortcut("+")
            .disabled(contentViewState.lipsum.amount >= LipsumGenerator.Unit.maxAmount)

            Button(amountOfUnitsButtonLabel(increase: false)) {
                contentViewState.lipsum.amount -= 1
            }
            .keyboardShortcut("-")
            .disabled(contentViewState.lipsum.amount <= LipsumGenerator.Unit.minAmount)

        }
        .disabled(contentViewState.showingPreferences)
    }
}
