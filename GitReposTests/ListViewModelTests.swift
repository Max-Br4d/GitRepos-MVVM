//
//  ListInteractorTests.swift
//  GitReposTests
//
//  Created by Max on 11/04/22.
//

import XCTest
@testable import GitRepos

class ListViewModelTests: XCTestCase {

    var listController: ListViewController!

    override func setUpWithError() throws {
        
        listController =  ListRouterInput().view(entryEntity: ListEntryEntity(language: "Swift"), gitHubApi: FakeApiTask())
    }


    func testGetRepo_success() {
        
        let request = SearchLanguageRequest(language:"search_responce_success", page:1)

        listController.viewModel?.fetchSearch(request: request)
        
        
        XCTAssertEqual(        listController.viewModel?.entities.gitHubRepositories.count
                               , 30)
    }
    
    func testGetRepo_failure() {

        let request = SearchLanguageRequest(language:"search_responce_failure", page:1)

        listController.viewModel?.fetchSearch(request: request)


        XCTAssertEqual(        listController.viewModel?.entities.gitHubRepositories.count
                               , 0)
    }

}
