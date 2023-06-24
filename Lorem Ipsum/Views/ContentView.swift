//
//  ContentView.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

struct ContentView: View {
    var viewModel: ContentViewModel

    @State private var textHeight: CGFloat = .zero
    @State private var copyAllImageSystemName = "doc.on.doc"

    private var navigationTitle: String {
        String.localizedStringWithFormat(
            "state.\(viewModel.lipsum.unit.name).amount".localized,
            viewModel.lipsum.amount
        )
    }

    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Text(verbatim: viewModel.text)
                                .font(.system(.body, design: .serif))
                                .textSelection(.enabled)
                                .frame(minWidth: 400, maxWidth: 550)

                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                }
                .animation(.default, value: viewModel.text)
                .navigationTitle(navigationTitle)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomOrnament) {
                        Button {
                            viewModel.lipsum.amount -= 1
                        } label: {
                            Label("Decrease", systemImage: "minus")
                        }
                        .help("Decrease")
                        .disabled(viewModel.lipsum.amount <= LipsumGenerator.Unit.minAmount)

                        Button {
                            switch viewModel.lipsum.unit {
                            case .paragraphs:
                                viewModel.lipsum.unit = .words
                            case .words:
                                viewModel.lipsum.unit = .paragraphs
                            }
                        } label: {
                            Label("Toggle Unit", systemImage: "arrow.left.arrow.right")
                        }
                        .help("Toggle Unit")

                        Button {
                            viewModel.lipsum.amount += 1
                        } label: {
                            Label("Increase", systemImage: "plus")
                        }
                        .help("Increase")
                        .disabled(viewModel.lipsum.amount >= LipsumGenerator.Unit.maxAmount)
                    }
                }
            }
            .tabItem {
                Label("Text Generator", systemImage: "text.alignleft")
            }

            NavigationStack {
                PreferencesView(viewModel: viewModel)
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .onChange(of: viewModel.lipsum) {
            viewModel.timer?.invalidate()

            viewModel.timer = Timer
                .scheduledTimer(withTimeInterval: 0.15, repeats: false) { _ in
                    viewModel.regenerateText()
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
