//
//  SceneDelegate.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

public struct OptionSetIterator<Element: OptionSet>: IteratorProtocol where Element.RawValue == Int {
    private let value: Element

    public init(element: Element) {
        self.value = element
    }

    private lazy var remainingBits = value.rawValue
    private var bitMask = 1

    public mutating func next() -> Element? {
        while remainingBits != 0 {
            defer { bitMask = bitMask &* 2 }
            if remainingBits & bitMask != 0 {
                remainingBits = remainingBits & ~bitMask
                return Element(rawValue: bitMask)
            }
        }
        return nil
    }
}
