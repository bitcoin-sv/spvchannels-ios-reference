//
//  Coordinator+Coordinatable.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

/// Protocols to facilitate Coordinater pattern
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol Coordinatable: AnyObject {
    var coordinator: SceneCoordinator? { get set }
}
