//
//  NotificationCenter+Ext.swift
//  YMExtension
//
//  Created by lym on 2022/6/8.
//

import Foundation

extension NotificationCenter: ExtCompatible {}

public extension ExtWrapper where Base == NotificationCenter {
    /// SwifterSwift：向通知中心的调度表添加一个一次性条目，其中包括一个通知队列和一个要添加到队列中的块，以及一个可选的通知名称和发送者。
    /// - 参数：
    /// - name：要为其注册观察者的通知的名称；也就是说，只有具有此名称的通知用于将块添加到操作队列。
    ///
    /// 如果传入`nil`，通知中心不使用通知名称来决定是否将块添加到操作队列中。
    /// - obj：观察者想要接收其通知的对象；也就是说，只有这个发送者发送的通知才会传递给观察者。
    ///
    /// 如果你传递了`nil`，通知中心不会使用通知的发送者来决定是否将它传递给观察者。
    /// - queue：应该添加块的操作队列。
    ///
    /// 如果传递 `nil`，则块在发布线程上同步运行。
    /// - 块：收到通知时要执行的块。
    ///
    /// 该块被通知中心复制并持有（副本）直到观察者注册被移除。
    ///
    /// 该块接受一个参数：
    /// - 通知：通知。
    func observeOnce(forName name: NSNotification.Name?,
                     object obj: Any? = nil,
                     queue: OperationQueue? = nil,
                     using block: @escaping (_ notification: Notification) -> Void)
    {
        var handler: NSObjectProtocol!
        handler = base.addObserver(forName: name, object: obj, queue: queue) { [unowned base] in
            base.removeObserver(handler!)
            block($0)
        }
    }
}
