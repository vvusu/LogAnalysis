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
        var dataArr = [[Log]]()
        do {
            var mytext = try String(contentsOfURL: pathURL, encoding: NSUTF8StringEncoding)
            //去除 \r\n \n  要不正则不能匹配值
            mytext = mytext.stringByReplacingOccurrencesOfString("\r\n", withString:"")
            mytext = mytext.stringByReplacingOccurrencesOfString("\n", withString:"")
            
             let logStrArr = self.regular(mytext)
             //日志解析
             dataArr = self.parsingLog(logStrArr)

        } catch let error as NSError {
            print("error loading from url \(pathURL)")
            print(error.localizedDescription)
        }
        return dataArr
    }
    
    //正则表达式
     func regular(str: String) -> Array<String> {
        // 使用正则表达式一定要加try语句
        var contenArr = [String]()
        do {
            // - 1、创建规则 (获取{}里面的内容)
            let pattern = "(\\{.+?\\})"
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            // - 3、开始匹配
            let res = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
            // 输出结果
            var content: String
            for subRes in res {
                content = str[subRes.range.location..<subRes.range.location+subRes.range.length]
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
    
    //循环遍历log 取出值
    func parsingLog(logJsonArr: Array<String>) -> Array<[Log]> {
        var dataArr = [[Log]]()
        //遍历转换model
        var commonArr = [Log]()
        var bookArr = [Log]()
        var crashArr = [Log]()

        for json in logJsonArr {
            if let tempLog: Log = jsonToModel(json) as? Log{
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
