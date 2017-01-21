//
//  TravelViewModel.swift
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
    
    var users = Variable([GitHubUser]())
    
    //MARK: - Set up
    
    init(githubService: RestAPIService) {
        self.restAPIService = githubService
        HUD.show()
        let _ = self.restAPIService.getUsers(page: 0, count: 100)
            .subscribe(onNext: { (result) in
                HUD.hide()
                self.users.value = result
            }, onError: { (error) in
                HUD.hide()
                HUD.show(error: error)
        })
    }
    
}
