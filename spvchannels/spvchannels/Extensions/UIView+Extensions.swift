//
//  UIView+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

extension UIView {

    func pinConstraintsToSuperview() {
        guard self.superview != nil else { return }
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                         options: [], metrics: nil, views: ["view": self])
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                        options: [], metrics: nil, views: ["view": self])
        constraints.append(contentsOf: constraint)
        NSLayoutConstraint.activate(constraints)
    }

    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)
        ])
    }

    func constraintCenterX() {
        guard let parent = superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        ])
    }

    func constraintCenterY() {
        guard let parent = superview else { return }
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: parent.centerYAnchor)
        ])
    }

    func constraintCenterXY() {
        guard let parent = superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            centerYAnchor.constraint(equalTo: parent.centerYAnchor)
        ])
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

    func constraintSize(size: CGSize) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }

    func pinTopLeft(offset: CGSize = .zero) {
        guard let parent = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor, constant: offset.height),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: offset.width)
        ])
    }

    func pinTop(offset: CGFloat = 0) {
        guard let parent = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor, constant: offset)
        ])
    }
}
