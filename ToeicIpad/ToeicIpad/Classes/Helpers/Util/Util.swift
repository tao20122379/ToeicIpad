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
    
    class internal  func SetContraintCustomViewAlert(alertVC:UIAlertController, customView:UIView) ->Swift.Void{
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customView.centerXAnchor.constraint(equalTo: (alertVC.view.centerXAnchor)).isActive = true
        customView.topAnchor.constraint(equalTo: (alertVC.view.topAnchor)).isActive = true
        
        customView.bottomAnchor.constraint(equalTo: (alertVC.view.bottomAnchor), constant: -32).isActive = true
    }
    
}
