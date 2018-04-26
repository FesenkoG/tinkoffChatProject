//
//  DataManipulation.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class GCDDataManager: DataManipulationProtocol {
    
    private let userInteractive = DispatchQueue.global(qos: .userInteractive)
    
    func saveData(name: String, descr: String, imageData: Data, handler: @escaping (Bool) -> Void) {
        userInteractive.async {
            let data: [String: Any] = ["name": name, "description": descr, "image": imageData.base64EncodedString()]
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("dataStorage.txt")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
                    try jsonData.write(to: fileURL, options: [])
                    DispatchQueue.main.async {
                        handler(true)
                    }
                }
                catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        handler(false)
                    }
                }
            }
        }
    }
    
    func retrieveData(handler: @escaping (Bool, [String: Any]?) -> Void) {
        userInteractive.async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("dataStorage.txt")
                do {
                    let data = try Data(contentsOf: fileURL)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, Any> {
                        DispatchQueue.main.async {
                            handler(true, jsonResult)
                        }
                    }
                } catch {
                    print("parse error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        handler(false, nil)
                    }
                }
            }
        }
    }
}

