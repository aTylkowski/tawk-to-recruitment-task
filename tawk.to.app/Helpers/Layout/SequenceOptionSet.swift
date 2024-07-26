//
//  SceneDelegate.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

typealias SequenceOptionSet = OptionSet & Sequence

extension OptionSet where Self.RawValue == Int {
    public func makeIterator() -> OptionSetIterator<Self> {
        return OptionSetIterator(element: self)
    }
}
