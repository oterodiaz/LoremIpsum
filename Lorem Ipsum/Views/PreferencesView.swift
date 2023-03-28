//
//  PreferencesView.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var state: AppState
    
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        let stepperBinding = Binding(
            get: { state.amount },
            set: {
                if isTextFieldFocused {
                    isTextFieldFocused = false
                }

                state.setAmountWithDelay(to: $0)
            }
        )

        let pickerBinding = Binding(
            get: { state.unit },
            set: {
                if isTextFieldFocused {
                    isTextFieldFocused = false
                }

                state.unit = $0
            }
        )

        return (
            Form {
                Section {
                    HStack {
                        TextField("Length of the text:", value: $state.amount, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .monospacedDigit()
                            .focused($isTextFieldFocused)
                            .onSubmit { isTextFieldFocused = false }
                            .frame(width: 48)

                        Stepper("Length of the text:",
                                value: stepperBinding,
                                in: Unit.minAmount...Unit.maxAmount)

                        Picker("Unit of measurement:", selection: pickerBinding) {
                            ForEach(Unit.allCases, id: \.self) { unit in
                                Text(
                                    String(
                                        format: "state.\(unit.name).amount.without-number"
                                            .localized,
                                        state.amount
                                    )
                                )
                            }
                        }
                    }
                    .labelsHidden()
                }

                Divider()

                Section() {
                    Toggle("Begin with *Lorem ipsum*", isOn: $state.beginWithLoremIpsum)
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
