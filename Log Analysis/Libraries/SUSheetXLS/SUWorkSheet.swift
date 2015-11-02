//
//  SUWorkSheet.swift
//  Log Analysis
//
//  Created by vvusu on 10/30/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

class SUWorkSheet: NSObject {
    var name: String!
    var rowHeight: Float
    var columnWidth: Float
    var arrayWorkSheetRow: Array<SUWorkSheetRow>
    
    override init() {
        name = "sheet"
        columnWidth = 100
        rowHeight = 20
        arrayWorkSheetRow = [SUWorkSheetRow]()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(nameSheet: String) {
        self.init()
        name = nameSheet
    }
    
    func addWorkSheetRow(row: SUWorkSheetRow) {
        arrayWorkSheetRow.append(row)
    }
}


