//
//  Extension.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation
import SDWebImage


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIImageView {
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.locations = [0.5,1.0]
        
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
           
    }
}

extension UIImageView {
    
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else { return }
        guard let url = URL(string: string) else {return}
        
        self.sd_setImage(with: url) {(image, error, type, url ) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
}
