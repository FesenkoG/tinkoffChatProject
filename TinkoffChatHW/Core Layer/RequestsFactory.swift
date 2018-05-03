//
//  RequestsFactory.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 29.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

struct RequestFactory {
    struct Birds {
        static func birdsConfig() -> RequestConfig<BirdsParser> {
            return RequestConfig<BirdsParser>.init(request: BirdsRequest(), parser: BirdsParser())
        }
    }
    struct Image {
        static func imageConfig(urlString: String) -> RequestConfig<ImageParser> {
            return RequestConfig<ImageParser>.init(request: ImageRequest(urlString: urlString), parser: ImageParser())
        }
    }
}
