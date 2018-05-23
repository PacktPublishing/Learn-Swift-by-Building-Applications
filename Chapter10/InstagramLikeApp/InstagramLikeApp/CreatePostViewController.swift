//
//  CreatePostViewController.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 3.03.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }

    private let placeholder = "Write a caption..."
    
    public var image:UIImage?
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textColor = UIColor.gray
            textView.text = placeholder
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        photo.image = image
        
        //add Share button
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(createPost))
    }
    
    @objc func createPost() {
        guard let image = self.image else {
            return
        }
        
        let description = (textView.text != placeholder ? textView.text : "") ?? ""
        var post = PostModel(description: description, author: DataManager.shared.userUID ?? "no user id" )
        
        DataManager.shared.createPost(post: post, image: image, progress: { (progress) in
            print("Upload \(progress)")
        }) { (success) in
            if success {
                print("Successful upload.")
            } else {
                print("unable to create the post.")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CreatePostViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // Move cursor to beginning on first tap
        if textView.text == placeholder {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //if something is typed
        if textView.text == placeholder && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //if the textview has no text
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = placeholder
        }
    }
}
