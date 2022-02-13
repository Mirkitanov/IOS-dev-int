//
//  PhotosPublisherFacadeCell.swift
//  Navigation
//
//  Created by Админ on 12.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class PhotosPublisherFacadeCell: UICollectionViewCell {
    
    var photoInScreen: Photo? {
            didSet {
                photoImageView.image = photoInScreen?.image
            }
        }
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubviews(photoImageView)
        
        let constraints = [
            
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
           
        ]
        
        NSLayoutConstraint.activate(constraints)
    
    }
    
}
