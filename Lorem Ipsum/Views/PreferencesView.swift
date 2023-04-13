//
//  PreferencesView.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var contentViewState: ContentViewState
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var timer: Timer?

    var body: some View {
        let stepperBinding = Binding(
            get: { contentViewState.lipsum.amount },
            set: { newValue in
                if isTextFieldFocused {
                    isTextFieldFocused = false
                }

                contentViewState.lipsum.amount = newValue
            }
        )

        let pickerBinding = Binding(
            get: { contentViewState.lipsum.unit },
            set: { newValue in
                if isTextFieldFocused {
                    isTextFieldFocused = false
                }

                contentViewState.lipsum.unit = newValue
            }
        )

        return (
            Form {
                Section {
                    HStack {
                        TextField("Length of the text:",
                                  value: $contentViewState.lipsum.amount,
                                  format: .number)
                            .textFieldStyle(.roundedBorder)
                            .monospacedDigit()
                            .focused($isTextFieldFocused)
                            .onSubmit { isTextFieldFocused = false }
                            .frame(width: 48)

                        Stepper("Length of the text:",
                                value: stepperBinding,
                                in: LipsumGenerator.Unit.minAmount...LipsumGenerator.Unit.maxAmount)

                        Picker("Unit of measurement:", selection: pickerBinding) {
                            ForEach(LipsumGenerator.Unit.allCases, id: \.self) { unit in
                                Text(
                                    String(
                                        format: "state.\(unit.name).amount.without-number"
                                            .localized,
                                        contentViewState.lipsum.amount
                                    )
                                )
                            }
                        }
                    }
                    .labelsHidden()
                }

                Divider()

                Section() {
                    Toggle("Begin with *Lorem ipsum*",
                           isOn: $contentViewState.lipsum.beginWithLoremIpsum)
                }
            }
            .fixedSize()
            .padding()
            .contentShape(Rectangle()) // Needed for onTapGesture to work
            .onTapGesture {
                isTextFieldFocused = false
            }
        )
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(AppState())
    }
}
