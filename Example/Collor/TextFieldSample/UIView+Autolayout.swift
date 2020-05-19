//
//  UIView+Autolayout.swift
//  Collor_Example
//
//  Created by Deffrasnes Ghislain on 11/05/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit


extension UIView {

    public func autoPinEdgesToSuperview(respectingSafeArea: Bool = false) {
        guard let superview = superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        // Select good anchors
        let topAnchor: NSLayoutYAxisAnchor
        let leadingAnchor: NSLayoutXAxisAnchor
        let trailingAnchor: NSLayoutXAxisAnchor
        let bottomAnchor: NSLayoutYAxisAnchor

        if #available(iOS 13.0, *) {
            if respectingSafeArea {
                topAnchor = superview.safeAreaLayoutGuide.topAnchor
                leadingAnchor = superview.safeAreaLayoutGuide.leadingAnchor
                trailingAnchor = superview.safeAreaLayoutGuide.trailingAnchor
                bottomAnchor = superview.safeAreaLayoutGuide.bottomAnchor
            } else {
                topAnchor = superview.topAnchor
                leadingAnchor = superview.leadingAnchor
                trailingAnchor = superview.trailingAnchor
                bottomAnchor = superview.bottomAnchor
            }
        } else {
            topAnchor = superview.topAnchor
            leadingAnchor = superview.leadingAnchor
            trailingAnchor = superview.trailingAnchor
            bottomAnchor = superview.bottomAnchor
        }

        self.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
