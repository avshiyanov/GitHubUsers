//
//  UserViewModel.swift
//  GitHubUsersSample
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import RxSwift

final class UserViewModel {
    
    //MARK: - Dependecies
    
    private let restAPIService: RestAPIService
    private let disposeBag = DisposeBag()
    
    //MARK: - Model
    
    let users: Observable<[GitHubUser]>
    
    //MARK: - Set up
    
    init(githubService: RestAPIService) {
        self.restAPIService = githubService
        HUD.show()
        self.users = self.restAPIService.getUsers(page: 0, count: 100)
        let _ = self.users.subscribe(onNext: { (result) in
        }, onError: { (error) in
            HUD.show(error: error)
        }, onCompleted: { 
            HUD.hide()
        })
    }
    
}
