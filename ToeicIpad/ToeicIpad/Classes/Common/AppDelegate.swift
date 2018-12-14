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
        var safeArea: UIEdgeInsets? = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safeArea = window?.safeAreaInsets
        }
        UserDefaults.standard.set(safeArea?.top, forKey: Global.SAFE_AREA_TOP)
        UserDefaults.standard.set(safeArea?.bottom, forKey: Global.SAFE_AREA_BOT)
        audioView?.frame =  CGRect(x: 0, y: (tabBarController?.tabBar.frame.origin.y)! - (safeArea?.bottom)!, width: Global.SCREEN_WIDTH, height:audioHeight)
        audioView?.isHidden = false
        audioView?.alpha = 1
        tabBarController?.view.addSubview(audioView!)
        tabBarController?.view.addSubview((tabBarController?.tabBar)!)
        
        return true
    }
    
    func createTabbars() -> Void {
        UserDefaults.standard.set(true, forKey: Global.IS_FIRST_LOGIN)
        let tabViewController1 = HomeViewController(
            nibName: "HomeViewController",
            bundle: nil)
        tabViewController1.tabBarItem.image = UIImage(named: "home")
        let nav = UINavigationController(rootViewController: tabViewController1)
        
        let thongKeVC = ThongKeViewController(
            nibName:"ThongKeViewController",
            bundle: nil)
        thongKeVC.tabBarItem.image = UIImage(named: "thong_ke")
        let nav1 = UINavigationController(rootViewController: thongKeVC)
        thongKeVC.title = "Thống Kê"
        
        let settingVC = SettingViewController(
            nibName:"SettingViewController",
            bundle: nil)
        settingVC.tabBarItem.image = UIImage(named: "setting")
        settingVC.title = "Setting"
        let nav2 = UINavigationController(rootViewController: settingVC)
        
        let controllers = [nav,nav2]
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
    
    func openTestVCPart(part: Int, data: Any, index: Int, test: TestBook) -> Void {
        tabBarController?.selectedIndex = 0
        if let topVC = self.getTopMostViewController() {
            var listTestVC: ListTestViewController?
            if (topVC.isKind(of: HomeViewController.self)) {
                let homeVC = topVC as! HomeViewController
                listTestVC = ListTestViewController(nibName: "ListTestViewController", bundle: nil)
                listTestVC!.type = part
                updateListTest(listTestVC: listTestVC!, part: part, data: data, test: test, index: index)
                homeVC.navigationController?.pushViewController(listTestVC!, animated: true)
            }
            else if (topVC.isKind(of: ListTestViewController.self)) {
                listTestVC = topVC as? ListTestViewController
                updateListTest(listTestVC: listTestVC!, part: part, data: data, test: test, index: index)
                listTestVC!.type = part
                listTestVC!.title = String(format: "Part %d", part)
                listTestVC?.openTest()
            }
          
        }
    }
    
    func updateListTest(listTestVC: ListTestViewController, part: Int, data: Any, test: TestBook, index: Int) -> Void {
        switch part {
        case 1:
            let part1VC = Part1ViewController(nibName: "Part1ViewController", bundle: nil)
            part1VC.part1Datas = data as! Array<QuestionPart1>
            part1VC.indexTest = index
            part1VC.testData = test
            listTestVC.openTestPart = 1
            listTestVC.part1VC = part1VC
            break
        case 2:
            let part2VC = Part2ViewController(nibName: "Part2ViewController", bundle: nil)
            part2VC.part2Datas = data as! Array<QuestionPart2>
            part2VC.indexTest = index
            part2VC.testData = test
            listTestVC.openTestPart = 2
            listTestVC.part2VC = part2VC
            break
            break
        case 3:
            break
        case 4:
            break
        default:
            break
        }
    }
    

    
    func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }


}

