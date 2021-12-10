//
//  User.swift
//  Navigation
//
//  Created by Админ on 08.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

class User {
    let userFullName: String?
    let userAvatar: UIImage?
    let userStatus: String?

    init(userFullName: String?, userAvatar: UIImage?, userStatus: String?) {
        self.userFullName = userFullName
        self.userAvatar = userAvatar
        self.userStatus = userStatus
    }
}
