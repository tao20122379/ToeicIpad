//
//  TestRouter.swift
//  ToeicIpad
//
//  Created by DungLM3 on 3/19/19.
//  Copyright © 2019 DungLM3. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


public enum LoginRouter:URLRequestConvertible{
    
    case defaultVOF()
    case getAESkey()
    case login([String:Any])
    
    var method:HTTPMethod{
        switch self {
        case .getAESkey():
            return .post
        default:
            return .get
        }
        return .post
    }
    
    
    var path:String{
        switch self {
        case .getAESkey:
            return "Authenticate/getRsaKeyPublic"
        case .login:
            return "Authenticate/login"
        default:
            return ""
        }
    }
    
    var parameters:[String:Any]{
        
        switch self {
        case .getAESkey:
            return [:]
        case .login(let parameter):
            return parameter
        default:
            return [:]
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {

        let urlStr = "ServiceMobile_V02/resources/"
        let url = try urlStr.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        
        request.timeoutInterval = TimeInterval(30 * 1000)
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //"application/json"
        
        switch self {
        case .login:
          
            let bodyDataStr = "data=()d&publicRsaKey= ()&aesKey=()&isIos=1"
            request.httpBody = bodyDataStr.data(using: .utf8)!
            
            return try URLEncoding.default.encode(request, with: nil)
            
        default:
            break
        }
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}

