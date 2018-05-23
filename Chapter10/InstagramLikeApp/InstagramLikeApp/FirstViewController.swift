//
//  FirstViewController.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 10.02.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class FirstViewController: UIViewController {

    @IBAction func onLogout(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        do {
            try authUI?.signOut()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "userSignedOut"),
                    object: nil,
                    userInfo: nil)
            //remove the active user 
            DataManager.shared.user = nil
            DataManager.shared.userUID = nil
        } catch let error {
            print("Error: \(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

