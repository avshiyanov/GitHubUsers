//
//  HUD.swift
//  GitHubUsers
//
//  Created by Artem Shyianov on 1/21/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import UIKit
import PKHUD

class HUD {
    
    class func show() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    class func show(error: Error) {
        let errorView =  PKHUDErrorView(subtitle: error.localizedDescription)
        HUD.hide()
        PKHUD.sharedHUD.contentView = errorView
        PKHUD.sharedHUD.show()
    }
    
    class func hide() {
        PKHUD.sharedHUD.hide()
    }
}
