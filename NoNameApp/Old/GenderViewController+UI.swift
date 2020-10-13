//
//  GenderViewController+UI.swift
//  Armaro
//
//  Created by ESTEFANO on 18/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

extension GenderViewController {
    func setupGenderTitleLabel() {
        let title = "Before starting off.."
        let subtitle = "\nHelp us narrow down your specs"
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
        let attributedSubTitle = NSMutableAttributedString(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.45)])
        
        attributedText.append(attributedSubTitle)
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
    }
    
    func setupContinueButton() {
        continueButton.layer.borderColor = UIColor.black.cgColor
        continueButton.layer.borderWidth = 1.0
        continueButton.setTitle("Next", for: UIControl.State.normal)
        continueButton.setTitleColor(.white, for: UIControl.State.normal)
        continueButton.backgroundColor = UIColor.black
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
        
    }
    
    func setupChangeSettingsLabel() {
        
        let attributedTermsText = NSMutableAttributedString(string: "You will be able to change these settings \nin the future" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white:0, alpha:0.65) ])
         
         settingsGenderLabel.attributedText = attributedTermsText
         settingsGenderLabel.numberOfLines = 0    }
    
    func setupLabelOverGChoice() {
        labelOverGenderChoice.text = "I identify as a:"
        labelOverGenderChoice.font = UIFont.boldSystemFont(ofSize: 16)
        labelOverGenderChoice.textColor = UIColor(white: 0, alpha: 0.45)
        labelOverGenderChoice.textAlignment = .center    }
    
}
