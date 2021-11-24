//
//  SwiftExtension.swift
//  Pods-SwiftExtension_Tests
//
//  Created by lym on 2021/11/24.
//

import Foundation

public struct ExtWrapper<Base> {
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtCompatible: Any { }

public extension ExtCompatible {
    static var ext: ExtWrapper<Self>.Type {
        get{ ExtWrapper<Self>.self }
        set {}
    }
    
    var ext: ExtWrapper<Self> {
        get { return ExtWrapper<Self>(self) }
        set { }
    }
}


