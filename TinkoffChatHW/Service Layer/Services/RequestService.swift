//
//  RequestService.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class RequestService: IRequestService {
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func fetchBirdsImagesUrls(completionHandler: (@escaping ([FetchedModel]?, String?) -> Void)) {
        let requestConfig = RequestFactory.Birds.birdsConfig()
        requestSender.send(config: requestConfig) { (result: Result<[FetchedModel]>) in
            switch result {
            case .Failure(let error):
                completionHandler(nil, error)
            case .Success(let model):
                completionHandler(model, nil)
            }
        }
    }
    
    func fetchImage(by url: String, completionHandler: @escaping (UIImage?) -> Void) {
        let requestConfig = RequestFactory.Image.imageConfig(urlString: url)
        requestSender.send(config: requestConfig) { (result: Result<UIImage>) in
            switch result {
            case .Failure(let error):
                print(error)
                completionHandler(nil)
            case .Success(let image):
                completionHandler(image)
            }
        }
    }
}

protocol IRequestService {
    func fetchBirdsImagesUrls(completionHandler: (@escaping ([FetchedModel]?, String?) -> Void))
    func fetchImage(by url: String, completionHandler: @escaping (UIImage?) -> Void)
}
