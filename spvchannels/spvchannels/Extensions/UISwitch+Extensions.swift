//
//  UISwitch+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

extension UISwitch {

    convenience init(value: Bool = true) {
        self.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isOn = value
    }

}
