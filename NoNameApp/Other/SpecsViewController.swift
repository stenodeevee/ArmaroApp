//
//  SpecsViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 23/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class SpecsViewController: UIViewController {

    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var typePickerView = UIPickerView()
    var sizePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        typeTextField.inputView = typePickerView
        sizeTextField.inputView = sizePickerView
        
        typeTextField.placeholder = "Select type of Clothing"
        sizeTextField.placeholder = "Select size"
        brandTextField.placeholder = "Type brand of item"
        descriptionTextField.placeholder = "Describe item"
        
        
        typePickerView.delegate = self
        typePickerView.dataSource = self
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        
        typePickerView.tag = 1
        sizePickerView.tag = 2
        
    }
    
    func setupUI() {
        setUpContinueButton()
    }
    
    var sex = "M"
    var brand = ""
    var size = ""
    var type = ""
    var caption = ""

    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sex = "M"
        }
        else if sender.selectedSegmentIndex == 1 {
            sex = "F"
        }
                
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        self.brand = brandTextField.text!
        self.type = typeTextField.text!
        self.size = sizeTextField.text!
        self.caption = descriptionTextField.text!
        performSegue(withIdentifier: "continueSegue", sender: self)
    
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PostingViewController
        vc.finalBrand = self.brand
        vc.finalSize = self.size
        vc.finalType = self.type
        vc.finalSex = self.sex
        vc.finalCaption = self.caption
        
    }
    
    
}

extension SpecsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return TYPE_OF_CLOTHING.count
        case 2:
            if chosenType == "" {
                return 1
            }
            else if chosenType == "tops" {
                return SHIRT_SIZES.count
            }
            else if chosenType == "bottoms" {
                return PANTS_SIZES.count
            }
            else {return SHOE_SIZES.count}
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return TYPE_OF_CLOTHING[row]
        case 2:
            if chosenType == "" {
                return "Select type of clothing first"
            }
            else if chosenType == "tops" {
                return SHIRT_SIZES[row]
            }
            else if chosenType == "bottoms" {
                return PANTS_SIZES[row]
            }
            else {return SHOE_SIZES[row]}
        default:
            return "Data not found"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            typeTextField.text = TYPE_OF_CLOTHING[row]
            chosenType = typeTextField.text!
            typeTextField.resignFirstResponder()
            
        case 2:
            if chosenType == "" {
                sizeTextField.text = "Select type of clothing first"
                
            }
            else if chosenType == "tops" {
                sizeTextField.text = SHIRT_SIZES[row]
                sizeTextField.resignFirstResponder()
                chosenSize = sizeTextField.text!
                
                
            }
            else if chosenType == "bottoms" {
                sizeTextField.text = PANTS_SIZES[row]
                sizeTextField.resignFirstResponder()
                chosenSize = sizeTextField.text!
                
                
            }
            else {
                sizeTextField.text = SHOE_SIZES[row]
                sizeTextField.resignFirstResponder()
                chosenSize = sizeTextField.text!
                
            }
        default:
            return
            
        }
        
    }

    
}
extension SpecsViewController {
    func setUpContinueButton() {
        continueButton.layer.borderColor = UIColor.black.cgColor
        continueButton.layer.borderWidth = 1.0
        continueButton.setTitle("Continue", for: UIControl.State.normal)
        continueButton.setTitleColor(.white, for: UIControl.State.normal)
        continueButton.backgroundColor = UIColor.black
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
        
    }
}
