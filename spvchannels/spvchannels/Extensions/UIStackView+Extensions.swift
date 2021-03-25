//
//  UIStackView+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

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
