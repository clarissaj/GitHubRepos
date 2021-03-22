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
            guard let data = data else {
                completionHandler(error)
                return
            }
            
            do {
                let repos = try JSONDecoder().decode([Repo].self, from: data)
                
                //if we have data serialized then save to CoreData
                self.addToCoreData(repos, completionHandler) {
                    //if saved succesfully then fetch from memory
                    self.fetchRepos(completionHandler)
                }
            } catch {
                completionHandler(error)
            }
        }.resume()
    }
    
    func addToCoreData(_ repos: [Repo], _ fetchCompletionHandler: @escaping (_ error: Error?) -> Void, _ saveCompletionHandler: @escaping () -> Void) {
        
        persistentContainer?.performBackgroundTask({ backgroundContext in
            for repo in repos {
                let request = self.createFetchRequestToCheckIfRepoExistsLocally(repo)
                request.returnsObjectsAsFaults = false
                
                do {
                    //check that repo isn't already saved locally
                    let existingRepoCount = try self.persistentContainer?.viewContext.count(for: request)
                    
                    if existingRepoCount == 0 {
                        //repo doesn't exist
                        //so create Repository object from it
                        let repoManagedObject = Repository(context: backgroundContext)
                        repoManagedObject.name = repo.name
                        repoManagedObject.ident = Int32(repo.identifier)
                        
                        do {
                            try backgroundContext.save()
                        } catch {
                            fetchCompletionHandler(error)
                        }
                    } else {
                        //repo exists, continue to next item in array
                        continue
                    }
                } catch {
                    fetchCompletionHandler(error)
                }
            }
            //start fetch
            saveCompletionHandler()
        })
    }
    
    func createFetchRequestToCheckIfRepoExistsLocally(_ repo: Repo) -> NSFetchRequest<Repository> {
        let request = NSFetchRequest<Repository>(entityName: String(describing: Repository.self))
        
        request.predicate = NSPredicate(format: "ident == %d", repo.identifier)
        request.returnsObjectsAsFaults = false
        
        return request
    }
    
    func fetchRepos(_ completionHandler: @escaping (_ error: Error?) -> Void) {
        let request = NSFetchRequest<Repository>(entityName: AppConstants.repository)
        request.returnsObjectsAsFaults = false
        
        do {
            if let results = try self.persistentContainer?.viewContext.fetch(request) {
                self.dataSource.repos = results
                //reload table view with new data
                completionHandler(nil)
            }
        } catch {
            completionHandler(error)
        }
    }
}
