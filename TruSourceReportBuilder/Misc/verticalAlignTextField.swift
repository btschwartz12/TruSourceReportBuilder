//
//  verticalAlignTextField.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/23/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation
import Cocoa

class RSVerticallyCenteredTextFieldCell: NSTextFieldCell {
    var mIsEditingOrSelecting:Bool = false
    
    override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        //Get the parent's idea of where we should draw
        var newRect:NSRect = super.drawingRect(forBounds: theRect)
        
        // When the text field is being edited or selected, we have to turn off the magic because it screws up
        // the configuration of the field editor.  We sneak around this by intercepting selectWithFrame and editWithFrame and sneaking a
        // reduced, centered rect in at the last minute.
        
        if !mIsEditingOrSelecting {
            // Get our ideal size for current text
            let textSize:NSSize = self.cellSize(forBounds: theRect)
            
            //Center in the proposed rect
            let heightDelta:CGFloat = newRect.size.height - textSize.height
            if heightDelta > 0 {
                newRect.size.height -= heightDelta
                newRect.origin.y += heightDelta/2
            }
        }
        
        return newRect
    }
    override func select(withFrame rect: NSRect,
                              in controlView: NSView,
                              editor textObj: NSText,
                              delegate: Any?,
                              start selStart: Int,
                              length selLength: Int)//(var aRect: NSRect, inView controlView: NSView, editor textObj: NSText, delegate anObject: AnyObject?, start selStart: Int, length selLength: Int)
    {
        let arect = self.drawingRect(forBounds: rect)
        mIsEditingOrSelecting = true;
        super.select(withFrame: arect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
        mIsEditingOrSelecting = false;
    }
    
    override func edit(withFrame rect: NSRect,
                            in controlView: NSView,
                            editor textObj: NSText,
                            delegate: Any?,
                            event: NSEvent?)
    {
        let aRect = self.drawingRect(forBounds: rect)
        mIsEditingOrSelecting = true;
        super.edit(withFrame: aRect, in: controlView, editor: textObj, delegate: delegate, event: event)
        mIsEditingOrSelecting = false
    }
}
extension NSTextField {
//    func countLabelLines() -> Int {
//        // Call self.layoutIfNeeded() if your view is uses auto layout
//        let myText = self.stringValue as NSString
//        let attributes = [NSAttributedString.Key.font : self.font]
//
//        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
//        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
//    }
//      func isTruncatedOrNot() -> Bool {
//
//        if (self.countLabelLines() > self.) {
//            return true
//        }
//        return false
//    }
}
