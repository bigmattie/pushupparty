//
//  ViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/2/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class ViewController: UIViewController {
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var numberOfPushups: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var quitBarButton: UIBarButtonItem!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var counter = 0.0
    var timer = Timer()
    var isPlaying = false
    var currentPushups = 0
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    let date = Date()
    var newPushups = 0
    var oldPushups = 0
    var allPushups = 0
    var allPushupsTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("connected")
        
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? " " //get uid from firebase
        finishButton.isHidden = true
        dismissButton.isHidden = true
        newPushups = 0
        counter = 0
        oldPushups = 0
        counter = 0.0
        allPushupsTime = 0
        allPushups = 0
        // Proximity Sensor Listener
        NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        
        //Timer
        timeLabel.text = String(counter)
        
        //prevent swipe down
        isModalInPresentation = true
        
        
    }
    
    func dismissOut(_ action: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }
    
    //Start Button
    @IBAction func startTapped(_ sender: Any) {
        NSLog("Start session")
        UIDevice.current.isProximityMonitoringEnabled = true
        finishButton.isHidden = false
        startButton.isHidden = true
        quitBarButton.accessibilityElementsHidden = true
        
        //Timer
        if(isPlaying) {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        
    }
    
    @IBAction func quitButtonTapped(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to quit?", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Quit", style: .destructive, handler: dismissOut)
        
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(deleteAction)
        
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    //Finish Button
    @IBAction func finishTapped(_ sender: Any) {
        NSLog("End session")
        dismissButton.isHidden = false
        UIDevice.current.isProximityMonitoringEnabled = false
        finishButton.isHidden = true
        
        //        startButton.isHidden = false
        timer.invalidate()
        isPlaying = false
        //grab current user info from firbease
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? " " //get uid from firebase
        let displayName = user?.displayName ?? "! "
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateString = dateFormatter.string(from: Date())
        //save pushup session in firebase
        db.collection("users").document(uid).collection("sessions").addDocument(data: [
            "date": date,
            "dateString": dateString,
            "pushupsTime": String(format: "%.1f", counter),
            "numberOfPushups": self.newPushups,
            ])
        { err in if let err = err {
            print("Error adding document: \(err)")
        } else {
            
            print("SAVED ", self.newPushups, "for ", dateString)
            //if session sucessfully saved then get current all time pushups/time number
            self.topLabel.text = "Congrats" + displayName.components(separatedBy: " ")[0] + "! you just completed " + String(self.newPushups) + " Pushups in " + String(format: "%.1f", self.counter) + " seconds."
            
            }
        }
        setConfettiBackground()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        //        AudioServicesPlaySystemSound (1003);
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss(animated: true, completion: nil)
    }
    //Help Button
    @IBAction func helpButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "How does it work?", message: "Place your phone under your chest, perform a pushup.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    //Set Celebration background
    func setConfettiBackground() {
        let jeremyGif = UIImage.gifImageWithName("magenta")
        let imageView = UIImageView(image: jeremyGif)
        //        imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.sendSubviewToBack(imageView)
    }
    
    func getAllTimeFromFirebase() {
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? " " //get uid from firebase
        self.db.collection("users").document(uid).collection("allTime").document("zero").getDocument { (document, error) in
            if let document = document, document.exists {
                let getOldPushups = (document["numberOfPushups"] as! NSString).doubleValue //get old pushups
                let getOldTime = (document["pushupsTime"] as! NSString).doubleValue //get old total time
                //                        print("GET OLD PUSHUPS^^^^", getOldTime)
                
                self.allPushups = Int((getOldPushups) + Double(self.newPushups)) //add old pushups to new pushups (pushups from latest session)
                self.allPushupsTime = Int(getOldTime + Double(self.counter)) //rounds to int of combined, accurate down to nearest second
                //
                
                // save all time pushups
                let allRef = self.db.collection("users").document(uid).collection("allTime").document("zero")
                allRef.updateData([
                    "numberOfPushups": String(self.allPushups),
                    "pushupsTime": String(self.allPushupsTime)
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Updated all time pushups to " + String(self.allPushups) + " and all time pushup time to" + String(self.allPushupsTime))
                    }
                }
            } else {
                print("Document does not exist")
                let allRef = self.db.collection("users").document(uid).collection("allTime").document("zero")
                allRef.setData([
                    "numberOfPushups": String(self.allPushups),
                    "pushupsTime": String(self.allPushupsTime)
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Updated all time pushups to " + String(self.allPushups) + " and all time pushup time to" + String(self.allPushupsTime))
                    }
                }
            }
        }
    }
    //Proximity Sensor Logic
    @objc func proximityChanged(notification:NSNotification)
    {
        if UIDevice.current.proximityState {
            let currentPushups = numberOfPushups.text ?? "0"
            newPushups = (Int(currentPushups) ?? 0) + 1
            numberOfPushups.text = String(newPushups)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            // String of proximity state status NSLog(String(UIDevice.current.proximityState))
            // NSLog("Proximity true")
            NSLog(String(newPushups))
        } else {
            // NSLog("Proximity false")
        }
    }
    
    //Timer
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
    }
    
    
    
}

