//
//  GitHubUser.swift
//  GitHubUsersSample
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GitHubUser {
    
    // MARK: - Properties
    
    let userId: Int64
    let login: String
    let profileURL: String
    let avatarURL: String
    let followersURL: String
    
    init?(json: JSON) {
        guard let userId = json["id"].int64,
            let login = json["login"].string,
            let profileURL = json["html_url"].string,
            let avatarURL = json["avatar_url"].string,
            let followersURL = json["followers_url"].string
            else {
                return nil
        }
        self.userId = userId
        self.login = login
        self.profileURL = profileURL
        self.avatarURL = avatarURL
        self.followersURL = followersURL
    }
}
