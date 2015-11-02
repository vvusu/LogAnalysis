//
//  SUStyle.swift
//  Log Analysis
//
//  Created by vvusu on 10/30/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

enum VerticalAlign: Int {
    case TopAlign = 0
    case CenterAlign = 1
    case BottomAlign = 2
}

enum HorizontalAlign: Int {
    case LeftAlign = 0
    case MiddleAlign = 1
    case RightAlign = 2
}

class SUStyle: NSObject {
    var alignmentV = VerticalAlign.CenterAlign
    var alignmentH =  HorizontalAlign.MiddleAlign
    var font: NSFont!
    var color: NSColor!
    var size: Float = 0
}
