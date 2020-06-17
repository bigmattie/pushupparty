//
//  ChallengesViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/30/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit
import Firebase
class ChallengesViewController: UIViewController {
    @IBOutlet weak var challengeOneLabel: UILabel!
    @IBOutlet weak var challengeTwoLabel: UILabel!
    @IBOutlet weak var challengeThreeLabel: UILabel!
    
    @IBOutlet weak var challengeOneProgress: CustomProgessBar!
    @IBOutlet weak var challengeTwoProgress: CustomProgessBar!
 
    @IBOutlet weak var challengeThreeProgress: CustomProgessBar!
    @IBOutlet weak var challengeOneImg: UIImageView!
    @IBOutlet weak var challengeTwoImg: UIImageView!
    @IBOutlet weak var challengeThreeImg: UIImageView!
    
    var AllTimePushup = 0
    var AllTimePushupTime = 0
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadView()
        AllTimePushup = 0
        AllTimePushupTime = 0
        
        title = "Challenges"
        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser //Get current User
        let uid = user?.uid ?? " " //Get current users UID
        callFirebaseForChallenge()


    }
    func callFirebaseForChallenge() {
                db.collection("users").document(Auth.auth().currentUser?.uid ?? " ").collection("sessions").addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error  \(err)")
                    } else {
                        self.AllTimePushup = 0
                        self.AllTimePushupTime = 0
                        
                        for document in querySnapshot!.documents {
                        //ALL TIME PUSHUPS COUNT
                        let oldAllTimePushupCount = self.AllTimePushup
                        let allTimePushupsFromFirebase = document["numberOfPushups"] as! Int
                        self.AllTimePushup = oldAllTimePushupCount + allTimePushupsFromFirebase
                        //ALL TIME PUSHUPS TIME
                        let oldAllTimePushupsTime = self.AllTimePushupTime
                        let allTimePushupsTimeFromFirebase = (document["pushupsTime"] as? NSString ?? "0").integerValue
                            self.AllTimePushupTime = oldAllTimePushupsTime + allTimePushupsTimeFromFirebase }
                        print("Alltime pushups",self.AllTimePushup)
                    }
                
                    print("SET VALUES")
        //            let minutes = String(Int(self.AllTimePushupTime / 60))
      self.setValuesForChallenge()
      self.setChallengeBars()
                }
        
    }
    func setChallengeBars() {
        //set progress bar amount

        challengeOneProgress.setProgress(Float(Double(AllTimePushup) / 100), animated:true)
        challengeTwoProgress.setProgress(Float(Double(AllTimePushup) / 1000), animated: true)
        challengeThreeProgress.setProgress(Float(Double(AllTimePushup) / 10000), animated: true)

            }
    func setValuesForChallenge() {
        
            //Get All Time Values
                    let allTimePushupsString = String(100 - self.AllTimePushup) //+  " Pushups "
                   let pushupsLeftOne = (100 - self.AllTimePushup)
                    let pushupsLeftTwo = Int(1000 - self.AllTimePushup)
                    let pushupsLeftThree = Int(10000 - self.AllTimePushup)
                    if (0 >= pushupsLeftOne) {
                         self.challengeOneLabel.text = "Challenge Completed"
                        self.challengeOneImg.alpha = 1
                        self.challengeOneImg.image = UIImage(named: "unlockedChallenge")
                        
                    } else {
                        let convertedLeft = String(100 - self.AllTimePushup)
                        self.challengeOneLabel.text = String(Int(100 - self.AllTimePushup)) + " Pushups to go"
                        self.challengeOneImg.alpha = 0.3
                        self.challengeOneImg.image = UIImage(named: "lockedChallenge")
                    }
                    
                    if (0 >= pushupsLeftTwo) {
                          self.challengeTwoLabel.text = "Challenge Completed"
                        self.challengeTwoImg.alpha = 1
                         self.challengeTwoImg.image = UIImage(named: "unlockedChallenge")
                    } else {
                         self.challengeTwoLabel.text = String(Int(1000 - self.AllTimePushup)) + " Pushups to go"
                     self.challengeTwoImg.alpha = 0.3
                        self.challengeTwoImg.image = UIImage(named: "lockedChallenge")
                    }
                    if (0 >= pushupsLeftThree) {
                     self.challengeThreeLabel.text = "Challenge Completed"
                        self.challengeThreeImg.alpha = 1
                         self.challengeThreeImg.image = UIImage(named: "unlockedChallenge")
                    } else {
                        
                           self.challengeThreeLabel.text = String(Int(10000 - self.AllTimePushup)) + " Pushups to go"
                        self.challengeThreeImg.alpha = 0.3
                        self.challengeThreeImg.image = UIImage(named: "lockedChallenge")
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
