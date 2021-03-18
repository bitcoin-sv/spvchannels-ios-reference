//
//  Coordinator.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
