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

    class func getAllSubviews<T: UIView>(from parentView: UIView) -> [T] {
        parentView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parentView: UIView, types: [UIView.Type]) -> [UIView] {
        parentView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types where subView.classForCoder == type {
                result.append(subView)
                return result
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] {
        Self.getAllSubviews(from: self) as [T]
    }

    func get<T: UIView>(all type: T.Type) -> [T] {
        Self.getAllSubviews(from: self) as [T]
    }

    func get(all types: [UIView.Type]) -> [UIView] {
        Self.getAllSubviews(from: self, types: types)
    }
}
