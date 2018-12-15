//
//  FileUtil.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/9/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class FileUtil: NSObject {
    class func pathOfFile(fileName: String) -> String {
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        print(documentsUrl)
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        return destinationFileUrl.path
    }
    
    class func urlOfFile(fileName: String) -> URL {
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        print(documentsUrl);
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        return destinationFileUrl
    }
    
    class func dataFromPath(path:String) -> NSData {
        return NSData()
    }
    
    class func fileExitsAtpath(filePath: String) -> Bool {
        return  FileManager.default.fileExists(atPath: filePath as String)
    }
    
    class func fileExitsAtName(fileName: String) -> Bool {
      
        let path = FileUtil.pathOfFile(fileName: fileName)
        let fileExits = FileManager.default.fileExists(atPath: path)
        return fileExits
    }
    
    class func copyFileFromPath(srcPath:String, toPath:String) -> Bool {
        return true
    }
    
    class func deleteFileAtpath(path:String) -> Bool {
        
        return ( ((try? FileManager.default.removeItem(atPath: path as String)) != nil))
    }
    
    class func createDirectoryAtPath(path:String, withAtributes:NSDictionary) -> Bool {
        return true
    }
    
    class func createFileAtPath(path:String, data:NSData, atribures:NSDictionary) -> Bool {
        return true
    }
    
    class func contentsOfDirectoryAtPath(path:String) -> NSArray {
        return NSArray()
    }
    
    class func checkDocumentFileExistsWithName(fileName:String) -> Bool {
        return true
    }
    
    class func removeDocumentsFileWithName(fileName:String) -> Bool {
        
        return ( ((try? FileManager.default.removeItem(atPath: self.pathOfFile(fileName: fileName) as String)) != nil))
    }
    
    class func removeDocumentsFileWithPath(filePath:String) -> Bool {
        return true
    }
    
    
    
}
