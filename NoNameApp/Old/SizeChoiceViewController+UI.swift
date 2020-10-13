//
//  SizeChoiceViewController+UI.swift
//  Armaro
//
//  Created by ESTEFANO on 18/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

extension SizeChoiceViewController {

    
    
    func setupTitleSizeLabel() {
            let title = "Almost there"
            let subtitle = "\nWe only need your sizes now"
        
            let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
            let attributedSubTitle = NSMutableAttributedString(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.45)])
        
            attributedText.append(attributedSubTitle)
            titleSizeLabel.numberOfLines = 0
            titleSizeLabel.attributedText = attributedText
        
    }
        
    
    func setupFinishButton() {
        
        finishButton.layer.borderColor = UIColor.black.cgColor
        finishButton.layer.borderWidth = 1.0
        finishButton.setTitle("Finish", for: UIControl.State.normal)
        finishButton.setTitleColor(.white, for: UIControl.State.normal)
        finishButton.backgroundColor = UIColor.black
        finishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        finishButton.layer.cornerRadius = 5
        finishButton.clipsToBounds = true
    }
    
    func setupOverPickerLabel() {
        let over_title = "Shoes!   Tops    Bottoms"
        let attributedText = NSMutableAttributedString(string: over_title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 22)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
        
        overPickerLabel.numberOfLines = 0
        overPickerLabel.attributedText = attributedText
        overPickerLabel.textAlignment = .center
    }

    
    
}

extension SizeChoiceViewController: UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return SHOE_SIZES.count
        }
        else if component == 1 {
            return SHIRT_SIZES.count
            
        } else {
            return PANTS_SIZES.count
        }
    }
    
        
}

extension SizeChoiceViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return SHOE_SIZES[row]
        } else if component == 1 {
            return SHIRT_SIZES[row]
        } else {
            return PANTS_SIZES[row]
        }
    
    }
    

    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            Api.User.updateProfile(index: "shoesize", value: SHOE_SIZES[row])
        } else if component == 1 {
            Api.User.updateProfile(index: "topsize", value: SHIRT_SIZES[row])
        } else {
            Api.User.updateProfile(index: "bottomsize", value: PANTS_SIZES[row])
        }
    }

}
