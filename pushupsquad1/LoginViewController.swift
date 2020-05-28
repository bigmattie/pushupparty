//
//  LoginViewController.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/8/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Hide facebook button
        #if DEBUG
        facebookLoginButton.isHidden = false
        appleLoginButton.isHidden = false
        #else
        facebookLoginButton.isHidden = true
        appleLoginButton.isHidden = true
        #endif
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                  if user == nil {
                    
                 } else {
                    
                    self.finishLogin()
                 }
            }
    }
    
    func anonSignIn(_ sender: Any) {
       Auth.auth().signInAnonymously() { (authResult, error) in
         // ...
//        guard let user = authResult?.user else { return }
//        let isAnonymous = user.isAnonymous  // true
//        let uid = user.uid
//        print("UID UID UID", uid, "   ANONON", isAnonymous)
        self.finishLogin()
       }
    }
    func showGuestLoginActionSheet() {
//    let optionMenu = UIAlertController(title: "Are you sure you want to Continue?", message: "If you continue as a guest your Stats may not be saved", preferredStyle: .alert)
//    let deleteAction = UIAlertAction(title: "Continue as Guest", style: .destructive, handler: anonSignIn)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//    optionMenu.addAction(deleteAction)
//    optionMenu.addAction(cancelAction)
//    self.present(optionMenu, animated: true, completion: nil)
        self.anonSignIn(self)
    }
    
    func finishLogin() {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    @IBAction func guestLogin(_ sender: Any) {
        showGuestLoginActionSheet()
    }
    

    @IBAction func facebookLogin(_ sender: Any) {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
          if let error = error {
            print("Failed to login: \(error.localizedDescription)")
            return
          }
            guard let accessToken = AccessToken.current else {
            print("Failed to get access token")
            return
          }
          let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
          
        // Perform login by calling Firebase APIs
          Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
              print("Login error: \(error.localizedDescription)")
              let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
              let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              alertController.addAction(okayAction)
              self.present(alertController, animated: true, completion: nil)
              return
            }
            // self.performSegue(withIdentifier: self.signInSegue, sender: nil)
            
            self.finishLogin()
            NSLog("completed")
          }
            
            NSLog("finished login")
        }

        
    }
    
    @IBAction func appleLogin(_ sender: Any) {
        print("Apple Login")
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
