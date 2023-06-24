//
//  Commands.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-21.
//

import SwiftUI

struct NewItemCommandsView: View {
    @Environment(AppState.self) var appState

    var body: some View {
        Button("Generate New Text") {
            appState.contentViewModel.regenerateText()
        }
        .keyboardShortcut("r")
        .disabled(appState.contentViewModel.regenerateTextDisabled)
    }
}

struct PasteboardCommandsView: View {
    @Environment(AppState.self) var appState

    var body: some View {
        Button("Copy") {
            appState.contentViewModel.copyText()
        }
        .keyboardShortcut("c", modifiers: [.command, .shift])
    }
}

struct SidebarCommandsView: View {
    @Environment(AppState.self) var appState

    private func amountOfUnitsButtonLabel(increase: Bool) -> String {
        switch (increase, appState.contentViewModel.lipsum.unit) {
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
        Button("Toggle Unit of Measurement") {
            switch appState.contentViewModel.lipsum.unit {
            case .paragraphs:
                appState.contentViewModel.lipsum.unit = .words
            case .words:
                appState.contentViewModel.lipsum.unit = .paragraphs
            }
        }
        .keyboardShortcut(.tab, modifiers: [.command, .control])

        Button(amountOfUnitsButtonLabel(increase: true)) {
            appState.contentViewModel.lipsum.amount += 1
        }
        .keyboardShortcut("+", modifiers: [.command, .shift])
        .disabled(appState.contentViewModel.lipsum.amount >= LipsumGenerator.Unit.maxAmount)

        Button(amountOfUnitsButtonLabel(increase: false)) {
            appState.contentViewModel.lipsum.amount -= 1
        }
        .keyboardShortcut("-", modifiers: [.command, .shift])
        .disabled(appState.contentViewModel.lipsum.amount <= LipsumGenerator.Unit.minAmount)
    }
}

fileprivate struct UnitPicker: View {
    @Bindable var appState: AppState

    var body: some View {
        Picker("Unit of Measurement", selection: $appState.contentViewModel.lipsum.unit) {
            ForEach(LipsumGenerator.Unit.allCases, id: \.self) { unit in
                Text(pickerOptionLabel(for: unit))
            }
        }
    }

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
}
