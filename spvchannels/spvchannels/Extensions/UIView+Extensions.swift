//
//  UIView+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

extension UIView {

    convenience init(height: CGFloat = 1, backgroundColor: UIColor = UIColor.darkGray, tag: Int = 0) {
        self.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.constraintHeight(height: height)
        self.backgroundColor = backgroundColor
        self.tag = tag
    }

    func constraintHeight(height: CGFloat) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func constraintWidth(width: CGFloat) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width)
        ])
    }

    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)
        ])
    }
}
