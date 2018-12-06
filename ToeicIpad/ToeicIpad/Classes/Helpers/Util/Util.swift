//
//  Util.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import Foundation
import UIKit

class Util{
     internal  func RGBA2UIColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    internal  func Rgb2UIColor(red: Int, green: Int, blue: Int) -> UIColor{
        return RGBA2UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func  hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class internal  func SetContraintCustomViewAlert(alertVC:UIAlertController, customView:UIView) ->Swift.Void{
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customView.centerXAnchor.constraint(equalTo: (alertVC.view.centerXAnchor)).isActive = true
        customView.topAnchor.constraint(equalTo: (alertVC.view.topAnchor)).isActive = true
        customView.bottomAnchor.constraint(equalTo: (alertVC.view.bottomAnchor), constant: -32).isActive = true
    }
    
    class func showPopover(popVC:UIViewController, root:Any, sender: UIButton, size: CGSize) -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       // guard let vc else {return}
        popVC.view.backgroundColor = UIColor.white
        
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = root as? UIPopoverPresentationControllerDelegate
        popOverVC?.permittedArrowDirections = UIPopoverArrowDirection.down
        popOverVC?.sourceView = sender
        popOverVC?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = size
        appDelegate.tabBarController?.present(popVC, animated: true)
    }
}




