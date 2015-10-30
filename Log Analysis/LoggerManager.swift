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
    
    var dataArr = [[Log]]()
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
    
    func readFile(pathURL: NSURL) -> Array<[Log]> {
        do {
            let mytext = try String(contentsOfURL: pathURL, encoding: NSUTF8StringEncoding)
            //截取按单个字符串
//            logStrings = mytext.componentsSeparatedByString("{}")
            //截取按多个字符串
            let logStrings = mytext.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "{}"))
            var logJsons = [String]()
            for num in  0..<logStrings.count {
                if num % 2 == 1 {
                        let logStr = logStrings[num]
                        let logJson = "{" + logStr + "}"
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
            }
            
            if commonArr.count > 0 {
                dataArr.append(commonArr)
            }
            if bookArr.count > 0 {
                dataArr.append(bookArr)
            }
            if crashArr.count > 0 {
                dataArr.append(crashArr)
            }
            return dataArr

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
}
