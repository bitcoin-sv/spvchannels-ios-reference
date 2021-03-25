//
//  RoundedButton.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

class RoundedButton: UIButton {

    init(title: String = "", action: Selector, target: AnyObject, tag: Int = 0) {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.constraintHeight(height: 40)
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 8
        self.tag = tag
        self.addTarget(target, action: action, for: .touchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
