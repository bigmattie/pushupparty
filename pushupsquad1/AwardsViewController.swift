//
//  AwardsViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/7/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit
import SafariServices

class AwardsViewController: UIViewController {
    
    @IBOutlet weak var browseDailyButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var tableView: UITableView!
    var challenges: [String] = ["Booty","Bootyx"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"
        browseDailyButton.isHidden = true

       challenges.append("Obama")

       
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           print("Not printing")
           print(challenges)
           return challenges.count
           
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           print(indexPath)
           let challengeTitle = challenges[indexPath.row]
           let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
           cell.videoTitle.text = challengeTitle
           return cell
       }
    @IBAction func tappedBrowseDaily(_ sender: Any) {

        
    }
    @IBAction func tappedInviteFriend(_ sender: Any) {
        let tryItURL = "https://bit.ly/pushuppartyapp" //Update to appstore URL
        let sms: String = "sms:&body=I found this new pushup app, makes it easy to keep up with your pushups. " + tryItURL
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    /*
     // MARK: - Navigation
     
     */
    
}

extension AwardsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Not printing")
//        print(challenges)
//        return challenges.count
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath)
//        let challengeTitle = challenges[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
//        cell.videoTitle.text = challengeTitle
//        return cell
//    }
//
    
    
}

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoTitle: UILabel!
}
