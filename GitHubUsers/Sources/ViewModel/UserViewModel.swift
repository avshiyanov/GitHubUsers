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
    private var listPaginator: ListPaginator = ListPaginator()
    
    //MARK: - Model
    
    let users: Observable<[GitHubUser]>
    
    //MARK: - Set up
    
    init(githubService: RestAPIService, loadNextPageTrigger: Observable<Void>) {
        self.restAPIService = githubService
        self.users = self.restAPIService.getUsers(
            listPaginator: listPaginator,
            loadNextPageTrigger: loadNextPageTrigger
            ).share(replay:1)
        HUD.show()
        let _ = self.users.subscribe(onNext: { (result) in
            HUD.hide()
        }, onError: { (error) in
            HUD.show(error: error)
        }, onCompleted: { 
            HUD.hide()
        })
    }
    
}
