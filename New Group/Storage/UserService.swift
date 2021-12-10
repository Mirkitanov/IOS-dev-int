//
//  UserService.swift
//  Navigation
//
//  Created by Админ on 08.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {

     func getUser(fullName: String) -> User?

 }
