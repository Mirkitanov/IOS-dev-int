//
//  PostViewController.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: PostOld?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = post?.title
    }
}

struct PostOld {
    var title: String
}
