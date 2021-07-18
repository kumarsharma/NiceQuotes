//
//  UIColor+Hex.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 21/01/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //gets hex string from a Color object
    func toHex() -> NSString {
        
        var red, green, blue, alphas: CGFloat
        red=0;green=0;blue=0;alphas=0
        getRed(&red, green: &green, blue: &blue, alpha: &alphas)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return NSString(format: "#%06x", rgb)
    }
    
    convenience init(hexString: NSString) {
        
        let hexString: NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        let scanner = Scanner.init(string: hexString as String)
        if hexString.hasPrefix("#") {
            scanner.scanLocation=1
        }
        var color: UInt64=0
        scanner.scanHexInt64(&color)
        let mask=0x000000FF
        let rred=Int(color>>16) & mask
        let ggren=Int(color>>8) & mask
        let bblue=Int(color) & mask
        
        let red2 = CGFloat(rred)/255.0
        let green2=CGFloat(ggren)/255.0
        let blue2=CGFloat(bblue)/255.0
        
        self.init(red: red2, green: green2, blue: blue2, alpha: 1)
    }
}
