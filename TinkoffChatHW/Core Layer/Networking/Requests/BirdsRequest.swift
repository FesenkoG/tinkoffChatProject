//
//  BirdsRequest.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class BirdsRequest: IRequest {
    var urlRequest: URLRequest?
    
    private let urlString = "https://pixabay.com/api/?key=8841993-d9c2b3193a2db1221676b90d9&q=birds&image_type=photo&pretty=true&per_page=150"
    init() {
        guard let url = URL(string: urlString) else { return }
        urlRequest = URLRequest(url: url)
    }
}
