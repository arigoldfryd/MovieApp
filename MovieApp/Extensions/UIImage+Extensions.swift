//
//  UIImage+Extensions.swift
//  MovieApp
//
//  Created by Ariel on 31/07/2023.
//

import UIKit

extension UIImage {
    func prominentColor() -> UIColor? {
        guard let cgImage = cgImage else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: 1, height: 1, bitsPerComponent: 8,
                                bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        guard let rgba = context?.data?.assumingMemoryBound(to: UInt8.self) else {
            return nil
        }
        
        if rgba[3] > 0 {
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(
                red: CGFloat(rgba[0]) * multiplier,
                green: CGFloat(rgba[1]) * multiplier,
                blue: CGFloat(rgba[2]) * multiplier,
                alpha: alpha
            )
        }
        
        return UIColor(
            red: CGFloat(rgba[0]) / 255.0,
            green: CGFloat(rgba[1]) / 255.0,
            blue: CGFloat(rgba[2]) / 255.0,
            alpha: CGFloat(rgba[3]) / 255.0
        )
    }
}
