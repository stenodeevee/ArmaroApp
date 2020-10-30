//
//  EditSizesViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 25/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseAuth

struct EditSizeFormModel {
    let label: String
    let placeholder: String
    var value: String?
}

final class EditSizesViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    
    private var models = [[EditSizeFormModel]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        // name, email, password
        let section1Labels = ["Username","Email","Password"]
        var section1 = [EditSizeFormModel]()
        for label in section1Labels {
            let model = EditSizeFormModel(label: label,
                                          placeholder: "Enter \(label)...", value: nil )
            section1.append(model)
        }
        models.append(section1)
        
        // gender, sizes
        let section2Labels = ["Gender","Shoe size","T-shirt size", "Pants size"]
        var section2 = [EditSizeFormModel]()
        for label in section2Labels {
            let model = EditSizeFormModel(label: label,
                                          placeholder: "Enter \(label)...", value: nil )
            section2.append(model)
        }
        models.append(section2)
    }
    
    // MARK: TableView
    
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.bounds.width,
                                          height: view.bounds.height/4).integral)
        let size = header.bounds.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.bounds.width - size)/2, y: (header.bounds.height - size)/2, width: size, height: size).integral)
        
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        profilePhotoButton.imageView?.loadImage(Auth.auth().currentUser!.photoURL!.absoluteString)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        
        return header
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(models.count)
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Sizes Information"
        
    }
    

    
    
    // MARK: Action
    
    @objc private func didTapProfilePhotoButton() {
        
    }
    
    @objc private func didTapSave() {
        // Save info to Database
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePicture() {
        let actionSheet = UIAlertController(title: "Profile Picture", message : "Change profile picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title:"Take Photo", style: .default, handler: {_ in
            
        }))
        actionSheet.addAction(UIAlertAction(title:"Choose from Library", style: .default, handler: {_ in
            
        }))
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }
    
    



}

extension EditSizesViewController: FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditSizeFormModel) {
        print(updatedModel.value ?? "nil")
    }
    
  

    
}

