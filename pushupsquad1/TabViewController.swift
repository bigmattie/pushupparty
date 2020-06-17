//
//  TabViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/8/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit
import UserNotifications

class TabViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = false
        // Do any additional setup after loading the view.
        
        //Enable Notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in

            // If granted comes true you can enabled features based on authorization.
            guard granted else { return }
            // tell the user how to enable notifications TODO
            
            
        }
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in

            switch setttings.soundSetting{
            case .enabled:
               
                print("enabled sound")
                print(setttings.authorizationStatus)

            case .disabled:
                print("not allowed notifications")

            case .notSupported:
                print("something went wrong here")
            default:
                print("unknown")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
