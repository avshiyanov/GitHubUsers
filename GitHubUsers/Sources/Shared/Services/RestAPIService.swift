//
//  RestAPIService.swift
//  GitHubUsers
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import SwiftyJSON
import SystemConfiguration

public struct RestAPIService {

    //MARK: - Dependecies
    
    public struct Constants {
        static let baseAPIURL   = "https://api.github.com/"
        static let clientId     = "c194ccbb171abd92c67e"
        static let secretCode   = "0e0e6422d6f18cfaf1cdf853ecbfb129d410cde0"
    }
    
    enum APIError: Error {
        case cannotParse
        case connectionProblem
    }
    
    enum ResourcePath: String {
        case users = "users?since={since}&per_page={per_page}"
        
        var path: String {
            return Constants.baseAPIURL + rawValue
        }
    }

    func getUsers(listPaginator: ListPaginator,
                  loadNextPageTrigger: Observable<Void>) -> Observable<[GitHubUser]> {
        return loadNextUsers([], listPaginator: listPaginator, loadNextPageTrigger: loadNextPageTrigger)
    }

    func loadNextUsers(_ loadedSoFar: [GitHubUser],
                       listPaginator: ListPaginator,
                       loadNextPageTrigger: Observable<Void>) -> Observable<[GitHubUser]> {
        var urlString = ResourcePath.users.path
        let lastSeen = loadedSoFar.isEmpty ? "" : "\(loadedSoFar.last!.userId)"

        urlString = urlString.replacingOccurrences(of: "{since}",
                                                   with: lastSeen)
        urlString = urlString.replacingOccurrences(of: "{per_page}",
                                                   with: "\(listPaginator.itemsPerPage())")
        
        let params = ["client_id": Constants.clientId,
                      "client_secret": Constants.secretCode]
        
        if let url = URL(string: urlString) {
                return json(.get, url, parameters: params).flatMap({
                    (result) -> Observable<[GitHubUser]> in
                    print (urlString)
                    
                    guard let array = result as? [Any] else {
                        return Observable.error(APIError.cannotParse)
                    }
                    var loadedUsers:[GitHubUser] = []
                    for dict in array {
                        if let user = GitHubUser(json: JSON(dict)) {
                            loadedUsers.append(user)
                        }
                    }
                    
                    var appendedUsers = loadedSoFar
                    appendedUsers.append(contentsOf: loadedUsers)
                    var paginator = listPaginator
                    
                    if loadedUsers.isEmpty {
                        return Observable.just(appendedUsers)
                    }
                    
                    return Observable.concat([
                        // return loaded immediately
                        Observable.just(appendedUsers),
                        // wait until next page can be loaded
                        Observable.never().takeUntil(loadNextPageTrigger),
                        // load next page
                        self.loadNextUsers(appendedUsers,
                            listPaginator: paginator.increasePage(),
                            loadNextPageTrigger: loadNextPageTrigger)
                        ])
                }).observeOn(MainScheduler.instance)
        } else {
            return Observable.empty()
        }
    }
    
     func getFollowers(urlString: String) -> Observable<[GitHubUser]> {
        let params = ["client_id": Constants.clientId,
                      "client_secret": Constants.secretCode]
        
        if let url = URL(string: urlString) {
            return json(.get, url, parameters: params).flatMap({
                (result) -> Observable<[GitHubUser]> in
                guard let array = result as? [Any] else {
                    return Observable.error(APIError.cannotParse)
                }
                var users:[GitHubUser] = []
                for dict in array {
                    if let user = GitHubUser(json: JSON(dict)) {
                        users.append(user)
                    }
                }
                return Observable.just(users)
            }).observeOn(MainScheduler.instance)
        } else {
            return Observable.empty()
        }
    }
}
