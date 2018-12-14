//
//  DownloadClient.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/8/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

public protocol DownloadClientDelegate {
    @available(iOS 2.0, *)
    func downloadClientProgressHandler(progress:Float,fileSize:Float)
    func downloadClientErrorHandler(error:NSError?)
    func downloadClientCompleteHandler(filePath:String)
}

class DownloadClient: NSObject,UITableViewDelegate {
    
    var delegate:DownloadClientDelegate?
    var fileName: String = ""
    
    static let shareClient: DownloadClient = DownloadClient()
    
    override init() {
    }
    
    func downloadImage(name:String, completionHandler: @escaping(URL?,Error?) -> Swift.Void) -> Swift.Void {
        fileName = name;
        let urlStr = String(format: "%@image/%@", Global.BASE_URL, fileName)
        let fileURL = URL(string: urlStr)
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "bgSessionConfigurationImage")
        sessionConfig.timeoutIntervalForRequest = 3.0;
        sessionConfig.timeoutIntervalForResource = 6.0;
        let session = URLSession(configuration: sessionConfig, delegate: self,delegateQueue: nil)
        let task = session.downloadTask(with: fileURL!)
        //print(String(format: "threed: %@", Thread.current.name))
        task.resume()
    }
    
    
    func downloadAudio(name:String, completionHandler: @escaping(URL?,Error?) -> Swift.Void) -> Swift.Void {
        fileName = name;
        let urlStr = String(format: "%@audio/%@", Global.BASE_URL, fileName)
        let fileURL = URL(string: urlStr)
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "bgSessionConfigurationAudio")
        sessionConfig.timeoutIntervalForRequest = 3.0;
        sessionConfig.timeoutIntervalForResource = 6.0;

        let session = URLSession(configuration: sessionConfig, delegate: self,delegateQueue: nil)
        let task = session.downloadTask(with: fileURL!)
        task.resume()
    }
    
    
    func downloadTests(compleHandler: @escaping(Bool?) -> Swift.Void) -> Swift.Void {
        let params = NSMutableDictionary()
        ApiClient.shareClient.callMethod(method: "test-book/search", withParams: params) { (data, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                    json.forEach({ (bookData) in
                        TestManager.addTest(testData: bookData as NSDictionary)
                    })
                    if (json.count > 0) {
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }catch {
                    print(error)
                    compleHandler(false)
                }
            } else {
                  compleHandler(false)
            }
        }
    }
    
    func downloadDataPart1(test: TestBook, compleHandler: @escaping(_ isDownload: Bool) -> Void) {
        let params = NSMutableDictionary()
        params.setValue(String(format: "%d", test.test_id), forKey: "test_id")
        
        ApiClient.shareClient.alamofireCallMethod(method: "question-part1/search", withParams: params) { (response: DataResponse<Any>) in
            switch (response.result) {
            case .success(_):
                if (response.result.value != nil) {
                    let datas = response.result.value as! Array<NSDictionary>
                    datas.forEach({ (data) in
                        QuestionPart1Manager.addQuestion1(data: data )
                        self.alamofireDownloadImage(name: data["image_name"] as! String)
                    })
                    if (datas.count > 0) {
                        TestManager.updateDataTest(test: test, part: 1)
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }
                break
            case .failure(_):
                compleHandler(false)
                break
            }
        }
    }
    
    func downloadDataPart2(test: TestBook, compleHandler: @escaping(_ isDownload: Bool) -> Void) {
        let params = NSMutableDictionary()
        params.setValue(String(format: "%d", test.test_id), forKey: "test_id")
        ApiClient.shareClient.alamofireCallMethod(method: "question-part2/search", withParams: params) { (response: DataResponse<Any>) in
            switch (response.result) {
            case .success(_):
                if (response.result.value != nil) {
                    let datas = response.result.value as! Array<NSDictionary>
                    datas.forEach({ (data) in
                        QuestionPart2Manager.addQuestion2(data: data )
                    })
                    if (datas.count > 0) {
                        TestManager.updateDataTest(test: test, part: 2)
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }
                break
            case .failure(_):
                compleHandler(false)
                break
            }
        }
    }
    
    func downloadPassagePart3(test: TestBook, compleHandler: @escaping(_ isDownload: Bool) -> Void) {
        
        let params = NSMutableDictionary()
        params.setValue(String(format: "%d", test.test_id), forKey: "test_id")
        ApiClient.shareClient.alamofireCallMethod(method: "passage-part3/search", withParams: params) { (response: DataResponse<Any>) in
            switch (response.result) {
            case .success(_):
                if (response.result.value != nil) {
                    let datas = response.result.value as! Array<NSDictionary>
                    datas.forEach({ (data) in
                        QuestionPart3Manager.addPart3Passage(data: data)
                    })
                    if (datas.count > 0) {
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }
                break
            case .failure(_):
                compleHandler(false)
                break
            }
        }
    }
    
    func downloadDataPart3(test: TestBook, compleHandler: @escaping(_ isDownload: Bool) -> Void) {
        let params = NSMutableDictionary()
        params.setValue(String(format: "%d", test.test_id), forKey: "test_id")
        ApiClient.shareClient.alamofireCallMethod(method: "question-part3/search", withParams: params) { (response: DataResponse<Any>) in
            switch (response.result) {
            case .success(_):
                if (response.result.value != nil) {
                    let datas = response.result.value as! Array<NSDictionary>
                    datas.forEach({ (data) in
                        QuestionPart3Manager.addPart3Question(data: data )
                    })
                    if (datas.count > 0) {
                        TestManager.updateDataTest(test: test, part: 3)
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }
                break
            case .failure(_):
                compleHandler(false)
                break
            }
        }
    }
    
    func downloadPassagePart4(test_id:String, compleHandler: @escaping(_ isDownload: Bool) -> Void) {
        let params = NSMutableDictionary()
        params.setValue(test_id, forKey: "test_id")
        ApiClient.shareClient.callMethod(method: "passage-part4/search", withParams: params) { (data, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                    json.forEach({ (question1Data) in
                        QuestionPart4Manager.addPart4Passage(data: question1Data as NSDictionary)
                    })
                    if (json.count > 0) {
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }catch {
                    print(error)
                    compleHandler(false)
                }
            } else {
                    compleHandler(false)
            }
        }
    }
    

    
    func downloadQuesionPart4(test_id:String, compleHandler: @escaping(_ isDownload: Bool) -> Void) {
        let params = NSMutableDictionary()
        params.setValue(test_id, forKey: "test_id")
        ApiClient.shareClient.callMethod(method: "question-part4/search", withParams: params) { (data, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                    json.forEach({ (question1Data) in
                        QuestionPart4Manager.addPart4Question(data: question1Data as NSDictionary)
                    })
                    if (json.count > 0) {
                        compleHandler(true)
                    } else {
                        compleHandler(false)
                    }
                }catch {
                    print(error)
                    compleHandler(false)
                }
            } else {
                compleHandler(false)
            }
        }
    }
    
    func alamofireDownloadImage(name: String) -> Void {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(name)
            return (documentsURL, [.removePreviousFile])
        }
        let urlStr = String(format: "%@image/%@", Global.BASE_URL, name)
        Alamofire.download(urlStr, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("destinationUrl \(destinationUrl.absoluteURL)")
            }
        }
    }
    
    func alamofireDownloadAudio(name: String, compleHandler: @escaping(_ loadAudio: Bool) -> Void) -> Void {
        let audioUrl = String(format: "%@audio/%@", Global.BASE_URL, name)
        let fileUrl = self.getSaveFileUrl(fileName: audioUrl)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(audioUrl, to:destination)
            .downloadProgress { (progress) in
                //self.progressLabel.text = (String)(progress.fractionCompleted)
            }
            .responseData { (data) in
                switch (data.result) {
                case .success(_):
                    compleHandler(true)
                    break
                case .failure(_):
                    compleHandler(false)
                    break
                }
        }
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
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





