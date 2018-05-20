//
//  CoosePhotohViewController.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 28.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var timer: Timer?
    var location: CGPoint?
    let imgSize: CGFloat = 40
    
    var model: IChoosePhotoModel?
    private var numberOfPhotos = 0
    
    weak var delegate: ItemSelected?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinner()
        collectionViewSetup()
        loadLinks()
        self.view.createTinkoffLogoAnimation()
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func startSpinner() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func stopSpinner() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    func loadLinks() {
        self.model?.fetchImagesUrl() { (success) in
            if success {
                DispatchQueue.main.async {
                    if let data = self.model?.getImagesUrls() {
                        print("I am here")
                        self.numberOfPhotos = data.count
                        self.stopSpinner()
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        model?.getImage(by: indexPath, completionHandler: { (image) in
            DispatchQueue.main.async {
                if let image = image {
                    cell.configureCell(image: image)
                }
            }
        })
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfColumns: CGFloat = 3
        
        let spaceBetweenCells: CGFloat = 20
        let cellDimention = ((collectionView.bounds.width) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        
        return CGSize(width: cellDimention, height: cellDimention)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model?.getImage(by: indexPath, completionHandler: { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.delegate?.didSelectItem(with: image)
                }
            }
        })
        dismiss(animated: true, completion: nil)
    }
}

protocol ItemSelected: class {
    func didSelectItem(with image: UIImage)
}
