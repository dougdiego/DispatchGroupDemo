//
//  ViewController.swift
//  DispatchGroupDemo
//
//  Created by Doug Diego on 8/31/17.
//  Copyright © 2017 Doug Diego. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        makeNetworkRequests { (str) in
            print("all: \(str!)")
        }
    }
    
    func makeNetworkRequests(completion: @escaping (_ result: String?) -> Void) {
        let group = DispatchGroup()
        var strings = "start"
        
        group.enter()
        makeNetworkRequest(duration: 2) { (str) in
            NSLog("Request #1 \(str ?? "nil"))\n")
            if let str = str {
                strings = strings + str
            }
            group.leave()
        }
        
        group.enter()
        makeNetworkRequest(duration: 3) { (str) in
            NSLog("Request #2 \(str ?? "nil"))\n")
            if let str = str {
                strings = strings + str
            }
            group.leave()
        }
        
        group.enter()
        makeNetworkRequest(duration: 10) { (str) in
            NSLog("Request #3 \(str ?? "nil"))\n")
            if let str = str {
                strings = strings + str
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            NSLog("All 3 network reqeusts completed")
            completion(strings)
        }
    }
    
    func makeNetworkRequest(duration:Int, completion: @escaping (_ result: String?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://httpbin.org/range/1024?duration=\(Int(duration))")!
        NSLog("makeNetworkRequest() \(url)")
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                NSLog(error!.localizedDescription)
                completion(nil)
            } else {
                if let str = String(data: data!, encoding: String.Encoding.utf8) {
                    completion(str)
                } else {
                    completion(nil)
                }

            }
        }
        task.resume()
    }
}
