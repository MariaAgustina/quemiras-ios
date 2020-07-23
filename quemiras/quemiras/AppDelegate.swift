//
//  AppDelegate.swift
//  quemiras
//
//  Created by Agustina Markosich on 30/05/2020.
//  Copyright © 2020 Agustina. All rights reserved.
//

import UIKit
import FBSDKCoreKit

public let apikey : String = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTlmN2VmOGMzYzg0OTNmMzA1OWZjNDU0ZDJiNDk2MyIsInN1YiI6IjVlZTYzM2EwY2I3MWI4MDAxY2I2YzFhYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Suae6ei725YTGq7BinYGI6p2FSY6dET8pL3CfW8zUWg"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool { ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )        
        return true
        
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
    }
    
}

