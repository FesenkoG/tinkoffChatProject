//
//  ImageRequest.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        urlRequest = URLRequest(url: url)
    }
}
