//
//  RestAPIService.swift
//  GitHubUsersTest
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
        static let baseAPIURL = "https://api.github.com/"
    }
    
    enum APIError: Error {
        case cannotParse
        case connectionProblem
    }
    
    enum ResourcePath: String {
        case users = "users?since={since}&per_page={count}"
        
        var path: String {
            return Constants.baseAPIURL + rawValue
        }
    }

    func getUsers(page: Int, count: Int) -> Observable<[GitHubUser]> {
        var urlString = ResourcePath.users.path
        urlString = urlString.replacingOccurrences(of: "{since}",
                                                   with: "\(page)")
        urlString = urlString.replacingOccurrences(of: "{count}",
                                                   with: "\(count)")
        if let url = URL(string: urlString) {
                return json(.get, url).flatMap({
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
    
    func getFollowers(urlString: String) -> Observable<[GitHubUser]> {
        if let url = URL(string: urlString) {
            return json(.get, url).flatMap({
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
