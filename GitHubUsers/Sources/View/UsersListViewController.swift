//
//  UsersListViewController.swift
//  GitHubUsersTest
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let startLoadingOffset: CGFloat = 20.0

class UsersListViewController: UITableViewController {

    //MARK: - Dependencies
    
    private var viewModel: UserViewModel!
    private let disposeBag = DisposeBag()

    var tableViewData: [UserViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    func isNearTheBottomEdge(_ contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        let result = contentOffset.y +
            tableView.bounds.size.height +
            startLoadingOffset > tableView.contentSize.height
        return result
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loadNextPageTrigger = self.tableView.rx.contentOffset
            .flatMap { offset in
                self.isNearTheBottomEdge(offset, self.tableView)
                    ? Observable.just(())
                    : Observable.empty()
        }
        viewModel = UserViewModel(githubService: RestAPIService(),
                                  loadNextPageTrigger: loadNextPageTrigger)
        addBindsToViewModel(viewModel: viewModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let followersVC = segue.destination as? FollowersListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            followersVC?.user = try? tableView.rx.model(at: indexPath)
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

