//
//  AppDelegate.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audioView: AudioView?
    let audioHeight: CGFloat = 80
    var tabBarController: UITabBarController?
    var audioIsShow: Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
      
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        self.createTabbars()
        let nav = UINavigationController(rootViewController: tabBarController!)
        window?.rootViewController = nav
        nav.navigationBar.isHidden = true
        audioView = (Bundle.main.loadNibNamed("AudioView", owner: self, options: nil)?.first as! AudioView)
        audioView?.frame =  CGRect(x: 0, y: Global.SCREEN_HEIGHT-49, width: Global.SCREEN_WIDTH, height:audioHeight)
        audioView?.isHidden = false
        audioView?.alpha = 1
        tabBarController?.view.addSubview(audioView!)
        tabBarController?.view.addSubview((tabBarController?.tabBar)!)
        
        return true
    }
    
    func createTabbars() -> Void {
     
        let tabViewController1 = HomeViewController(
            nibName: "HomeViewController",
            bundle: nil)
        tabViewController1.tabBarItem.image = UIImage(named: "home")
        let nav = UINavigationController(rootViewController: tabViewController1)
        
        let tabViewController2 = FirstViewController(
            nibName:"FirstViewController",
            bundle: nil)
        tabViewController2.tabBarItem.image = UIImage(named: "thong_ke")
        let nav1 = UINavigationController(rootViewController: tabViewController2)
        tabViewController2.title = "Thống Kê"
        
        let tabViewController3 = FirstViewController(
            nibName:"FirstViewController",
            bundle: nil)
        tabViewController3.tabBarItem.image = UIImage(named: "setting")
        tabViewController3.title = "Setting"
        let nav2 = UINavigationController(rootViewController: tabViewController3)
        
        let controllers = [nav,nav1,nav2]
        tabBarController = UITabBarController()
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.viewControllers = controllers
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func showAudioView() -> Void {
        UIView.animate(withDuration: 0.5) {
            self.audioView?.transform = CGAffineTransform(translationX: 0, y: -80)
        }
        audioIsShow = true
    }
    
    func hideAidoView() -> Void {
        UIView.animate(withDuration: 0.5, animations: {
            self.audioView?.transform = CGAffineTransform(translationX: 0, y: 0)
        })
          audioIsShow = false
    }


}

