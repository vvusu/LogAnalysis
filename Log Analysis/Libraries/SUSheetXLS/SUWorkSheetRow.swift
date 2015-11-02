//
//  SUWorkSheetRow.swift
//  Log Analysis
//
//  Created by vvusu on 10/30/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

class SUWorkSheetRow: NSObject {
    var height: Float
    var style: SUStyle
    var cellArray: Array<SUXLSCell> = []
    
    override init() {
        self.style = SUStyle()
        self.style.size = 14
        self.style.alignmentH = .MiddleAlign
        self.style.alignmentV = .CenterAlign
        self.style.color = NSColor.blackColor()
        self.style.font = NSFont.systemFontOfSize(14)
        self.cellArray = [SUXLSCell]()
        self.height = 20
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(height: Float) {
        self.init()
        self.height = height
    }
    
    convenience init(heightRow: Float, style: SUStyle) {
        self.init(height:heightRow)
        self.style = style
    }
    
    //addString
    func addCellString(content: String) {
        let newCell = SUXLSCell()
        newCell.type = .String
        newCell.content = content
        newCell.style = self.style
        cellArray.append(newCell)
    }
    
    func addcellString(content: String, alignmentH: HorizontalAlign) {
        let styleDefault = createDefaulStyle()
        styleDefault.alignmentH = alignmentH
        let newCell = SUXLSCell()
        newCell.type = .String
        newCell.content = content
        newCell.style = styleDefault
        cellArray.append(newCell)
    }
    
    func addCellString(content: String, style: SUStyle) {
        let newCell = SUXLSCell()
        newCell.content = content
        newCell.type = .String
        newCell.style = style
        cellArray.append(newCell)
    }
    
    //addNumber
    func addCellNumber(number: Float) {
        let newCell = SUXLSCell()
        newCell.content = String.init(format: "%.2f",number)
        newCell.type = .Number
        newCell.style = self.style
        cellArray.append(newCell)
    }
    
    func addCellNumber(number: Float, withStyle style: SUStyle) {
        let newCell = SUXLSCell()
        newCell.content = String.init(format: "%.2f",number)
        newCell.type = .Number
        newCell.style = style
        cellArray.append(newCell)
    }
    
    //addDate  default style is MiddleAlign
    func addCellDate(content: NSDate) {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        let dateString = format.stringFromDate(content)
        
        let styleDefault = createDefaulStyle()
        let newCell = SUXLSCell()
        newCell.content = dateString
        newCell.type = .Date
        newCell.style = styleDefault
        cellArray.append(newCell)
    }
    
    func addCellDate(content: NSDate, withStyle style: SUStyle) {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        let dateString = format.stringFromDate(content)
        let newCell = SUXLSCell()
        newCell.content = dateString
        newCell.type = .Date
        newCell.style = style
        cellArray.append(newCell)
    }
    
    //other
    func createDefaulStyle() -> SUStyle {
        let styleDefault = SUStyle()
        styleDefault.font = NSFont.systemFontOfSize(14)
        styleDefault.size = 14.0
        styleDefault.color = NSColor.blackColor()
        styleDefault.alignmentH = .MiddleAlign
        styleDefault.alignmentV = .CenterAlign
        return styleDefault
    }
}
