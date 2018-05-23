//
//  InstagramTabbarController.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 3.03.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import YPImagePicker


class InstagramTabbarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        self.didHijackHandler = {
            [weak self] tabbarController, viewController, index in
            DispatchQueue.main.async {
                self?.presentPicker()
            }
        }
        
        //update the middle icon
        if let viewController = self.viewControllers?[2] {
            viewController.tabBarItem = ESTabBarItem.init(AnimatedContentView(), title: nil, image: UIImage(named: "create_post"), selectedImage: UIImage(named: "create_post"))
        }
    }
    
    func presentPicker() {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromLibrary = false
        config.onlySquareImagesFromCamera = true
        config.libraryTargetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = !true
        config.albumName = "IstagramLikeApp"
        config.startOnScreen = .library

        let picker = YPImagePicker(configuration: config)
        
        picker.didSelectImage = {
            [unowned picker, weak self] img in
            
            if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "CreatePost") as? CreatePostViewController {
                
                viewController.image = img
            
                // Use Fade transition instead of default push animation
                let transition = CATransition()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionFade
                picker.view.layer.add(transition, forKey: nil)
                
                picker.pushViewController(viewController, animated: false)
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
}

class AnimatedContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconColor = .black
        highlightIconColor = .white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }

    public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
}
