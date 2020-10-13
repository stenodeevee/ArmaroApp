//
//  SizeChoiceViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 18/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SizeChoiceViewController: UIViewController {

    @IBOutlet weak var titleSizeLabel: UILabel!
    @IBOutlet weak var overPickerLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        picker.dataSource = self
        picker.delegate = self
        
    }
    
    func setupUI() {
        setupTitleSizeLabel()
        setupFinishButton()
        setupOverPickerLabel()
        
    }

    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func finishButtonDidTapped(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()

    }

}
