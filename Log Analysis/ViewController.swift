//
//  ViewController.swift
//  Log Analysis
//
//  Created by vvusu on 10/21/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet var typeTableView: NSTableView!
    @IBOutlet var logTableView: NSTableView!
    @IBOutlet var titleLabel: NSTextField!
    let myQueue: dispatch_queue_t = dispatch_queue_create("logAnalysis", nil)
    let logManager = LoggerManager.sharedInstance
    var dataArr: Array<[[Log]]> = []
    var logDataArr: Array<Log> = []
    var fileURL: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let drop = DropView.init(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
//        self.view.addSubview(drop)
    }

    override var representedObject: AnyObject? {
        didSet {
        }
    }
    
    //open file
    @IBAction func openFile(sender: NSButton) {
        let oPanel = NSOpenPanel()
        //可以打开目录
        oPanel.canChooseDirectories = true
        //不能打开文件(我需要处理一个目录内的所有文件)
        oPanel.canChooseFiles = true
        //如果用户点OK
        if oPanel.runModal() == NSModalResponseOK {
            let paths: NSArray = oPanel.URLs
            let path = paths.objectAtIndex(0)
            self.titleLabel.stringValue = path.absoluteString
            fileURL = path as! NSURL
        }
    }
    
    //start
    @IBAction func start(sender: AnyObject) {
        if fileURL != nil {
            //异步读取文件
            dispatch_async(myQueue, { () -> Void in
               self.dataArr = self.logManager.readFile(self.fileURL)
                dispatch_async(dispatch_get_main_queue()) {
                    // 返回到主线程更新 UI
                    self.typeTableView.reloadData()
                    self.titleLabel = nil
                    print("end analysis update UI")
                }
            })
        }
    }
    
    //output file
    @IBAction func outPut(sender: NSButton) {
        self.logManager.createXLSFile("/Users/vvusu/Desktop/")
    }
    
    //json 转 dictionary
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            }
            catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    //打开文件选择框
    func openFile() {
        NSWorkspace.sharedWorkspace().openFile("文件路径")
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: "/Users/vvusu/")
    }
    
    // tableView
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if tableView == self.logTableView {
            return logDataArr.count
        }
        else {
            if dataArr.count>0 {
                return dataArr[0].count
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == self.logTableView {
            let cellView = tableView.makeViewWithIdentifier("logCell", owner: self) as! NSTableCellView
            cellView.textField!.stringValue = self.logDataArr[row].message!
            return cellView
        }
        else if (tableView == self.typeTableView){
            let cellView = tableView.makeViewWithIdentifier("logTypeCell", owner: self) as! NSTableCellView
            cellView.textField!.stringValue = self.dataArr[0][row][0].type!
            return cellView
        }
        else {
            return nil
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        if  tableView == self.logTableView {
            if self.logTableView.selectedRow >= 0 {
                let selecteditem = self.logDataArr[self.logTableView.selectedRow]
                self.logTableView.deselectRow(self.logTableView.selectedRow)
                let logDetailVC = LogDetailVC()
                logDetailVC.content = selecteditem.message!
                self.presentViewController(logDetailVC, asPopoverRelativeToRect: tableView.frame, ofView: self.view, preferredEdge: .MinY, behavior: .Transient)
            }
        }
        else {
            if self.typeTableView.selectedRow >= 0{
                self.logDataArr = self.dataArr[0][self.typeTableView.selectedRow]
                self.logTableView.reloadData()
            }
        }
    }
}

