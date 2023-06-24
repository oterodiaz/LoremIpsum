//
//  PreferencesView.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

struct PreferencesView: View {
    @Bindable var viewModel: ContentViewModel

    @FocusState private var isTextFieldFocused: Bool
    @State private var timer: Timer?

    var body: some View {
            Form {
                Section("Text") {
                    HStack {
                        Text("Text length")
                        Spacer()

                        Text(verbatim:
                                String(format: "state.\(viewModel.lipsum.unit.name).amount"
                                    .localized,
                                viewModel.lipsum.amount)
                            )

                        Stepper("Text length",
                                value: $viewModel.lipsum.amount,
                                in: LipsumGenerator.Unit.minAmount...LipsumGenerator.Unit.maxAmount)
                        .onTapGesture {
                            isTextFieldFocused = false
                        }
                        .labelsHidden()
                    }

                    Toggle("Start with Lorem ipsum",
                           isOn: $viewModel.lipsum.beginWithLoremIpsum)
                }

                Section("Unit") {
                    Picker("Unit of measurement:", selection: $viewModel.lipsum.unit) {
                        ForEach(LipsumGenerator.Unit.allCases, id: \.self) { unit in
                            switch unit {
                            case .words:
                                Text("Words")
                            case .paragraphs:
                                Text("Paragraphs")
                            }
//                            Text(
//                                String(
//                                    format: "state.\(unit.name).amount.without-number"
//                                        .localized,
//                                    viewModel.lipsum.amount
//                                )
//                            )
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }

//            .fixedSize()
//            .contentShape(Rectangle()) // Needed for onTapGesture to work
//            .onTapGesture {
//                isTextFieldFocused = false
//            }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(viewModel: ContentViewModel())
    }
}
