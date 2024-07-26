//
//  SwiftUIViewController.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import UIKit
import SwiftUI

final class SwiftUIViewController<Content: View>: UIViewController {
    private let swiftUIView: Content

    init(swiftUIView: Content) {
        self.swiftUIView = swiftUIView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.constraintEdges(to: view)
    }
}
