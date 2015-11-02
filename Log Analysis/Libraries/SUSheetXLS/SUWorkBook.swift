//
//  SUWorkBook.swift
//  Log Analysis
//
//  Created by vvusu on 10/30/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

class SUWorkBook: NSObject {
    var author: String
    var date: NSDate
    var version: Float
    var defaultStyle: SUStyle
    var arrayWorkSheet: Array<SUWorkSheet>
    
    override init() {
        defaultStyle = SUStyle()
        defaultStyle.font = NSFont.systemFontOfSize(14)
        defaultStyle.size = 14
        defaultStyle.color = NSColor.blackColor()
        defaultStyle.alignmentH = .MiddleAlign
        defaultStyle.alignmentV = .CenterAlign
        version = 1.0
        author = "system"
        date = NSDate()
        arrayWorkSheet = [SUWorkSheet]()
        //#000000
    }
    
    func addWorkSheet(sheet: SUWorkSheet) {
        arrayWorkSheet.append(sheet)
    }
    
    func writeWithName(name: String,toPath path: String) -> Bool {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        let dateString = format.stringFromDate(self.date)
        // dateString 为空
        let head = String(format:"<?xml version=\"1.0\"encoding=\"UTF-8\"?>\n<?mso-application progid=\"Excel.Sheet\"?>\n<Workbook xmlns:c=\"urn:schemas-microsoft-com:office:component:spreadsheet\"\n xmlns:html=\"http://www.w3.org/TR/REC-html40\"\n xmlns:o=\"urn:schemas-microsoft-com:office:office\"\n xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"\n xmlns:x2=\"http://schemas.microsoft.com/office/excel/2003/xml\"\n xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"\n xmlns:x=\"urn:schemas-microsoft-com:office:excel\">\n<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\"><Author>%@</Author>\n<LastAuthor>%@</LastAuthor>\n<Created>%@</Created>\n<Version>%.2f</Version>\n</DocumentProperties>\n", self.author, self.author, dateString, self.version)
        
        let officeSetting = String(format:"<OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">\n</OfficeDocumentSettings>\n<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">\n<WindowHeight>20000</WindowHeight>\n<WindowWidth>20000</WindowWidth>\n<WindowTopX>0</WindowTopX>\n<WindowTopY>0</WindowTopY>\n<ProtectStructure>False</ProtectStructure>\n<ProtectWindows>False</ProtectWindows>\n</ExcelWorkbook>")
        var styleDefault = "<Styles>"
        styleDefault += String(format:"<Style ss:ID=\"Default\" ss:Name=\"Normal\">\n<Alignment ss:Vertical=\"%@\" ss:Horizontal=\"%@\"/>\n<Borders/>\n<Font ss:FontName=\"%@\" ss:Size=\"%.2f\" ss:Color=\"#%@\"/>\n<Interior/>\n<NumberFormat/>\n<Protection/>\n</Style>\n",formatTypeToStringVertical(defaultStyle.alignmentV),formatTypeToStringHorizontal(defaultStyle.alignmentH),defaultStyle.font.fontName,defaultStyle.size,defaultStyle.color.getHexString())
        
        var i = 0
        for sheet in arrayWorkSheet {
            for sheetRow in sheet.arrayWorkSheetRow {
                    //sheeRow 与 默认的不同
                    if !isEqualStyle(sheetRow.style, style2: defaultStyle) {
                       styleDefault = styleDefault.stringByAppendingString(String(format:"<Style ss:ID=\"s%i\">\n<Alignment ss:Vertical=\"%@\" ss:Horizontal=\"%@\"/>\n<Borders/>\n<Font ss:FontName=\"%@\" ss:Size=\"%.2f\" ss:Color=\"#%@\"/>\n<Interior/>\n<NumberFormat/>\n<Protection/>\n</Style>\n",50+i,formatTypeToStringVertical(sheetRow.style.alignmentV),formatTypeToStringHorizontal(sheetRow.style.alignmentH),sheetRow.style.font.fontName,sheetRow.style.size,sheetRow.style.color.getHexString()))
                        i++
                    }
                    //cell 与 sheetRow的不同
                    for cell in sheetRow.cellArray {
                        if !isEqualStyle(cell.style, style2: sheetRow.style) {
                            //date is style
                            if cell.type == .Date {
                                styleDefault = styleDefault.stringByAppendingString(String(format:"<Style ss:ID=\"s%i\">\n<Alignment ss:Vertical=\"%@\" ss:Horizontal=\"%@\"/>\n<Borders/>\n<Font ss:FontName=\"%@\" ss:Size=\"%.2f\" ss:Color=\"#%@\"/>\n<Interior/>\n<NumberFormat ss:Format=\"Short Date\" />\n<Protection/>\n</Style>\n",50+i,formatTypeToStringVertical(cell.style.alignmentV),formatTypeToStringHorizontal(cell.style.alignmentH),cell.style.font.fontName,cell.style.size,cell.style.color.getHexString()))
                                i++
                             }
                            //string & number is style
                             else {
                                styleDefault = styleDefault.stringByAppendingString(String(format:"<Style ss:ID=\"s%i\">\n<Alignment ss:Vertical=\"%@\" ss:Horizontal=\"%@\"/>\n<Borders/>\n<Font ss:FontName=\"%@\" ss:Size=\"%.2f\" ss:Color=\"#%@\"/>\n<Interior/>\n<NumberFormat/>\n<Protection/>\n</Style>\n",50+i,formatTypeToStringVertical(cell.style.alignmentV),formatTypeToStringHorizontal(cell.style.alignmentH),cell.style.font.fontName,cell.style.size,cell.style.color.getHexString()))
                                i++
                            }
                        }
                        else {
                            //date style
                            if cell.type == .Date {
                                styleDefault = styleDefault.stringByAppendingString(String(format:"<Style ss:ID=\"s%i\">\n<NumberFormat ss:Format=\"Short Date\"/>\n</Style>\n",50+i))
                                i++
                            }
                        }
                    }
                }
            }
        
        styleDefault += ("</Styles>\n")
        var sheet = String()
        var j = 0
        for sheetwork in arrayWorkSheet {
            sheet = sheet.stringByAppendingString(String(format:"<Worksheet ss:Name=\"%@\">\n",sheetwork.name))
            sheet = sheet.stringByAppendingString(String(format:"<Table ss:ExpandedColumnCount=\"%i\" ss:ExpandedRowCount=\"%i\" x:FullColumns=\"1\" x:FullRows=\"1\" ss:DefaultColumnWidth=\"%.2f\" ss:DefaultRowHeight=\"%.2f\">\n",countMaxCell(sheetwork.arrayWorkSheetRow),sheetwork.arrayWorkSheetRow.count,sheetwork.columnWidth,sheetwork.rowHeight))
            
            //改变第一列的宽度
            sheet += "<Column ss:Width=\"200\"/>\n"
            for sheetRow in sheetwork.arrayWorkSheetRow {
                if !isEqualStyle(sheetRow.style, style2: defaultStyle) {
                   sheet = sheet.stringByAppendingString(String(format:"<Row ss:AutoFitHeight=\"0\" ss:Height=\"%.2f\" ss:StyleID=\"s%i\">\n",sheetRow.height, 50+j))
                    j++
                }
                else {
                    sheet = sheet.stringByAppendingString(String(format:"<Row ss:AutoFitHeight=\"0\" ss:Height=\"%.2f\" >\n",sheetRow.height))
                }
            
                for cell in sheetRow.cellArray {
                    if !isEqualStyle(cell.style, style2: sheetRow.style) {
                        sheet = sheet.stringByAppendingString(String(format:"<Cell ss:StyleID=\"s%i\">\n",50+j))
                        j++
                    }
                    else {
                        if cell.type == .Date {
                            sheet = sheet.stringByAppendingString(String(format:"<Cell ss:StyleID=\"s%i\">\n",50+j))
                            j++
                        }
                        else {
                            sheet += "<Cell>\n"
                        }
                    }
                    
                    sheet = sheet.stringByAppendingString(String(format:"<Data ss:Type=\"%@\">%@</Data>\n",formatTypeToCellType(cell.type),cell.content!))
                    sheet += "</Cell>\n"
                }
                sheet += "</Row>\n"
            }
            sheet += "</Table>\n<WorksheetOptions/>\n</Worksheet>\n"
        }
        sheet += "</Workbook>\n"
        
        //final xls file content
        let finalText = head + officeSetting + styleDefault + sheet
        let pathFinal = path + name + ".xls"
        
        do {
          try finalText.writeToFile(pathFinal, atomically: true, encoding: NSUTF8StringEncoding)
            print("salvataggio corretto")
            print("path:\(pathFinal)")
            return true
        }
        catch {
            print("error")
            return false
        }
    }
    
    
    func isEqualStyle(style1: SUStyle, style2: SUStyle) -> Bool {
        if style1.font != style2.font {
            return false
        }
        if style1.color != style2.color {
            return false
        }
        if style1.size != style2.size {
            return false
        }
        if style1.alignmentH != style2.alignmentH {
            return false
        }
        if style1.alignmentV != style2.alignmentV {
            return false
        }
        return true
    }
    
    func countMaxCell(sheet: Array<SUWorkSheetRow>) -> Int {
        var max = 0
        for row in sheet {
            if row.cellArray.count > max {
                max = row.cellArray.count
            }
        }
        return max
    }
    
    func formatTypeToStringVertical(formatType: VerticalAlign) -> String {
        var result = String()
        switch formatType {
        case .TopAlign:
            result = "Top"
        case .CenterAlign:
            result = "Center"
        case .BottomAlign:
            result = "Bottom"
        }
        return result
    }
    
    
    func formatTypeToStringHorizontal(formatType: HorizontalAlign) -> String {
        var result = String()
        switch formatType {
        case .LeftAlign:
            result = "Left"
        case .MiddleAlign:
            result = "Center"
        case .RightAlign:
            result = "Right"
        }
        return result
    }
    
    func formatTypeToCellType(formatType: Celltype) -> String {
        var result = String()
        switch formatType {
        case .Number:
            result = "Number"
        case .String:
            result = "String"
        case .Date:
            result = "DateTime"
        }
        return result
    }
}

