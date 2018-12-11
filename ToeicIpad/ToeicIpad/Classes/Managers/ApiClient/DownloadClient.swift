//
//  DownloadClient.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/8/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import Foundation

public protocol DownloadClientDelegate {
    @available(iOS 2.0, *)
    func downloadClientProgressHandler(progress:Float,fileSize:Float)
    func downloadClientErrorHandler(error:NSError?)
    func downloadClientCompleteHandler(filePath:String)
}

class DownloadClient: NSObject,UITableViewDelegate {
    
    var delegate:DownloadClientDelegate?
    var baseUrl = "http://testyii.local/"
    var fileName:String = ""
    
    static let shareClient: DownloadClient = DownloadClient()
    
    override init() {
    }
    
    func downloadImage(name:String, completionHandler: @escaping(URL?,Error?) -> Swift.Void) -> Swift.Void {
        fileName = name;
        let urlStr = String(format: "%@image/%@", baseUrl, fileName)
        let fileURL = URL(string: urlStr)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3.0;
        sessionConfig.timeoutIntervalForResource = 6.0;
        let session = URLSession(configuration: sessionConfig, delegate: self,delegateQueue:  OperationQueue())
        let task = session.downloadTask(with: fileURL!)
        
        task.resume()
    }
    
    func downloadAudio(name:String, completionHandler: @escaping(URL?,Error?) -> Swift.Void) -> Swift.Void {
        fileName = name;
        let urlStr = String(format: "%@audio/%@", baseUrl, fileName)
        let fileURL = URL(string: urlStr)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3.0;
        sessionConfig.timeoutIntervalForResource = 6.0;
        let session = URLSession(configuration: sessionConfig, delegate: self,delegateQueue:  OperationQueue())
        let task = session.downloadTask(with: fileURL!)
        
        task.resume()
    }
    
    func downloadDataPart1(test_id:String) {
        let params = NSMutableDictionary()
        params.setValue(test_id, forKey: "test_id")
        ApiClient.shareClient.callMethod(method: "question-part1/search", withParams: params) { (data, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                    json.forEach({ (question1Data) in
                        QuestionPart1Manager.addQuestion1(data: question1Data as NSDictionary)
                        
                    })
                }catch {
                    print(error)
                }
            }
        }
    }
}

extension DownloadClient:URLSessionTaskDelegate,URLSessionDownloadDelegate{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            delegate?.downloadClientProgressHandler(progress: progress, fileSize: Float(totalBytesWritten))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationFileUrl)
            let filePath = destinationFileUrl.absoluteString as String
            delegate?.downloadClientCompleteHandler(filePath: filePath)
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
            
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if ((error) != nil){
            delegate?.downloadClientErrorHandler(error: error! as NSError)
        }
        delegate?.downloadClientErrorHandler(error: NSError())
    }
    
}

struct Question1: Codable {
    var id = ""
    var test_id = ""
    var image_url = ""
    var answerA = ""

}





