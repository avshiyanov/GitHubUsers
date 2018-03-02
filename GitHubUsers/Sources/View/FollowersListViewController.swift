//
//  FollowersListViewController.swift
//  GitHubUsers
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class FollowersListViewController: UITableViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: FollowerViewModel!
    var user: GitHubUser!
    var tableViewData: [UserViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = FollowerViewModel(githubService: RestAPIService(),
                                      followersUrl: user.followersURL)
        addBindsToViewModel(viewModel: viewModel)
    }
    
    // MARK: - Private
    
    private func addBindsToViewModel(viewModel: FollowerViewModel) {
        tableView.dataSource = nil
        viewModel.followers.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: UserCellIdentifier,
                                       cellType: UserViewCell.self)) {
                                        (row, element, cell) in
                                        cell.configure(viewModel: element)
            }
            .disposed(by: disposeBag)
    }
}
