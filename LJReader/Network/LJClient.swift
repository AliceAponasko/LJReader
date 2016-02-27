//
//  LJClient.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/21/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import Foundation
import Alamofire
import AEXML

typealias LJCompletionHandler = (success: Bool, result: [FeedEntry]?, error: NSError?) -> ()

class LJClient {
    static let sharedInstance = LJClient()
    
    func get(path: String, parameters: Dictionary<String, AnyObject>?, completion: LJCompletionHandler) {
        request(.GET, path: path, parameters: parameters, completion: completion)
    }
    
    func request(method: Alamofire.Method,
        path: String,
        parameters: Dictionary<String, AnyObject>? = nil,
        completion: LJCompletionHandler) {
            let urlString = "https://\(path).livejournal.com/data/rss"
            
            guard let fullURLString = NSURL(string: urlString)?.absoluteString else {
                completion(success: false, result: nil, error: nil)
                return
            }
            
            Alamofire.request(method,
                fullURLString,
                parameters: parameters,
                encoding: .JSON,
                headers: nil)
                .response(completionHandler: { request, response, data, error in
                    log.debug(request)
                    
                    if error == nil {
                        guard let responseData = data else {
                            completion(success: false, result: nil, error: error)
                            return
                        }
                        
                        var resultArray = [FeedEntry]()
                        
                        do {
                            let xmlDoc = try AEXMLDocument(xmlData: responseData)
                            let channel = xmlDoc.root["channel"]
                            
                            let author = channel["lj:journal"].stringValue
                            
                            for item in channel.children {
                                if item.name == "item" {
                                    let feedEntry = FeedEntry()
                                    feedEntry.author = author
                                    feedEntry.pubDate = item["pubDate"].stringValue
                                    feedEntry.link = item["link"].stringValue
                                    feedEntry.description = item["description"].stringValue
                                    feedEntry.title = item["title"].stringValue
                                    
                                    resultArray.append(feedEntry)
                                }
                            }
                        } catch {
                            log.error("Failed to parse feed for request: \(request) with error: \(error)")
                        }

                        completion(success: true, result: resultArray, error: nil)
                    } else {
                        log.error(error)
                        completion(success: false, result: nil, error: error)
                    }
                })
    }
}