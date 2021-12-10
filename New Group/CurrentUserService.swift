//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Админ on 08.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

 final class CurrentUserService: UserServiceProtocol {

     let user = User(userFullName: "Павел Миркитанов", userAvatar: UIImage(named: "foto2"), userStatus: "Смелее вперед!")

     func getUser(fullName: String) -> User? {

        if fullName == user.userFullName {
            return user
        } else {
            return nil
        }
     }
 }
