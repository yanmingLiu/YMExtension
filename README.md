# YMExtension

[![CI Status](https://img.shields.io/travis/lym/YMExtension.svg?style=flat)](https://travis-ci.org/lym/YMExtension)
[![Version](https://img.shields.io/cocoapods/v/YMExtension.svg?style=flat)](https://cocoapods.org/pods/YMExtension)
[![License](https://img.shields.io/cocoapods/l/YMExtension.svg?style=flat)](https://cocoapods.org/pods/YMExtension)
[![Platform](https://img.shields.io/cocoapods/p/YMExtension.svg?style=flat)](https://cocoapods.org/pods/YMExtension)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YMExtension is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YMExtension'
```

```swift
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

```

## Author

lym, lwb374402328@gmail.com

## License

YMExtension is available under the MIT license. See the LICENSE file for more info.
