//
//  UITextField+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

/// Extension with convenience initializer to facilitate shortening of UI generation code
extension UITextField {

    convenience init(placeholder: String = "", text: String = "") {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.placeholder = placeholder
        self.text = text
        self.borderStyle = .roundedRect
    }
}
