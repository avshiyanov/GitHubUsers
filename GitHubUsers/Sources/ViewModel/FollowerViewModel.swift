//
//  FollowersViewModel.swift
//  GitHubUsers
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import RxSwift
import PKHUD

final class FollowerViewModel {
    
    //MARK: - Dependecies
    
    private let restAPIService: RestAPIService
    private let disposeBag = DisposeBag()
    
    //MARK: - Model
    
    var followers = Variable([GitHubUser]())

    //MARK: - Set up
    
    init(githubService: RestAPIService, followersUrl: String) {
        self.restAPIService = githubService
        HUD.show()
        let _ = self.restAPIService.getFollowers(urlString: followersUrl)
            .subscribe(onNext: { (result) in
                self.followers.value = result
                HUD.hide()
            }, onError: { (error) in
                HUD.hide()
                HUD.show(error: error)
        })
    }
}
