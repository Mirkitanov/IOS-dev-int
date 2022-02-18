//
//  FlowCoordinatorProtocol.swift
//  Navigation
//
//  Created by Админ on 18.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

protocol FlowCoordinatorProtocol {
    var mainCoordinator: AppCoordinator? { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func backtoRoot()
}

