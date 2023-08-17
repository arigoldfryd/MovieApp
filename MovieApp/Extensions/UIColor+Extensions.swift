//
//  UIColor+Extensions.swift
//  MovieApp
//
//  Created by Ariel on 28/07/2023.
//

import SwiftUI

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }

        guard formattedHex.count == 6 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func getHigherContrast() -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        // Get the RGB components of the color
        getRed(&r, green: &g, blue: &b, alpha: &a)

        // Calculate the YIQ value
        let yiq = ((r * 255 * 299) + (g * 255 * 587) + (b * 255 * 114)) / 1000

        // Return black or white based on contrast
        return yiq >= 128 ?  UIColor.black : UIColor.white
    }
}
