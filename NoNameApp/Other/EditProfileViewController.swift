//
//  EditProfileViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 24/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit


struct SettingCellModel {
    let title: String
    let handler: (() -> Void )
}




/// View controller Edit profile
final class EditProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    private var  data = [[SettingCellModel]] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
       
        
        
        data.append([
            SettingCellModel(title: "Edit sizes and profile picture") { [weak self] in
                self?.didTapEditSizes()
            },
            SettingCellModel(title: "Invite Friends") {[weak self ] in
                self?.didTapInviteFriends()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Terms of Service") { [weak self] in
                self?.didTapTermsofService()
            },
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.didTapPrivacyPolicy()
            },
            SettingCellModel(title: "Help / Feedback") {[weak self ] in
                self?.didTapHelp()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Log Out") { [weak self] in
                self?.didTapLogOut()
            }
        ])
        
    }
    
    private func didTapEditSizes() {
        let vc = EditSizesViewController()
        vc.title = "Edit Sizes and Profile Info"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

    
    private func didTapHelp() {
        
    }
    
    private func didTapPrivacyPolicy() {
        
    }
    
    private func didTapTermsofService() {
        
    }
    
    private func didTapInviteFriends() {
        
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to Log Out?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive,  handler: {
            _ in Api.User.logOut()        }))
        
        present(actionSheet, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
  
    

}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
    
    
}
