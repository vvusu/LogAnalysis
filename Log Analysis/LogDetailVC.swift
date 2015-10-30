//
//  LogDetailVC.swift
//  Log Analysis
//
//  Created by vvusu on 10/28/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa

class LogDetailVC: NSViewController {
    @IBOutlet var logTextView: NSTextView!
    var content : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(containerSize: view.frame.size)
        layoutManager.addTextContainer(textContainer)
        logTextView.editable = true
        logTextView.selectable = true
        logTextView.textStorage?.appendAttributedString(NSAttributedString(string: content))
        
        // Do view setup here.
    }
    
}
