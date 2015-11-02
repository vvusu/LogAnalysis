//
//  NSColor+Expanded.swift
//  Log Analysis
//
//  Created by vvusu on 10/31/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

extension NSColor {
    class func fromHex(hexColor: String) -> NSColor {
        var hex = String()
        if hexColor.hasPrefix("#") {
            hex = hexColor[1]
        } else {
            hex = hexColor
        }
        
        func hexToCGFloat(color: String) -> CGFloat {
            var result: CUnsignedInt = 0
            let scanner: NSScanner = NSScanner(string: color)
            scanner.scanHexInt(&result)
            let colorValue: CGFloat = CGFloat(result)
            return colorValue / 255
        }
        
        let redComponent = hexToCGFloat(hex[0...1]),
        greenComponent = hexToCGFloat(hex[2...3]),
        blueComponent = hexToCGFloat(hex[4...5])
        
        let color = NSColor(calibratedRed: redComponent, green: greenComponent, blue: blueComponent, alpha: 1)
        
        return color
    }
    
    var hexString: String {
        let red = UInt(round(self.redComponent * 0xFF))
        let green = UInt(round(self.greenComponent * 0xFF))
        let blue = UInt(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
    
    func getHexString() -> String {
        return String(format:"%0.6X",self.rgbHex())
    }
    
    func rgbHex() -> UInt32 {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if !isRGB(&r, green: &g, blue: &b, alpha: &a) {
            return 0
        }
        
        r = min(max(self.red(), 0.0), 1.0)
        g = min(max(self.green(), 0.0), 1.0)
        b = min(max(self.blue(), 0.0), 1.0)
        let num: Float = 255.0
        let rgb: UInt32 = UInt32(((Int(roundf(Float(r) * num)) << 16))
            | ((Int(roundf(Float(g) * num)) << 8))
            | ((Int(roundf(Float(b) * num)))))
        return rgb
    }
    
    func red() -> CGFloat {
        let c = CGColorGetComponents(self.CGColor)
        return c[0]
    }
    func green() -> CGFloat {
        let c = CGColorGetComponents(self.CGColor)
        let type = self.colorSpaceModel()
        if type == .Monochrome {
            return c[0]
        }
        return c[1]
    }
    func blue() -> CGFloat {
        let c = CGColorGetComponents(self.CGColor)
        let type = self.colorSpaceModel()
        if type == .Monochrome {
            return c[0]
        }
        return c[2]
    }
    
    func colorSpaceModel() -> CGColorSpaceModel {
        return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))
    }
    
    func isRGB(inout red: CGFloat, inout green: CGFloat, inout blue: CGFloat, inout alpha: CGFloat) -> Bool {
        let components = CGColorGetComponents(self.CGColor)
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat
        let type = colorSpaceModel()
        switch type {
        case .Monochrome:
            r = components[0]
            g = r
            b = g
            a = components[1]
        case .RGB:
            r = components[0]
            g = components[1]
            b = components[2]
            a = components[3]
        default:
            return false
        }
        red = r
        green = g
        blue = b
        alpha = a
        return true
    }
}
