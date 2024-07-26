//
//  SceneDelegate.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation
import UIKit

public struct LayoutEdge: SequenceOptionSet {
    public let rawValue: Int

    init(_ rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(rawValue: Int) {
        self.init(rawValue)
    }

    public static let top = LayoutEdge(1 << 0)
    public static let bottom = LayoutEdge(1 << 1)

    public static let leading = LayoutEdge(1 << 2)
    public static let trailing = LayoutEdge(1 << 3)
    public static let left = LayoutEdge(1 << 4)
    public static let right = LayoutEdge(1 << 5)

    public static let centerX = LayoutEdge(1 << 6)
    public static let centerY = LayoutEdge(1 << 7)

    public static let topGuide = LayoutEdge(1 << 8)
    public static let bottomGuide = LayoutEdge(1 << 9)

    public static let allEdges: LayoutEdge = [.top, .bottom, .leading, .trailing, .left, .right]
    public static let allGuideEdges: LayoutEdge = [.topGuide, .bottomGuide, .leading, .trailing, .left, .right]
    public static let allAnchors: LayoutEdge = [.top, .bottom, .leading, .trailing, .left, .right, .centerX, .centerY, .topGuide, .bottomGuide]
}

extension UIView {
    /// Simple helper method to constrain all edges to views.
    public func constraintEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
        ])
    }

    /// Simple helper method to constrain all edges to views with layout guide.
    public func constraintEdges(layoutGuide: Bool = false, to view: UIView, insets: UIEdgeInsets = .zero) {
        constraint(to: view, edges: (layoutGuide ? LayoutEdge.allGuideEdges : LayoutEdge.allEdges))
    }

    /// Simple helper method to constrain all edges to views.
    public func constraintEdges(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        constraintEdges(to: view, insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    /// Simple helper method to constrain all edges excluding the given ones.
    public func constraintEdges(layoutGuide: Bool = false, to view: UIView, excluding edges: LayoutEdge, insets: UIEdgeInsets = .zero) {
        constraint(to: view, edges: (layoutGuide ? LayoutEdge.allGuideEdges : LayoutEdge.allEdges).subtracting(edges), insets: insets)
    }

    /// Simple helper method to constrain all edges excluding the given ones.
    public func constraintEdges(layoutGuide: Bool = false, to view: UIView, excluding edges: LayoutEdge = [], top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        constraint(to: view, edges: (layoutGuide ? LayoutEdge.allGuideEdges : LayoutEdge.allEdges).subtracting(edges), insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    /// Simple helper method to constrain same edges to views.
    public func constraint(to view: UIView, edges: LayoutEdge, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        constraint(to: view, edges: edges, insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    /// Simple helper method to constrain height.
    public func constraintHeight(to height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    /// Simple helper method to constrain size.
    public func constraintSize(width: CGFloat, height: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    /// Simple helper method to constrain size.
    public func constraintSize(to size: CGSize) {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }

    /// Simple helper method to constrain width.
    public func constraintWidth(to width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    /// Simple helper method to constrain same edges to views.
    public func constraint(to view: UIView, edges: LayoutEdge, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate(
            edges.map { edge -> NSLayoutConstraint in
                switch edge {
                case .top:
                    return topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)
                case .bottom:
                    return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
                case .leading:
                    return leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left)
                case .trailing:
                    return trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
                case .left:
                    return leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left)
                case .right:
                    return rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right)
                case .centerX:
                    return centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: insets.left - insets.right)
                case .centerY:
                    return centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: insets.top - insets.bottom)
                case .topGuide:
                    return topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top)
                case .bottomGuide:
                    return bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
                default:
                    fatalError("Case not handled")
                }
            })
    }
}
