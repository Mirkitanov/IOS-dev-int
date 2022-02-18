//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Админ on 18.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class FeedCoordinator: FlowCoordinatorProtocol {
    
    var navigationController: UINavigationController
    weak var mainCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, mainCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }
    
    func start() {
        let feedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feed")
        navigationController.pushViewController(feedVC, animated: true)
    }
    
    func backtoRoot() {
        guard navigationController.viewControllers.count > 0 else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    func gotoPost(_ post: Post) {
    }
    
    func gotoInfo(_ post: Post) {
    }
}
