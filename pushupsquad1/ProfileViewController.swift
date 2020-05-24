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
    override func viewDidLoad() {
        super.viewDidLoad()
            title = "Profile"
        let user = Auth.auth().currentUser
         let uid = user?.uid ?? " "
        displayNameText.text = user?.displayName ?? "Unkown User"
       let creationDate = user?.metadata.creationDate
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMMM YYYY" //Joined April 2020
        creationDateText.text = dateFormatter.string(from: creationDate ?? Date()) // Set creation date text
       guard let imageURL = user?.photoURL else { return }

                // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.profieImage.image = image
                }
            }
        profieImage.layer.cornerRadius = profieImage.frame.height/2
        profieImage.clipsToBounds = true
//        setImage (from: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png" )
    }
    
    @IBAction func userSignOutTapped(_ sender: Any) {
        // Create UIAlertController
        let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
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
