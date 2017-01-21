//
//  OfferViewCell.swift
//  GitHubUsersSample
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import AlamofireImage

let UserCellIdentifier = "UserCellIdentifier"

class UserViewCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileLinkLabel: UILabel!
    
    // MARK: -

    func configure(viewModel: GitHubUser) {
        loginLabel.text = viewModel.login
        profileLinkLabel.text = viewModel.profileURL
        if let avatarURL = URL(string: viewModel.avatarURL) {
            let filter = AspectScaledToFillSizeFilter(size: avatarImageView.frame.size)
            avatarImageView.af_setImage(withURL: avatarURL, filter: filter)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.af_cancelImageRequest()
        avatarImageView.image = nil
    }
}
