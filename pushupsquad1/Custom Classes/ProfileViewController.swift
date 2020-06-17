//
//  ProfileViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/7/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profieImage: UIImageView!
    let db = Firestore.firestore()
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var displayNameText: UILabel!
    @IBOutlet weak var creationDateText: UILabel!
    @IBOutlet weak var buildVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
            title = "Profile"
        buildVersion.text = "App Version: " + String(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-.--")
       
        let user = Auth.auth().currentUser
        let uid = user?.uid ?? " "
        displayNameText.text = user?.displayName ?? "Unknown User"
        let isAnon = user?.isAnonymous
        if (isAnon == true)
        {
            displayNameText.text = "Guest User"
        }
        
       let creationDate = user?.metadata.creationDate
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMMM YYYY" //Joined April 2020
        creationDateText.text = "Joined: " +  dateFormatter.string(from: creationDate ?? Date()) // Set creation date text
    
        // checks if the user doesnt have a profile photo
        if (user?.photoURL?.absoluteString == nil) {
            //if the user doesnt have a PHOTO URL we set it to the default image
            self.profieImage.image = UIImage(named: "1024.png")
            
        } else {
            //if the user deos have a profile URL image we get it
            guard let imageURL = user?.photoURL else { return }

                     // just not to cause a deadlock in UI!
                 DispatchQueue.global().async {
                     guard let imageData = try? Data(contentsOf: imageURL) else { return }
                         
                     let image = UIImage(data: imageData)
                     DispatchQueue.main.async {
                         self.profieImage.image = image
                         
                     }
                 }
            
        }

        profieImage.layer.cornerRadius = profieImage.frame.height/2
        profieImage.clipsToBounds = true
//        setImage (from: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png" )
    }
    
    @IBAction func userSignOutTapped(_ sender: Any) {
        // Create UIAlertController
        let optionMenu = UIAlertController(title: "Continue with Log Out?", message: "If you are logged in as a Guest User then you wont be able to get your stats back", preferredStyle: .alert)
        // Declare Actions
        let deleteAction = UIAlertAction(title: "Log Out", style: .destructive, handler: signOut) //Sign out method called later
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // Add Actions to UIAlertController
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        // Show UIAlertController
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func signOut(_ action: UIAlertAction) {
        LoginManager().logOut()
        KeychainItem.deleteUserIdentifierFromKeychain()
        
        let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                NSLog("signed out")
                performSegue(withIdentifier: "logoutSegue", sender: self)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
    }


}
