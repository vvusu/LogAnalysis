//
//  LoggerManager.swift
//  Log Analysis
//
//  Created by vvusu on 10/29/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

//Instance
class LoggerManager: NSObject {
    
    var dataArr = [[[Log]]]()
    //遍历转换model
    var commonArr = [Log]()
    var bookArr = [Log]()
    var crashArr = [Log]()
    
    class var sharedInstance : LoggerManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : LoggerManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LoggerManager()
        }
        return Static.instance!
    }
    
    func readFile(pathURL: NSURL) -> Array<[[Log]]> {
        do {
            let mytext = try String(contentsOfURL: pathURL, encoding: NSUTF8StringEncoding)
            //截取按单个字符串
//            logStrings = mytext.componentsSeparatedByString("{}")
            //截取按多个字符串
            let logStrings = mytext.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "{}"))
            var logJsons = [String]()
            var logJson = ""
            for num in  0..<logStrings.count {
                //autoreleasepool memory is very large
                autoreleasepool({ () -> () in
                    if num % 2 == 1 {
                        logJson = "{" + logStrings[num] + "}"
                        logJsons.append(logJson)
                        // 日志model 处理
                        if let tempLog: Log = jsonToModel(logJson) as? Log{
                            if tempLog.partname == "public" {
                                if tempLog.level == "2" {
                                    if crashArr.count == 0 {
                                        crashArr.append(tempLog)
                                    } else {
                                        if !judgingTheSameLog(tempLog, logArr: crashArr) {
                                            crashArr.append(tempLog)
                                        }
                                    }
                                }
                                else {
                                    // 过滤String
                                    tempLog.message! = tempLog.message!.stringByReplacingOccurrencesOfString("Function:+[LoggerManager DDLog:]", withString: "#", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                    
                                    if commonArr.count == 0 {
                                        commonArr.append(tempLog)
                                    } else {
                                        if !judgingTheSameLog(tempLog, logArr: commonArr) {
                                            commonArr.append(tempLog)
                                        }
                                    }
                                }
                            }
                            else {
                                tempLog.message! = tempLog.message!.stringByReplacingOccurrencesOfString("Function:+[LoggerManager DDLog:]", withString: "#", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                let bookMessage = tempLog.message!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "#"))
                               
                                for var i = 0; i<bookMessage.count; i++ {
                                    if i == 0 {
                                        tempLog.message = bookMessage[0]
                                    }
                                    else {
                                        tempLog.type = bookMessage[1]
                                    }
                                }
                                
                                if bookArr.count == 0 {
                                    bookArr.append(tempLog)
                                } else {
                                    if !judgingTheSameLog(tempLog, logArr: bookArr) {
                                        bookArr.append(tempLog)
                                    }
                                }
                            }
                            
                        }
                    }
                })
            }
            
            if bookArr.count > 0 {
                let tempArr = self.classiFication(bookArr)
                dataArr.append(tempArr)
            }
            if commonArr.count > 0 {
                let tempArr = self.classiFication(commonArr)
                dataArr.append(tempArr)
            }
            if crashArr.count > 0 {
                let tempArr = self.classiFication(crashArr)
                dataArr.append(tempArr)
            }
        } catch let error as NSError {
            print("error loading from url \(pathURL)")
            print(error.localizedDescription)
        }
        return dataArr
    }
    
    //正则表达式  （比较耗时间）1、创建规则 (获取{}里面的内容)  let pattern = "(\\{.+?\\})"
    func regular(var text: String, pattern: String) -> Array<String> {
        //去除 \r\n \n  要不正则不能匹配值
        text = text.stringByReplacingOccurrencesOfString("\r\n", withString:"")
        text = text.stringByReplacingOccurrencesOfString("\n", withString:"")
        // 使用正则表达式一定要加try语句
        var contenArr = [String]()
        do {
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            // - 3、开始匹配
            let res = regex.matchesInString(text, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
            // 输出结果
            var content: String
            for subRes in res {
                content = text[subRes.range.location..<subRes.range.location+subRes.range.length]
                contenArr.append(content)
            }
        }
        catch {
            print(error)
        }
        return contenArr
    }
    
    //json 转模型
    func jsonToModel(jsonStr: String) -> AnyObject? {
        let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
        let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
        if let j: AnyObject = json {
            let log = Mapper<Log>().map(j)
            return log
        }
        else {
            return nil
        }
    }
    
    func judgingTheSameLog(tempLog: Log, logArr: Array<Log>) -> Bool {
        var isSameLog = false
        for booklog in logArr {
            if tempLog.message == booklog.message {
                isSameLog = true
                break
            }
        }
        if isSameLog {
            return true
        }
        else {
            return false
        }
    }
    
    // 遍历数组 把相同类型 分组
    func classiFication(arr: Array<Log>) -> Array<[Log]> {
        var finalArr = [[Log]]()
        var type1 = [Log]()
        type1.append(arr[0])
        finalArr.append(type1)
        
        for log in arr {
            autoreleasepool({ () -> () in
                var isSameType = false
                
                for var num = 0; num < finalArr.count; num++  {
                    if log.type == finalArr[num][0].type {
                        finalArr[num].append(log)
                        isSameType = true
                        break
                    }
                }
                
                if !isSameType {
                    var type2 = [Log]()
                    type2.append(log)
                    finalArr.append(type2)
                }
            })
        }
        return finalArr
    }
    
    //输出xls文件
    func createXLSFile(filePath: String) {
        let workBook = SUWorkBook()
        workBook.author = "Gagan"
        workBook.date = NSDate()
        workBook.version = 1.0
        let workShheet = SUWorkSheet.init(nameSheet: "Log")
        workShheet.columnWidth = 500
        
        let row = SUWorkSheetRow.init(height: 50)
        row.addCellString("错误类别")
        row.addCellString("错误类型")
        row.addCellString("错误详情")
        workShheet.addWorkSheetRow(row)
        
        var i = 0
        for logArr in dataArr {
            //类型分组
            var isType = true
            for typeLogArr in logArr {
                var j = 0
                for temp in typeLogArr {
                    let row = SUWorkSheetRow.init(height: 20)
                    row.style.alignmentH = .LeftAlign
                    if isType {
                        if i == 0 {
                            row.addCellString("图书类型")
                        }
                        else {
                            row.addCellString("服务器接口")
                        }
                        isType = false
                    }
                    else {
                        row.addCellString("")
                    }
                    if j == 0 {
                        row.addCellString(temp.type!)
                    }
                    else {
                        row.addCellString("")
                    }
                    row.addCellString(temp.message!)
                    workShheet.addWorkSheetRow(row)
                    j++
                }
                i++
            }
        }

        workBook.addWorkSheet(workShheet)
        let now = NSDate()
        let dateFormater = NSDateFormatter()
        dateFormater.timeZone =  NSTimeZone.systemTimeZone()
        dateFormater.dateFormat = "yyy-MM-dd"
        if workBook.writeWithName(String(format:"%@_Log",dateFormater.stringFromDate(now) as String), toPath: filePath) {
            print("XLS  Created At Path:\(filePath)")
        }
        else {
            print("FAILED")
        }
    }
}
