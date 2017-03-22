//
//  Requester.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

class Requester : NSObject {
    var delegate: RequesterDelegate!
    var data = Data()
    
    func getData(from url: String) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request)
        task.resume()
    }
}

extension Requester : URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        task.suspend()
        session.invalidateAndCancel()
        self.delegate.receivedData(data: data)
    }
}

protocol RequesterDelegate {
    func receivedData(data: Data)
}
