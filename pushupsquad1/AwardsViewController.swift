//
//  AwardsViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/7/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit

class AwardsViewController: UIViewController {
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"
                
        
        
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func tappedBrowseDaily(_ sender: Any) {
                if let url = URL(string: "https://bit.ly/2LTRD7t") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func tappedInviteFriend(_ sender: Any) {
        let tryItURL = "https://bit.ly/2LTRD7t" //Update to appstore URL
        let sms: String = "sms:&body=I found this new pushup app, i think you should try it too because its cool. " + tryItURL
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
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