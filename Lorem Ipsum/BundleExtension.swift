//
//  BundleExtension.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-28.
//

import Foundation

extension Bundle {
    func readFile(_ file: String) -> String {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let contents = try? String(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        return contents
    }
}
