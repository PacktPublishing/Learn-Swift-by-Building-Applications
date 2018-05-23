//
//  AppDelegate.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 10.02.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name(rawValue: "userSignedOut"),
                       object: nil, queue: nil) { [weak self]
                        notification in
                        //TODO: remove the stored user information
                        self?.openSingInScreen()
        }
        
        // handle the successful sign in
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let user = Auth.auth().currentUser
        if let user = user {
            save(user: user)
            self.openMainViewController()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- helper functions
    
    func save(user: User) {
        //TODO: save the user in memory
        DataManager.shared.user = user
        DataManager.shared.userUID = user.uid
    }
    
    func openSingInScreen() {
        if let signInViewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
            
            signInViewController.view.frame = (self.window?.rootViewController?.view.frame)!
            signInViewController.view.layoutIfNeeded()
            
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = signInViewController
            }, completion: { completed in
                // nothing to do here
            })
            
        }
    }
    
    func openMainViewController() {
        if let rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") {
            
            rootViewController.view.frame = (self.window?.rootViewController?.view.frame)!
            rootViewController.view.layoutIfNeeded()
            
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = rootViewController
            }, completion: { completed in
                // maybe do something here
            })
            
        }
    }
    
    //MARK:- FUIAuthDelegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let user = user {
            save(user: user)
            self.openMainViewController()
        }
    }
}

