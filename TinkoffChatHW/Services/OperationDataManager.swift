//
//  OperationDataManager.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class OperationDataManager: DataManipulationProtocol {
    
    class Retrieve: Operation {
        var result: [String: Any]?
        var success = false
        
        override func main() {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent("dataStorage.txt")
                
                do {
                    let data = try Data(contentsOf: fileURL)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, Any> {
                        self.result = jsonResult
                        success = true
                    }
                    
                } catch {
                    print("parse error: \(error.localizedDescription)")
                    success = false
                }
            }
        }
    }
    
    class Save: Operation {
        var inputData: [String: Any]?
        var success = false
        
        override func main() {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("dataStorage.txt")
                do {
                    
                    if let data = inputData {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
                        try jsonData.write(to: fileURL, options: [])
                        self.success = true
                        print("Hey, i am here!")
                    } else {
                        self.success = false
                    }
                }
                catch {
                    print(error.localizedDescription)
                    self.success = false
                }
            }
        }
    }
    
    func saveData(name: String, descr: String, imageData: Data, handler: @escaping (Bool) -> Void) {
        let data: [String: Any] = ["name": name, "description": descr, "image": imageData.base64EncodedString()]
        let oper = Save()
        oper.inputData = data
        oper.completionBlock = {
            OperationQueue.main.addOperation {
                print("Hey, I'm in main")
                handler(oper.success)
            }
        }
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue.global(qos: .userInteractive)
        queue.addOperation(oper)
        
    }
    
    func retrieveData(handler: @escaping (Bool, [String : Any]?) -> Void) {
        let oper = Retrieve()
        
        oper.completionBlock = {
            OperationQueue.main.addOperation {
                handler(oper.success, oper.result)
            }
        }
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue.global(qos: .userInteractive)
        queue.addOperation(oper)
    }
    
    
}
