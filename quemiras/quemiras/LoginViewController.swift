//
//  ViewController.swift
//  quemiras
//
//  Created by Agustina Markosich on 30/05/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import PureLayout
class LoginViewController: UIViewController {

    @IBOutlet weak var loginButtonContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        loginButtonContentView.addSubview(loginButton)
        loginButton.autoPinEdgesToSuperviewMargins()
        loginButton.delegate = self
    }


}

extension LoginViewController : LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let token = AccessToken.current, !token.isExpired {
            print("User logged in: ", token.userID)
            //TODO: push profile or select film vc
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out")

    }
    
    
}
    
