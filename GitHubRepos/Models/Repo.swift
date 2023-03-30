//
//  Repo.swift
//  GitHubRepos
//
//  Created by Clarissa Jawaid on 3/22/21.
//  Copyright © 2021 Jawaid. All rights reserved.
//

struct Repo: Decodable {
    let name: String
    let identifier: Int
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case identifier = "id"
        case description
    }
    
    init(name: String, identifier: Int, description: String) {
        self.name = name
        self.identifier = identifier
        self.description = description
    }
    
    init(repo: Repository) {
        name = repo.name ?? "No Repo Name"
        identifier = Int(repo.identifier)
        description = repo.longDescription
    }
}
