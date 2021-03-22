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
    
    enum CodingKeys: String, CodingKey {
        case name
        case identifier = "id"
    }
}
