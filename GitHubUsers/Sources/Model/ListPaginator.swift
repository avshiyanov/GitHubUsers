//
//  ListPaginator.swift
//  GitHubUsers
//
//  Created by Artem Shyianov on 2/18/17.
//  Copyright © 2017 Artem Shyianov. All rights reserved.
//

import Foundation

struct ListPaginator {
    // MARK: Properies
    
    private var itemsOnPage: UInt = 10
    private var currentPage: UInt = 0
    
    func itemsPerPage() -> UInt {
        return itemsOnPage
    }
    
    func curentPage() -> UInt {
        return currentPage
    }
    
    func currentlyMaxAmountOfItems() -> Int {
        return Int(curentPage() * itemsPerPage())
    }
    
    mutating func increasePage() -> ListPaginator {
        currentPage = currentPage + 1
        return self
    }
}
