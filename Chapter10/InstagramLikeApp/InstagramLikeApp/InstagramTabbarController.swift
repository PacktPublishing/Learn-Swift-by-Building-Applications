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
                self?.pesentPicker()
            }
        }
        
        //update the middle icon
        if let viewController = self.viewControllers?[2] {
            viewController.tabBarItem = ESTabBarItem.init(IrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        }
    }
    
    func pesentPicker() {
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

class IrregularityContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.backgroundColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.imageView.layer.borderWidth = 3.0
        self.imageView.layer.borderColor = UIColor.white.cgColor
        self.imageView.layer.cornerRadius = 35
        self.insets = UIEdgeInsetsMake(-32, 0, 0, 0)
        self.superview?.bringSubview(toFront: self)
        
        iconColor = .white
        highlightIconColor = .white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }
    
    override func updateLayout() {
        super.updateLayout()
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
    
//    public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
//        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
//        view.layer.cornerRadius = 1.0
//        view.layer.opacity = 0.5
//        view.backgroundColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
//        self.addSubview(view)
//    }
    
//    public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
//        completion?()
//    }
//
//    public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
//        completion?()
//    }
    
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
