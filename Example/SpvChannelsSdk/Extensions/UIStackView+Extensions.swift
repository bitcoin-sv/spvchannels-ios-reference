//
//  UIStackView+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

/// Extension with convenience initializer to facilitate shortening of UI generation code
extension UIStackView {

    convenience init(
        views: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 10,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        tag: Int = 0) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
    }

}
