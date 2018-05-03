//
//  ChoosePhotoModel.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class ChoosePhotoModel: IChoosePhotoModel {
    
    let requestService: IRequestService
    
    private var imagesUrls = [FetchedModel]()
    private var images = [Int: UIImage]()
    
    init(requestService: IRequestService) {
        self.requestService = requestService
    }
    
    func fetchImagesUrl(completionHandler: @escaping (Bool) -> Void) {
        requestService.fetchBirdsImagesUrls { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false)
                return
            }
            
            if let data = data {
                self.imagesUrls = data
                completionHandler(true)
            }
        }
    }
    
    func getImagesUrls() -> [FetchedModel] {
        return imagesUrls
    }
    
    func getImage(by indexPath: IndexPath, completionHandler: @escaping (UIImage?) -> Void) {
        if self.images[indexPath.row] == nil {
            let urlString = imagesUrls[indexPath.row].urlString
            requestService.fetchImage(by: urlString) { (image) in
                guard let image = image else { return }
                self.images[indexPath.row] = image
                completionHandler(image)
            }
        } else {
            completionHandler(images[indexPath.row])
        }
        
    }
    
}

protocol IChoosePhotoModel {
    func fetchImagesUrl(completionHandler: @escaping (Bool) -> Void)
    func getImagesUrls() -> [FetchedModel]
    func getImage(by indexPath: IndexPath, completionHandler: @escaping (UIImage?) -> Void)}
