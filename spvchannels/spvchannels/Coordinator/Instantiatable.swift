//
//  Instantiatable.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

protocol Instantiatable {
    static func instantiate() -> Self?
    func setupVIP()
}
