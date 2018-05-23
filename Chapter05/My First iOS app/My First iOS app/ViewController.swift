//
//  ViewController.swift
//  My First iOS app
//
//  Created by Emil Atanasov on 5/8/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import UIKit
//my dummy comment
class ViewController: UIViewController {
    
    @IBOutlet var fireButton:UIButton!

    @IBAction func clickHandler(_ sender: UIButton) {
        
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        //change the background color
        self.view.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    //image view
    @IBOutlet var imageView:UIImageView!
    
    @IBAction func switchHandle(_ sender: UISwitch) {
        
        imageView.isHidden = !sender.isOn
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fireButton.addTarget(self, action: #selector(ViewController.fireClickHandler(_:)), for: UIControlEvents.touchUpInside)
        
        imageView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fireClickHandler(_ sender: UIButton) {
        print("Fire button was pressed!")
        self.view.backgroundColor = UIColor.red
    }
    
}

