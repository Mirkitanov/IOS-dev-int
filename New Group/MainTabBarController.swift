//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Админ on 16.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    lazy var feedTabBar: UINavigationController = {
        
        var navigationController = UINavigationController()
        
        let feedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feed")
        
        navigationController.viewControllers = [feedVC]
        
        let title = "Feed"
        
        let image = UIImage(systemName: "house.fill")
        
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        return navigationController
    }()
    
    lazy var profileTabBar: UINavigationController = {
        
        var navigationController = UINavigationController()

        let loginVC = MainLogInViewController()
        
        navigationController.viewControllers = [loginVC]
        
        let title = "Profile"
        
        let image = UIImage(systemName: "person.fill")
        
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        return navigationController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [feedTabBar, profileTabBar]
    }
}

