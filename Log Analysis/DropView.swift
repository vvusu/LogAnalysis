//
//  DropView.swift
//  Log Analysis
//
//  Created by vvusu on 10/26/15.
//  Copyright © 2015 vvusu. All rights reserved.
//

import Cocoa
import AppKit

class DropView: NSView {
    
    var image: NSImage!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if (image == nil) {
            NSColor.orangeColor().set()
            NSRectFill(dirtyRect)
        }
        else {
            image.drawInRect(dirtyRect, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1)
        }
        // Drawing code here.
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
//        let theArray = NSImage.imageTypes()
        self.registerForDraggedTypes([NSFilenamesPboardType])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation  {
        
//        let sourceDragMask = sender.draggingSourceOperationMask()
//        let pboard = sender.draggingPasteboard()
//        if pboard.availableTypeFromArray([NSFilenamesPboardType]) == NSFilenamesPboardType {
//            if sourceDragMask.rawValue & NSDragOperation.Generic.rawValue != 0 {
//                return NSDragOperation.Generic
//            }
//        }
//        return NSDragOperation.None
        
        //加载immage 能否加载上去
        if NSImage.canInitWithPasteboard(sender.draggingPasteboard()) && sender.draggingSourceOperationMask().rawValue & NSDragOperation.Copy.rawValue != 0 {
            return NSDragOperation.Copy
        }
        else {
            return NSDragOperation.None
        }
    }

    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation  {
        self.print("UPDATED")
        return NSDragOperation.Copy
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        self.print("ENDED")
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        // ... perform your magic
        // return true/false depending on success
        if NSImage.canInitWithPasteboard(sender.draggingPasteboard()) {
            self.image = NSImage.init(pasteboard: sender.draggingPasteboard())
        }
        return true
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        self.needsDisplay = true
    }
}

