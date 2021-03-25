//
//  UILabel+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

extension UILabel {

    convenience init(text: String = "", tag: Int = 0) {
        self.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.tag = tag
    }

}
