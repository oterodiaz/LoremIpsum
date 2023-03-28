//
//  StringExtension.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-19.
//

import Foundation

extension String {
    var localized: String {
        String(localized: String.LocalizationValue(stringLiteral: self))
    }
}
