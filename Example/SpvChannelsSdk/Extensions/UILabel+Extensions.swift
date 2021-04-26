//
//  UILabel+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

/// Extension with convenience initializer to facilitate shortening of UI generation code
extension UILabel {

    convenience init(text: String = "", tag: Int = 0) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.tag = tag
    }

}
