//
//  DataManager.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 5.03.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class PostModel {
    var photoURL:String?
    var description:String
    var author:String
    var width:Int = 0
    var height:Int = 0
    
    init(description: String, author:String) {
        self.photoURL = nil
        self.description = description
        self.author = author
    }
    
    init(photoURL: String, description: String, author:String, width: Int, height: Int) {
        self.photoURL = photoURL
        self.description = description
        self.author = author
        self.width = width
        self.height = height
    }
    
    init?(snapshot:DataSnapshot) {
        if let dict = snapshot.value as? [String:Any] {
            self.photoURL = dict["photo"] as? String
            self.description = dict["description"] as! String
            self.author = dict["author"] as! String
            self.width = dict["width"] as! Int
            self.height = dict["height"] as! Int
        } else {
            return nil
        }
    }
    
    var toDict:[String:Any] {
        var dict:[String:Any] = [:]
        
        dict["description"] = description
        dict["author"] = author
        dict["width"] = width
        dict["height"] = height
        if let photoURL = self.photoURL {
            dict["photo"] = photoURL
        }
        
        return dict
    }
}

class UserModel {
    var avatarPhoto:String?
    var username:String?
    
    init() {
        //nothing
    }
    
    init?(snapshot:DataSnapshot) {
        if let dict = snapshot.value as? [String:Any] {
            if dict["avatar"] != nil {
                self.avatarPhoto = dict["avatar"] as? String
            }
            
            if dict["username"] != nil {
                self.username = dict["username"] as? String
            }
        } else {
            return nil
        }
    }
}

final class DataManager {
    //private constructor
    private init() {
        databaseRef = Database.database().reference()
    }
    //single instance
    static let shared = DataManager()
    
    let pageSize:UInt = 10
    
    var databaseRef: DatabaseReference!
    var userUID: String?
    var user: User?
    
    
    func createPost(post: PostModel, callback: @escaping (Bool) -> ()) {
        if let userID = userUID {
            let key = databaseRef.child("posts").childByAutoId().key
            let postData = post.toDict
            let childUpdates = ["/posts/\(key)": postData,
                                "/myposts/\(userID)/\(key)/": postData]
            databaseRef.updateChildValues(childUpdates)
            
            callback(true)
        } else {
            callback(false)
        }
    
    }
    
    func createPost(post:PostModel, image:UIImage, progress: @escaping (Double)->(),callback: @escaping (Bool) -> () ) {
        
        guard let userID = userUID else {
            callback(false)
            return
        }
        // key for the data
        let key = databaseRef.child("posts").childByAutoId().key

        let storageRef = Storage.storage().reference()
        // location of the image for a particular post
        let photoPath = "posts/\(userID)/\(key)/photo.jpg"
        let imageRef = storageRef.child(photoPath)
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        metadata.customMetadata = ["userId": userID]
        
        
        let data = UIImageJPEGRepresentation(image, 0.9)
        // Upload data and metadata
        let uploadTask = imageRef.putData(data!, metadata: metadata)

        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let complete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress(complete)
        }

        uploadTask.observe(.success) { [unowned uploadTask, weak self] snapshot in
            // Upload completed successfully
            uploadTask.removeAllObservers()
            post.photoURL = photoPath
            post.width = Int(image.size.width)
            post.height = Int(image.size.height)
            
            let postData = post.toDict
            
            let childUpdates = ["/posts/\(key)": postData,
                                "/myposts/\(userID)/\(key)/": postData]
            self?.databaseRef.updateChildValues(childUpdates)
            
            callback(true)
        }
        
