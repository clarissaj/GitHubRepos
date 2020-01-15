//
//  GitHubModel.swift
//  GitHubRepos
//
//  Created by Clarissa Jawaid on 1/13/20.
//  Copyright © 2020 Jawaid. All rights reserved.
//

import UIKit
import CoreData

class GitHubModel {
    private let dataSource: GitHubDataSource
    let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    public init(dataSource: GitHubDataSource) {
        self.dataSource = dataSource
    }

    func getRepos(_ completionHandler: @escaping (_ error: Error?) -> Void) {
        guard let gitHubReposURL = URL(string: AppConstants.gitHubAPIURL) else { return }
        
        //make request to GitHub
        URLSession.shared.dataTask(with: gitHubReposURL) { data, response, error in
            if let error = error {
                completionHandler(error)
                return
            }
            
            do {
                if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    //if we have data serialized then save to CoreData
                    self.addToCoreData(json, completionHandler) {
                        //if saved succesfully then fetch from memory
                        self.fetchRepos(completionHandler)
                    }
                }
            } catch {
                completionHandler(error)
            }
        }.resume()
    }
    
    func addToCoreData(_ jsonData: [[String: Any]], _ fetchCompletionHandler: @escaping (_ error: Error?) -> Void, _ saveCompletionHandler: @escaping () -> Void) {
        
        persistentContainer?.performBackgroundTask({ backgroundContext in
            jsonData.forEach { repo in
                //if we find a dictionary that has both keys (meaning it is a repo json object), then create Repository object from it
                if let name = repo[AppConstants.name] as? String, let ident = repo[AppConstants.ID] as? Int32 {
                    let repo = Repository(context: backgroundContext)
                    repo.name = name
                    repo.ident = ident
                }
                
                do {
                    try backgroundContext.save()
                    //start fetch
                    saveCompletionHandler()
                } catch {
                    fetchCompletionHandler(error)
                }
            }
        })
    }
    
    func fetchRepos(_ completionHandler: @escaping (_ error: Error?) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.repository)
        request.returnsObjectsAsFaults = false
        
        do {
            if let results = try self.persistentContainer?.viewContext.fetch(request) as? [Repository] {
                self.dataSource.repos = results
                //reload table view with new data
                completionHandler(nil)
            }
        } catch {
            completionHandler(error)
        }
    }
}
