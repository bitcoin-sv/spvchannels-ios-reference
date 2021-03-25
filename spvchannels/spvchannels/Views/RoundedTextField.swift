//
//  RoundedTextField.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

class RoundedTextField: UITextField {

    init(placeholder: String = "", text: String = "") {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.placeholder = placeholder
        self.text = text
        self.borderStyle = .roundedRect
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
