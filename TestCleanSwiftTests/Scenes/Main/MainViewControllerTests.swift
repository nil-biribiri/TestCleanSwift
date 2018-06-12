//
//  MainViewControllerTests.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 12/6/2561 BE.
//  Copyright (c) 2561 NilNilNil. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import TestCleanSwift
import XCTest

class MainViewControllerTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: MainViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupMainViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupMainViewController() {
    sut = MainViewController()
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class MainBusinessLogicSpy: MainBusinessLogic {
    // MARK: Method call expectations
    
    var fetchMovieCalled = false
    var fetchMoreMovieCalled = false
    var refreshMovieCalled = false
    
    // MARK: Spied methods

    func fetchMovie(request: Main.Something.Request) {
      fetchMovieCalled = true
    }
    
    func fetchMoreMovie(request: Main.Something.Request) {
      fetchMoreMovieCalled = true
    }
    
    func refreshMovie(request: Main.Something.Request) {
      refreshMovieCalled = true
    }
    
  }
  
  class TableViewSpy: UITableView {
    // MARK: Method call expectations
    
    var reloadDataCalled = false
    
    // MARK: Spied methods
    
    override func reloadData()
    {
      reloadDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testShouldFetchMovieWhenViewIsLoaded() {
    // Given
    let spy = MainBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    
    // Then
    XCTAssertTrue(spy.fetchMovieCalled, "viewDidLoad() should ask the interactor to fetch movie")
  }
  
  func testShouldDisplayFetchedOrders() {
    // Given
    let tableViewSpy = TableViewSpy()
    sut.tableView = tableViewSpy
    
    // When
    let mockMovieList = [Main.Something.ViewModel.Movie(movieTitle: "Inception", movieRating: "10/10", moviePosterPath: "Inception Poster path")]
    let viewModel = Main.Something.ViewModel(movieList: mockMovieList)
    sut.displayFetchList(viewModel: viewModel)
    
    // Then
    XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched orders should reload the table view")
  }
  
  func testTableViewSectionShouldAlwaysBeOne() {
    // Given
    let tableViewSpy = TableViewSpy()
    sut.tableView = tableViewSpy

    // When
    let numberOfSections = sut.numberOfSections(in: sut.tableView!)
    
    // Then
    XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
  }
  
  func testNumberOfRowsShouldEqualNumberOfMovieList() {
    // Given
    let tableViewSpy = TableViewSpy()
    sut.tableView = tableViewSpy
    let mockMovieList = [Main.Something.ViewModel.Movie(movieTitle: "Inception", movieRating: "10/10", moviePosterPath: "Inception Poster path")]
    sut.movieList  = mockMovieList

    // When
    let numberOfRows = sut.tableView(sut.tableView!, numberOfRowsInSection: 0)

    // Then
    XCTAssertEqual(numberOfRows, mockMovieList.count, "The number of table view rows should equal the number of orders to display")
  }

  func testShouldConfigureTableViewCellToDisplayMovieDetail() {
    // Given
    let tableViewSpy = TableViewSpy()
    sut.tableView = tableViewSpy
    let mockMovieList = [Main.Something.ViewModel.Movie(movieTitle: "Inception", movieRating: "10/10", moviePosterPath: "Inception Poster path")]
    sut.movieList  = mockMovieList

    // When
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = sut.tableView(sut.tableView!, cellForRowAt: indexPath) as? MainTableViewCell
    
    // Then
    XCTAssertEqual(cell?.movieNameLabel.text, "Inception", "A properly configured table view cell should display the order movieName")
    XCTAssertEqual(cell?.movieRateLabel.text, "10/10", "A properly configured table view cell should display the order movieRate")

  }
  
}
