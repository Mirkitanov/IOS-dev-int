//
//  VideoPlayerTableViewCell.swift
//  Navigation
//
//  Created by Админ on 11.01.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class VideoPlayerTableViewCell: UITableViewCell {
    
    let videoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubviews(videoLabel)
        
        let constraints = [
            videoLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            videoLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            videoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            videoLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
