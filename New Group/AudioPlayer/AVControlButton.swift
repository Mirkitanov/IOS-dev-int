//
//  AVControlButton.swift
//  Navigation
//
//  Created by Админ on 07.01.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class AVControlButton: UIButton {

    convenience init(imageName: String, controller: UIViewController, selector: Selector) {
        self.init()
        self.tintColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(named: imageName), for: .normal)
        self.addTarget(controller, action: selector, for: .touchUpInside)
    }
}
