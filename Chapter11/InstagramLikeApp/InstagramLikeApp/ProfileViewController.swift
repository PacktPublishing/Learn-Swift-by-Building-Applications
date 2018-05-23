//
//  ProfileViewController.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 17.04.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuthUI
import FirebaseStorageUI

class ProfileViewController: UIViewController {
    var userUDID:String? = nil
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var posts: UICollectionView!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet var avatarGestureRecogniser: UITapGestureRecognizer!
    
    @IBOutlet var usernameTapGestereRecogniser: UITapGestureRecognizer!
    
    private let photoCellReuseIdentifier = "PhotoCell"
    
    var listOfPosts:[PostModel]?
    
    private var pickedImage:UIImage?
        
    @IBAction func logoutHandler(_ sender: Any) {
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
        
        let cellNib = UINib(nibName: "PhotoViewCell", bundle: nil)
        posts.register(cellNib, forCellWithReuseIdentifier: photoCellReuseIdentifier)
        //set datasource
        posts.dataSource = self
        //default avatar icon
        avatarImageView.image = #imageLiteral(resourceName: "user")
        username.text = userUDID ?? DataManager.shared.userUID
        
        if let layout = posts.collectionViewLayout as? UICollectionViewFlowLayout {
            let imageWidth = (UIScreen.main.bounds.width - 10) / 3
            layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        }
        
        //you can't follow yourself
        if userUDID == nil {
            followButton.isHidden = true
        } else {
            //disable change of avatar photo
            avatarGestureRecogniser.isEnabled = false
           // disable change of the username
            usernameTapGestereRecogniser.isEnabled = false
            // hide logout button
            logoutButton.isHidden = true
            //hide follow button
            if userUDID == DataManager.shared.userUID {
               followButton.isHidden = true
            }
        }
        loadData()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData() {
        listOfPosts = []
        
        DataManager.shared.fetchUserPosts(userId: userUDID, callback:  { [weak self] items in
            if items.count > 0 {
                self?.listOfPosts? += items
                self?.posts.reloadData()
            }
        })
        
        DataManager.shared.loadProfile(userId: userUDID ) { [weak self] user in
            if let user = user {
                if let avatarPhoto = user.avatarPhoto {
                    let imgRef = Storage.storage().reference().child(avatarPhoto)
                    self?.avatarImageView.sd_setImage(with: imgRef)
                }

                self?.username.text = user.username ?? "Anonymous"
                
            } else {
                self?.username.text = "Anonymous"
            }
        }
    }
    
    func updateAvatar() {
        if pickedImage != nil {
            self.avatarImageView.image = pickedImage
        }
        DataManager.shared.updateProfile(avatar: pickedImage, progress: { progress in
            print("Upload avatar progress: \(progress)")
        }) { result in
            if !result {
                print("something went wrong")
            }
        }
    }
    
    func updateUsername(username:String?) {
        DataManager.shared.updateProfileUsername(username: username) { result in
            if !result {
                print("something went wrong")
            }
        }
    }
    
    @IBAction func changeUsername(_ sender: Any) {
        let alertController  = UIAlertController(title: "Change your username", message: "Please, enter a new username.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            //do some textFiled customization
            
        }
        
    alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alertController, weak self] (action) in
            if let textFields = alertController?.textFields! {
                if textFields.count > 0 {
                    let textFiled = textFields[0]
                    //update the ui
                    self?.username.text = textFiled.text
                    //update the server data
                    self?.updateUsername(username: textFiled.text)
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as? PhotoViewCell else {
            return UICollectionViewCell()
        }
        
        guard let post = listOfPosts?[indexPath.row] else {
            return cell
        }
        
        if let image = post.photoURL {
            let imgRef = Storage.storage().reference().child(image)
            cell.image.sd_setImage(with: imgRef)
        }
        
        return cell
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func pickAvatarImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            pickedImage = self.scale(image: editedImage, toSize: CGSize(width:100, height:100))
        } else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = self.scale(image: chosenImage, toSize: CGSize(width:100, height:100))
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        updateAvatar()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func scale(image: UIImage, toSize size:CGSize) -> UIImage? {
        let imageSize = image.size
        
        let widthRatio  = size.width  / image.size.width
        let heightRatio = size.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:imageSize.width * heightRatio, height: imageSize.height * heightRatio)
        } else {
            newSize = CGSize(width: imageSize.width * widthRatio,  height: imageSize.height * widthRatio)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
