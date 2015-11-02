//
//  SUXLSCell.swift
//  Log Analysis
//
//  Created by vvusu on 10/30/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

enum Celltype: Int {
    case Number = 0
    case String = 1
    case Date = 2
}

class SUXLSCell: NSObject {
    var style: SUStyle!
    var content: String?
    var type = Celltype.String
}
