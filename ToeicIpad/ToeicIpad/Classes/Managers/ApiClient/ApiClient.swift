//
//  APIClient.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/7/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class ApiClient {
    
    var baseUrl = "http://testcrm.tomorrowmarketers.org/";
    static let shareClient: ApiClient = ApiClient()
    
    private init() {
        
    }

     func callMethod(method:String, withParams:NSDictionary, completionHandler: @escaping(Data?,Error?) -> Swift.Void) -> Swift.Void {

        let urlString: String = String(format: "%@%@", baseUrl, method)
    
        guard URL(string: urlString) != nil else {
            print("Error: cannot create URL")
            return
        }
        
        var urlComponents = URLComponents(string: urlString)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in withParams {
            queryItems.append(URLQueryItem(name: key as! String, value: value as? String))
        }
        urlComponents?.queryItems = queryItems
        var urlRequest = URLRequest(url: (urlComponents?.url)!)
        
        //urlRequest.setValue(signature, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                completionHandler(nil,error)
                return
            }
            completionHandler(data,error)
        }
        task.resume()
    }
    
    
    
}
