//
//  TestUserService.swift
//  Navigation
//
//  Created by Админ on 08.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

 final class TestUserService: UserServiceProtocol {

     let user = User(userFullName: "Пользователь", userAvatar: UIImage(named: "logo"), userStatus: "Статус не задан")

     func getUser(fullName: String) -> User? {

         if fullName == user.userFullName {
             return user
         } else {
             return nil
         }
     }

 }
