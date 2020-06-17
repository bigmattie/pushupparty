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
    @IBOutlet weak var segmentControlModes: UISegmentedControl!
    @IBOutlet weak var optionSelectedText: UILabel!
    @IBOutlet weak var demoGif: UIImageView!
    
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
    var doneBarButton: UIBarButtonItem!
    var selectedMode = 0
    
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
        counter = 0.5
        allPushupsTime = 0
        allPushups = 0
        selectedMode = 0
        
        
        let jeremyGif: UIImage = UIImage.gifImageWithName("pushupDemo")!
        demoGif.image = jeremyGif
        demoGif.isHidden = true
        
        
        optionSelectedText.text = "Normal Mode: as many pushups as you want"
        // Proximity Sensor Listener
        NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        
        //Set Timer inital Value
        timeLabel.text = secondsToHoursMinutesSeconds(seconds: Int(counter))
        
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
        //        quitBarButton.accessibilityElementsHidden = true
        self.navigationItem.leftBarButtonItem = nil
        segmentControlModes.isEnabled = false //disables the segment control to disable specific segmanets do this => segmentControlModes.setEnabled(false, forSegmentAt: 0)
         demoGif.isHidden = true
//        UIView.transition(with: demoGif, duration: 0.04,
//                          options: .showHideTransitionViews,
//            animations: {
//                self.demoGif.isHidden = true
//        })
        //Timer
        if(isPlaying) {
            return
        }
        //calls timer and UpdateTimer() function to increase by.1
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
        
        UIDevice.current.isProximityMonitoringEnabled = false //turn off  proximity sensor
        timer.invalidate() //stop time
        isPlaying = false //stop playing
        
        //Hide Buttons
        finishButton.isHidden = true
        dismissButton.isHidden = false
        self.navigationItem.rightBarButtonItem = nil
        demoGif.isHidden = true
        //show Done Button
        let button1 = UIBarButtonItem(title:"Done", style: .plain, target: self,  action: #selector(dismissButtonTapped(_:))) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        //        doneBarButton.title = "Done"
        //        self.navigationItem.rightBarButtonItem = doneBarButton
        
        //        startButton.isHidden = false
        
        //grab current user info from firbease
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? " " //get uid from firebase
        let displayName = user?.displayName ?? "!"
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
            self.optionSelectedText.text = "Congrats " +
                displayName.components(separatedBy: " ")[0] +
                "! You just completed " + String(self.newPushups) + " Pushups in " + secondsToHoursMinutesSeconds(seconds: Int(self.counter)) + "."
            
            }
        }
        setConfettiBackground()
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
        Vibrator.success()
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
        Vibrator.success()
        dismiss(animated: true, completion: nil)
    }
    //Help Button
    @IBAction func helpButtonTapped(_ sender: Any) {
        
//        let alert = UIAlertController(title: "How does it work?", message: "Place your phone under your chest, press start, then perform a pushup", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style:.cancel, handler: nil))
//        self.present(alert, animated: true)
        Vibrator.success()
        Vibrator.light()
    }
    
    //Segemented Controls (Pushup Options)
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        switch segmentControlModes.selectedSegmentIndex
        {
        case 0:
            optionSelectedText.text = "As many pushups as you want"
            selectedMode = 0
        case 1:
            optionSelectedText.text = "50 Pushups as fast as you can"
            selectedMode = 1
        case 2:
            optionSelectedText.text = "As many pushups as you can in 60 sec"
            selectedMode = 2
        default:
            optionSelectedText.text = "As many pushups as you want"
            selectedMode = 0
        }
    }
    
    //Proximity Sensor Logic
    @objc func proximityChanged(notification:NSNotification)
    {
        //if user is close...goes down for pushup
        if UIDevice.current.proximityState {
            //Logic for different modes from segmented options picker
            
            if (selectedMode == 0) {
                //Normal - Mode 0
                let currentPushups = numberOfPushups.text ?? "0"
                newPushups = (Int(currentPushups) ?? 0) + 1
                numberOfPushups.text = String(newPushups)
            } else if (selectedMode == 1) {
                //Mode 1
                let currentPushups = numberOfPushups.text ?? "0"
                newPushups = (Int(currentPushups) ?? 0) + 1
                numberOfPushups.text = String(newPushups)
                if (newPushups == 50) {
                    finishTapped(self)
                }
            } else if (selectedMode == 2) {
                //Mode 2
                let currentPushups = numberOfPushups.text ?? "0"
                newPushups = (Int(currentPushups) ?? 0) + 1
                numberOfPushups.text = String(newPushups)
                print("COUNTER", counter)
                if (counter >= 60) {
                    finishTapped(self)
                }
                
            }
            //Action on each pushup counted
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else {
            // NSLog("Proximity false")
            
        }
    }
    
    //Timer
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeLabel.text = secondsToHoursMinutesSeconds(seconds: Int(counter))
        if (selectedMode == 2) {
            if (counter >= 60) {
                finishTapped(self)
            }
            
        }
    }
    
    //Remove constraints
    func adjustConstraints() {
        
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
    
}

