//
//  ViewController.swift
//  GitHubUsersTest
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersListViewController: UITableViewController {

    //MARK: - Dependencies
    
    private var viewModel: UserViewModel!
    private let disposeBag = DisposeBag()

    var tableViewData: [UserViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = UserViewModel(githubService: RestAPIService())
        addBindsToViewModel(viewModel: viewModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let followersVC = segue.destination as? FollowersListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            followersVC?.user = viewModel.users.value[indexPath.row]
        }
    }

    // MARK: - Private
    
    private func addBindsToViewModel(viewModel: UserViewModel) {
        tableView.dataSource = nil
        viewModel.users.asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: UserCellIdentifier,
                                             cellType: UserViewCell.self)) {
                (row, element, cell) in
                cell.configure(viewModel: element)
            }
            .addDisposableTo(disposeBag)
    }
}

