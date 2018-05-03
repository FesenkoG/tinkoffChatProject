//
//  RequestSender.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 29.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

class RequestSender: IRequestSender {
    let session = URLSession.shared
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.Failure("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(Result.Failure(error.localizedDescription))
                return
            }
            
            guard let data = data, let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completionHandler(Result.Failure("data can't be parsed"))
                return
            }
            
            completionHandler(Result.Success(parsedModel))
        }
        
        task.resume()
    }
}

