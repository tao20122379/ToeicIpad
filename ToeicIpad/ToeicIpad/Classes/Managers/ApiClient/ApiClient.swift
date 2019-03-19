//
//  APIClient.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/7/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import Alamofire

class ApiClient {
    
    var baseUrl = "http://testcrm.tomorrowmarketers.org/";
    var timeOut = 10
    static let shareClient: ApiClient = ApiClient()
    
    private init() {
        
    }

    func alamofireCallMethod(method:String, withParams:NSDictionary, completionHandler: @escaping(DataResponse<Any>) -> Swift.Void) -> Swift.Void {
        let urlString: String = String(format: "%@%@", baseUrl, method)
        
        guard URL(string: urlString) != nil else {
            print("Error: cannot create URL")
            return
        }
        
        var urlComponents = URLComponents(string: urlString)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in withParams {
            queryItems.append(URLQueryItem(name: key as! String , value: value as? String))
        }
        urlComponents?.queryItems = queryItems
        var urlRequest = URLRequest(url: (urlComponents?.url)!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = Global.TIMEOUT_INTERVAL
        
        Alamofire.request(urlRequest).responseJSON { (response: DataResponse<Any>) in
            completionHandler(response)
        }
        
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
        urlRequest.timeoutInterval = Global.TIMEOUT_INTERVAL
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
  

    public func asURLApiRequest(path:String,withParams parameters:[String:Any]?,andMethod method:HTTPMethod, timeOut time:Int ) throws -> URLRequest {

        let link = baseUrl
        
        let url = try link.asURL()
        
        let newpath = path.replacingOccurrences(of: ".", with: "/")
        var request = URLRequest(url: url.appendingPathComponent(newpath))
        request.httpMethod = method.rawValue
        
        var timeout = time
        if timeout <= 0 {
            timeout = timeOut
        }
        request.timeoutInterval = TimeInterval(timeout)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
       // let language = Defaults[UserDefaultsKey.languageKey]
        // request.setValue(language, forHTTPHeaderField: "Accept-Language")
        var params = parameters as [String:Any]?
        
//        if let consumerKey = Defaults.object(forKey: MyConstant.CONSUMER_KEY) as? String {
//            params?.updateValue(consumerKey, forKey: "consumerKey")
//        }
        
//        if let token = Defaults.object(forKey: MyConstant.TOKEN_KEY) as? String {
//            params?.updateValue(token, forKey: "token")
//        }
        
//        if let nonce = Defaults.object(forKey: MyConstant.NONCE_KEY) as? String {
//            params?.updateValue(nonce, forKey: "nonce")
//        }
        
       // if Defaults.bool(forKey: MyConstant.PRINT_DATA) {
            print("\n-----Method \(newpath) \n\n-----params \(params ?? [:])\n\n")
     //   }
        
        return try JSONEncoding.default.encode(request, with: params)
        
    }
    
    
}
