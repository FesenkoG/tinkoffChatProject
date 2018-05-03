//
//  BirdsParser.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

struct FetchedModel {
    let urlString: String
}

class BirdsParser: IParser {
    typealias Model = [FetchedModel]
    
    func parse(data: Data) -> [FetchedModel]? {
        var result = [FetchedModel]()
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
            guard var hits = json["hits"] as? [[String: Any]] else { return nil }
            if hits.count > 200 {
                hits = Array(hits.prefix(upTo: 200))
            }
            for hit in hits {
                guard let webformatUrl = hit["webformatURL"] as? String else { return nil }
                result.append(FetchedModel(urlString: webformatUrl))
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
}
