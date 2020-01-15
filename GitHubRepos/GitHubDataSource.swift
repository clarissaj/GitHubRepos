//
//  GitHubDataSource.swift
//  GitHubRepos
//
//  Created by Clarissa Jawaid on 1/13/20.
//  Copyright © 2020 Jawaid. All rights reserved.
//

import UIKit

class GitHubDataSource: NSObject, UITableViewDataSource {
    
    public var repos = [Repository]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = repos[indexPath.row].name
        
        return cell
    }
}