        uploadTask.observe(.failure) { [unowned uploadTask] snapshot in
            uploadTask.removeAllObservers()
            callback(false)
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    print("object not found")
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    print("user has no permissions")
                    break
                case .cancelled:
                    // User canceled the upload
                    print("upload was cancelled")
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
    
    /**
     * Get all items which are starting from the last item.
     * Page size is static variable
     */
    func fetchHomeFeed(callback: @escaping ([PostModel])->()) {
        let ref = databaseRef.child("posts")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let items: [PostModel] = snapshot.children.compactMap { child in
                guard let child = child as? DataSnapshot else {
                    return nil
                }
                return PostModel.init(snapshot: child)
            }
            
            DispatchQueue.main.async {
                callback(items.reversed())
            }
        })
    }
    
    /**
     * Get all posts for a user
     */
    func fetchUserPosts(userId:String?, callback: @escaping ([PostModel])->()) {
        guard let userID = userUID else {
            callback([])
            return
        }
        
        let user:String
        if let userId = userId {
            user = userId
        } else {
            user = userID
        }
        
        let ref = databaseRef.child("myposts").child(user)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var items:[PostModel] = []
            
            for child in snapshot.children {
                if let post = PostModel.init(snapshot:child as! DataSnapshot) {
                    items.append(post)
                } else {
                    print("unable to create post model.")
                }
                
            }
            
            DispatchQueue.main.async {
                callback(items)
            }
            
        })
        
    }
    
    /**
     * Upload an avatar and associate it with the current user
     */
    func updateProfile(avatar:UIImage?, progress: @escaping (Double)->(),callback: @escaping (Bool) -> () ) {
        
        guard let userID = userUID else {
            callback(false)
            return
        }
        
        guard let image = avatar else {
            callback(false)
            return
        }
        
        
        let dbKey = "profile/\(userID)/avatar"
        
        let storageRef = Storage.storage().reference()
        
        let photoPath = "posts/\(userID)/avatar.jpg"
        let imageRef = storageRef.child(photoPath)
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        metadata.customMetadata = ["userId": userID]
        
        let data = UIImageJPEGRepresentation(image, 0.9)
        // Upload data and metadata
        let uploadTask = imageRef.putData(data!, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let complete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress(complete)
        }
        
        uploadTask.observe(.success) { [unowned uploadTask, weak self] snapshot in
            // Upload completed successfully
            uploadTask.removeAllObservers()
            
            let childUpdates = [dbKey: photoPath]
            self?.databaseRef.updateChildValues(childUpdates)
            
            callback(true)
        }
        
        uploadTask.observe(.failure) { [unowned uploadTask] snapshot in
            uploadTask.removeAllObservers()
            callback(false)
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    print("object not found")
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    print("user has no permissions")
                    break
                case .cancelled:
                    // User canceled the upload
                    print("upload was cancelled")
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
    
    /**
     * Update user's username, which will be displayed in the the main feed
     **/
    func updateProfileUsername(username newUsername:String?, callback: @escaping (Bool) -> () ) {
        
        guard let userID = userUID else {
            callback(false)
            return
        }
        
        guard let username = newUsername else {
            callback(false)
            return
        }
        
        let dbKey = "profile/\(userID)/username"
        let childUpdates = [dbKey: username]
        
        databaseRef.updateChildValues(childUpdates)
        
        callback(true)
    }
    
    /**
     * Update user's username, which will be displayed in the the main feed
     **/
    func loadProfile(userId: String?, callback: @escaping (UserModel?) -> () ) {
        
        let user = userId ?? userUID
        
        if let user = user {
            databaseRef
                .child("profile/\(user)")
                .observeSingleEvent(of: .value, with: { snapshot in
                    var userModel:UserModel? = UserModel.init(snapshot:snapshot)
                    
                    DispatchQueue.main.async {
                        callback(userModel)
                    }
                })
        }
    }
    
    func loadUserInfo(userId:String, callback: @escaping (UserModel?) -> () ) {
        
        databaseRef
            .child("profile/\(userId)")
            .observeSingleEvent(of: .value, with: { snapshot in
                var userModel:UserModel? = UserModel.init(snapshot:snapshot)
                
                DispatchQueue.main.async {
                    callback(userModel)
                }
            })
    }
    
    func search(for searchText:String, callback: @escaping ([PostModel]) -> () ) {
        let key = "description"
        databaseRef
            .child("posts")
            .queryOrdered(byChild: key)
            .queryStarting(atValue: searchText, childKey: key)
            .queryEnding(atValue: searchText + "\u{f8ff}", childKey: key)
            .observeSingleEvent(of: .value, with: { snapshot in
                var items:[PostModel] = []
                
                for child in snapshot.children {
                    if let post = PostModel.init(snapshot:child as! DataSnapshot) {
                        items.append(post)
                    } else {
                        print("unable to create post model.")
                    }
                    
                }
                
                DispatchQueue.main.async {
                    callback(items)
                }
            })
    }
}
