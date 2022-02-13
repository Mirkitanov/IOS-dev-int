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
    
    private var dataSource: [UIImage] = [] {
        didSet { photosCollectionView.reloadData() }
    }
    
    var imageContainerArray: [UIImage] = []
    
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
        imageContainerArray = makeImageArray(from: PhotoStorage.photoModel[0].photos, needCountElementsOrLess: 21)
        getProcessImages(filter: .noir, qualityOfService: .default)
    }
/*
         Фильтр: noir,
         Количество элементов массива: 21,
         Приоритет(QualityOfService): NSQualityOfService.default,
         Время выполнения метода: 3.638170003890991
         
         Фильтр: noir,
         Количество элементов массива: 21,
         Приоритет(QualityOfService): NSQualityOfService.background,
         Время выполнения метода: 4.096581935882568
         
         Фильтр: noir,
         Количество элементов массива: 12,
         Приоритет(QualityOfService): NSQualityOfService.background,
         Время выполнения метода: 2.986425042152405
         
         Фильтр: chrome,
         Количество элементов массива: 12,
         Приоритет(QualityOfService): NSQualityOfService.background,
         Время выполнения метода: 3.177616000175476
         
         Фильтр: chrome,
         Количество элементов массива: 21,
         Приоритет(QualityOfService): NSQualityOfService.default,
         Время выполнения метода: 3.6189130544662476
         
         Фильтр: chrome,
         Количество элементов массива: 21,
         Приоритет(QualityOfService): NSQualityOfService.background,
         Время выполнения метода: 4.146368980407715
*/
    
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
    
    private func makeImageArray(from photoArray: [Photo], needCountElementsOrLess: Int) -> [UIImage]{
        var newPhotoArray: [UIImage] = []
        for (index, _) in photoArray.enumerated() where index < needCountElementsOrLess {
            newPhotoArray.append(photoArray[index].image)
        }
        return newPhotoArray
    }
    
    func getProcessImages(filter: ColorFilter, qualityOfService: QualityOfService) {
        let imageProcessor = ImageProcessor()
        let methodStart = NSDate()
        imageProcessor.processImagesOnThread(sourceImages: imageContainerArray, filter: filter, qos: qualityOfService) {[weak self] processedImages in
            guard let self = self else { return }
        
            DispatchQueue.main.async {
                for i in processedImages {
                    guard let image = i else { return }
                    self.dataSource.append(UIImage(cgImage: image))
                }
                
                let methodFinish = NSDate()
                
                let executionTime = methodFinish.timeIntervalSince(methodStart as Date)
                
                print("""
Фильтр: \(filter),
Количество элементов массива: \(self.dataSource.count),
Приоритет(QualityOfService): \(qualityOfService),
Время выполнения метода: \(executionTime)
""")
            }
        }
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
