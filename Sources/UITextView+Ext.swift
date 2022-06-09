//
//  UITextView+Ext.swift
//  YMExtension
//
//  Created by lym on 2022/6/7.
//

import UIKit

public extension ExtWrapper where Base: UITextView {
    /// SwifterSwift: Clear text.
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }

    /// SwifterSwift: Scroll to the bottom of text view.
    func scrollToBottom() {
        let range = NSRange(location: (base.text as NSString).length - 1, length: 1)
        base.scrollRangeToVisible(range)
    }

    /// SwifterSwift: Scroll to the top of text view.
    func scrollToTop() {
        let range = NSRange(location: 0, length: 1)
        base.scrollRangeToVisible(range)
    }

    /// SwifterSwift: Wrap to the content (Text / Attributed Text).
    func wrapToContent() {
        base.contentInset = .zero
        base.scrollIndicatorInsets = .zero
        base.contentOffset = .zero
        base.textContainerInset = .zero
        base.textContainer.lineFragmentPadding = 0
        base.sizeToFit()
    }
}
