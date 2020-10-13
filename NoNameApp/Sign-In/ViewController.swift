//
//  ViewController.swift
//  NoNameApp
//
//  Created by ESTEFANO on 10/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var signInGoogle: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    

    
    
    func setupUI() {
        
        setupHeaderTitle()
        setupOrLabel()
        setupTermsOfService()
        setupGoogleButton()
        setupCreateAccountButton()
       
 

        

        

        

        
    }

}


extension UINavigationController {

  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func popViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }

}
