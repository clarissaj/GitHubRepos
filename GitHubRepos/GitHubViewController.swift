//
//  GitHubViewController.swift
//  GitHubRepos
//
//  Created by Clarissa Jawaid on 1/13/20.
//  Copyright © 2020 Jawaid. All rights reserved.
//

import UIKit

class GitHubViewController: UIViewController {
    @IBOutlet var reposTableView: UITableView!
    
    let dataSource = GitHubDataSource()
    let model: GitHubModel
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        model = GitHubModel(dataSource: dataSource)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        model = GitHubModel(dataSource: dataSource)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        model.getRepos ({ error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(error)
                } else {
                    self.reposTableView.reloadData()
                }
            }
        })
        
        reposTableView.dataSource = dataSource
    }
    
    func showAlert(_ error: Error) {
        let errorController = UIAlertController(title: nil, message: "\(AppConstants.errorAlertMessage) \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: AppConstants.ok, style: .default)
        errorController.addAction(okAction)
        
        present(errorController, animated: true)
    }
}

