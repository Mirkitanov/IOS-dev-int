//
//  AuthenticationError.swift
//  Navigation
//
//  Created by Админ on 14.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

enum AuthenticationError: Error {
    case emptyLogin
    case emptyPassword
    case invalidLoginOrPassword
    case configError
    
    var localizedDescription: String {
        switch self {
        case .emptyLogin:
            return "Логин не введен! Пожалуйста введите данные"
        case .emptyPassword:
            return "Пароль не введен! Пожалуйста введите данные"
        case .invalidLoginOrPassword:
            return "Логин или Пароль не верны! Пожалуйста введите корректные данные"
        case .configError:
            return "Внутренняя ошибка авторицзации! Пожалуйста обратитесь в службу технической поодержки"
        }
    }
    
}
