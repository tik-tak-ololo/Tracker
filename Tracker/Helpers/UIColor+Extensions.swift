//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let red = CGFloat((value >> 16) & 0xFF) / 255
        let green = CGFloat((value >> 8) & 0xFF) / 255
        let blue = CGFloat(value & 0xFF) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    var hexString: String {
        guard let components = cgColor.components else {
            return "#000000"
        }

        let red = Int((components[safe: 0] ?? 0) * 255)
        let green = Int((components[safe: 1] ?? 0) * 255)
        let blue = Int((components[safe: 2] ?? 0) * 255)

        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}


