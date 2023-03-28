//
//  Unit.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-20.
//

import Foundation

enum Unit: CaseIterable {
    case paragraphs, words

    static let minAmount = 1
    static let maxAmount = 999

    var defaultAmount: Int {
        switch self {
        case .paragraphs:
            return 3
        case .words:
            return 50
        }
    }

    var name: String {
        name(of: self)
    }
    
    private func name(of variant: Unit) -> String {
        switch self {
        case .paragraphs:
            return "paragraphs"
        case .words:
            return "words"
        }
    }
}

