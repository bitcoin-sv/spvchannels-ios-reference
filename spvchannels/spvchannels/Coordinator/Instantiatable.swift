//
//  Instantiatable.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

protocol Instantiatable {
    static func instantiate() -> Self?
}

extension Instantiatable where Self: UIViewController {
    static func instantiate() -> Self? {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller = storyboard
                .instantiateViewController(withIdentifier: className) as? Self else {
            return nil
        }
        return controller
    }
}
