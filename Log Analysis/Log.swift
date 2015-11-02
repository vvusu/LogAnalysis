//
//  Log.swift
//  Log Analysis
//
//  Created by vvusu on 10/27/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

class Log: Mappable {
    
//    let time: String!            //日期
//    let level: String!           //日志级别
//    let type: String!            //日志类型标识符
//    let message: String!         //日志信息
//    let partname: String!        //日志标示
//    let logID: String!           //日志ID
//    let version: String!         //软件版本
//    let systemVersion: String!   //系统版本
//    let phoneModel: String!      //手机型号
//    let userToken: String!       //用户Token
//    let userUN: String!          //用户的un
//    let userUNID: String!        //用户的unid
    
//    required init(){
//        self.time = ""
//        self.level = ""
//        self.type = ""
//        self.message = ""
//        self.partname = ""
//        self.logID = ""
//        self.version = ""
//        self.systemVersion = ""
//        self.phoneModel = ""
//        self.userToken = ""
//        self.userUN = ""
//        self.userUNID = ""
//    }
    
    var level: String?           //日志级别
    var partname: String?        //日志标示
    //新版本
    var errorCode: Int?          //日志错误码
    var type: String?            //日志类型标识符
    var time: String?            //日期
    var message: String?         //日志信息
    var logID: String?           //日志ID
    var version: String?         //软件版本
    var systemVersion: String?   //系统版本
    var phoneModel: String?      //手机型号
    var userToken: String?       //用户Token
    var userUN: String?          //用户的un
    var userUNID: String?        //用户的unid
    var bookId: String?          //bookId
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        level           <- map["level"]
        partname        <- map["partname"]
        
        errorCode       <- map["errorCode"]
        type            <- map["type"]
        message         <- map["message"]
        time            <- map["time"]
        logID           <- map["logID"]
        version         <- map["version"]
        systemVersion   <- map["systemVersion"]
        phoneModel      <- map["phoneModel"]
        userToken       <- map["userToken"]
        userUN          <- map["userUN"]
        userUNID        <- map["userUNID"]
        bookId          <- map["bookId"]
    }
}

extension Log: CustomStringConvertible {
    var description: String {
        return "LogSwiftyJSON - errorCode: \(errorCode)\ntime: \(time)\nlevel: \(level)\ntype: \(type)\nmessage: \(message)\npartname: \(partname)\nlogID: \(logID)\nversion: \(version)\nsystemVersion: \(systemVersion)\nphoneModel: \(phoneModel)\nuserToken: \(userToken)\nuserUN: \(userUN)\nuserUNID: \(userUNID)\nbookId: \(bookId)"
    }
}

