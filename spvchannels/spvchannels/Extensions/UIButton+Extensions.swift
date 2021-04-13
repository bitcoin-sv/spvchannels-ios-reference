//
//  UIButton+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

/// Extension with convenience initializer to facilitate shortening of UI generation code
extension UIButton {

    convenience init(title: String = "", action: Selector, target: AnyObject, tag: Int = 0) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.constraintHeight(height: 40)
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 8
        self.tag = tag
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
