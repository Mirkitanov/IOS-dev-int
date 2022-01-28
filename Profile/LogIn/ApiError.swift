//
//  ApiError.swift
//  Navigation
//
//  Created by Админ on 16.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case notFoundRecourceImage
    case notFoundRecourceText
    case emptyText
    case configError
    
    var localizedDescription: String {
        switch self {
        case .notFoundRecourceImage:
            return "Ошибка загрузи Картинки! Ресурс не найден"
        case .notFoundRecourceText:
            return "Ошибка загрузи Текста! Ресурс не найден"
        case .emptyText:
            return "Текстовое поле пусто"
        case .configError:
            return "Внутренняя ошибка! Пожалуйста обратитесь в службу технической поодержки"
        }
    }
}

typealias ApiErrorCompletionBlock = (Result<Bool, Error>) -> Void
