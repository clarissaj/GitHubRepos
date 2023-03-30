//
//  RepoDetailView.swift
//  GitHubRepos
//
//  Created by Clarissa Jawaid on 12/12/22.
//  Copyright © 2022 Jawaid. All rights reserved.
//

import SwiftUI

struct RepoDetailView: View {
    
    let repo: Repo
    
    var body: some View {
        VStack {
            Text(repo.name)
                .padding(.bottom, 8)
            Text(repo.description ?? "No Description Provided")
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct RepoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = Repo(name: "Test",
                        identifier: 0,
                        description: "Description")

        RepoDetailView(repo: repo)
    }
}
