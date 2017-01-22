//
//  FollowerViewModel.swift
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
    
    let followers: Observable<[GitHubUser]>

    //MARK: - Set up
    
    init(githubService: RestAPIService, followersUrl: String) {
        self.restAPIService = githubService
        HUD.show()
        self.followers = self.restAPIService.getFollowers(urlString: followersUrl)
        let _ = self.followers.subscribe(onNext: { (result) in
        }, onError: { (error) in
            HUD.show(error: error)
        }, onCompleted: {
            HUD.hide()
        })
    }
}
