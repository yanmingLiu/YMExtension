//
//  DispatchQueue+Ext.swift
//  YMExtension
//
//  Created by lym on 2022/6/8.
//

import Foundation

extension DispatchQueue: ExtCompatible {}

public extension ExtWrapper where Base: DispatchQueue {
    func debounce(delay: Double, action: @escaping () -> Void) -> () -> Void {
        // http://stackoverflow.com/questions/27116684/how-can-i-debounce-a-method-call
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            base.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}
