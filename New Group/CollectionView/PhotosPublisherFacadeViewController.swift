//
//  PhotosPublisherFacadeViewController.swift
//  Navigation
//
//  Created by Админ on 06.02.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
import iOSIntPackage

class PhotosPublisherFacadeViewController: UIViewController {
    //MARK:- Properties
    
    var imagePublisherFacade = ImagePublisherFacade()
    
    private var dataSource: [UIImage] = [] {
        didSet { photosCollectionView.reloadData() }
    }
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: (.zero), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(PhotosPublisherFacadeCell.self, forCellWithReuseIdentifier: String(describing: PhotosPublisherFacadeCell.self))
        
        return collectionView
    }()
    
    //MARK:- Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        imagePublisherFacade.subscribe(self)
        imagePublisherFacade.addImagesWithTimer(time: 1, repeat: 15, userImages: makeAppendingArray(photosFromCustomArray: PhotoStorage.photoModel[0].photos))
    }
    
    deinit {
        imagePublisherFacade.rechargeImageLibrary()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Private methods
    
    private func setupUI() {
        title = "Photo Facade Gallery"
        view.addSubview(photosCollectionView)
        let constraints = [
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func makeAppendingArray(photosFromCustomArray: [Photo]) -> [UIImage]{
        var newPhotoArray: [UIImage] = []
        for (index, _) in photosFromCustomArray.enumerated() {
            newPhotoArray.append(photosFromCustomArray[index].image)
        }
        return newPhotoArray
    }
}

//MARK:- Extensions

extension PhotosPublisherFacadeViewController: UICollectionViewDelegateFlowLayout {
    
    var sideInset: CGFloat {return 8}
    
    var middleInset: CGFloat {return 8}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: (collectionView.frame.width - sideInset*2 - middleInset*2)/3,
            height: (collectionView.frame.width - sideInset*2 - middleInset*2)/3
        )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let someCell = cell as? PhotosPublisherFacadeCell else {
            return
        }
        someCell.photoImage = dataSource[indexPath.item]
//MARK:- Вопрос к проверяющему
// Почему, если создать ячейку следующим образом,то все ячейки создаются черными?
//        someCell.photoInScreen?.image = dataSource[indexPath.item]
    }
}

extension PhotosPublisherFacadeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosPublisherFacadeCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosPublisherFacadeCell.self), for: indexPath) as! PhotosPublisherFacadeCell
        return cell
    }
}

extension PhotosPublisherFacadeViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        self.dataSource = images
    }
}
