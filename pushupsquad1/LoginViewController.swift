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
import AuthenticationServices //APPLE LOGIN
import CryptoKit


class LoginViewController: UIViewController {
    var child: SpinnerViewController!
    
    var handle: AuthStateDidChangeListenerHandle?
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    

    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var guestLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    @IBAction func guestLoginButton(_ sender: Any) {
    }
    @IBOutlet weak var loadingVIew: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Hide facebook button
       // #if DEBUG
      //  facebookLoginButton.isHidden = false
        
     //   #else
       // facebookLoginButton.isHidden = false
        

       // #endif
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in //listen for state chang on auth
                  if user == nil {
                    //if no user object do nothing which means we dont have an active session
                    
                 } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self) //transitions user to new page
///                    self.finishLogin() removed because it was forcing reload
                 }
            }
        performExistingAccountSetupFlows()
        setupAppleButton()
        
    }
    func setupAppleButton() {
        let appleLoginBtn = ASAuthorizationAppleIDButton(type: .continue, style: .white)
        appleLoginBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        mainView.addSubview(appleLoginBtn)
        // Setup Layout Constraints to be in the center of the screen
        appleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        appleLoginBtn.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        appleLoginBtn.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 30).isActive = true
        appleLoginBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        appleLoginBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        NSLayoutConstraint.activate([
//            appleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            appleLoginBtn.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 20),
//
//            appleLoginBtn.widthAnchor.constraint(equalToConstant: 200),
//            appleLoginBtn.heightAnchor.constraint(equalToConstant: 40)
//            ])
        
    }
    func finishLogin() {
        performSegue(withIdentifier: "loginSegue", sender: self)
        showLoading(status: false) //stops loading animation
    }
    
    func showLoading(status: Bool) {
        
//        let child = SpinnerViewController?
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
       
        switch status {
                 
        case true:
       loader.startAnimating()
       headlineText.isHidden = true

        case false:
            headlineText.isHidden = false
            loader.stopAnimating()
            print("kill spinner")
        }
    

//        } else {
//
//
//            //if loading is not true
//            // then remove the spinner view controller
//            // wait two seconds to simulate some work happening
//
////            view.setNeedsDisplay()
////            print("NOT DOING SHIT NOT LOADING")
//
//        }
        
    }
    //
    //AAPL Sign in
    //
    /// - Tag: add_appleid_button
    func setupProviderLoginView() {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        view.addSubview(authorizationButton)
//        appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//        
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        showLoading(status: true)
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    //
    //GUEST LOGIN - ANON SIGN IN
    //
    func anonSignIn(_ sender: Any) {
       Auth.auth().signInAnonymously() { (authResult, error) in

        self.finishLogin() //transitions user to app and kills animation
        }
    }
    func showGuestLoginActionSheet() {
    let optionMenu = UIAlertController(title: "Continue as a Guest", message: "If you continue your Stats may not be saved but, you can test the app", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Continue", style: .default, handler: anonSignIn)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in self.showLoading(status: false)}) //refresh view to stop the loading
    optionMenu.addAction(deleteAction)
    optionMenu.addAction(cancelAction)
    self.present(optionMenu, animated: true, completion: nil)
        
    }
    func refreshView(_ sender: Any) {
        self.loadView() //refreshs view
    }
    @IBAction func guestLogin(_ sender: Any) {
        Vibrator.success()
        showLoading(status: true)
        showGuestLoginActionSheet()
        
    }
    

    @IBAction func facebookLogin(_ sender: Any) {
        Vibrator.success()
        showLoading(status: true)
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
          if let error = error {
                        self.showLoading(status: false)
            print("Failed to login: \(error.localizedDescription)")
            return
          }
            guard let accessToken = AccessToken.current else {
                self.showLoading(status: false)
            print("Failed to get access token")
            return
          }
          let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
          
        // Perform login by calling Firebase APIs
          Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                self.showLoading(status: false)
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
        Vibrator.success()
        showLoading(status: true)
        print("Apple Login")
        handleAuthorizationAppleIDButtonPress()
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

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        showLoading(status: false)
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        showLoading(status: false)
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        showLoading(status: false)
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
            print("Signed in apple user")
            self.finishLogin()
          print(error?.localizedDescription)
          return
        }
        
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    showLoading(status: false)
    print("Sign in with Apple errored: \(error)")
  }

}
//extension LoginViewController: ASAuthorizationControllerDelegate {
//    /// - Tag: did_complete_authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
//
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
////            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//
//
//        default:
//            break
//        }
//    }
//
//    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
//    }
//
////    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
////        guard let viewController = self.presentingViewController as? ResultViewController
////            else { return }
////
////        DispatchQueue.main.async {
////            viewController.userIdentifierLabel.text = userIdentifier
////            if let givenName = fullName?.givenName {
////                viewController.givenNameLabel.text = givenName
////            }
////            if let familyName = fullName?.familyName {
////                viewController.familyNameLabel.text = familyName
////            }
////            if let email = email {
////                viewController.emailLabel.text = email
////            }
////            self.dismiss(animated: true, completion: nil)
////        }
////    }
//
//    private func showPasswordCredentialAlert(username: String, password: String) {
//        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//        let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                message: message,
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    /// - Tag: did_complete_error
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle error.
//    }
//}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}


//Firebase apple logic

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}



//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.success)
//
//        case 3:
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.warning)
//
//        case 4:
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
//
//        case 5:
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()
//
//        case 6:
//            let generator = UIImpactFeedbackGenerator(style: .heavy)
//            generator.impactOccurred()
