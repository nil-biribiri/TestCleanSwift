//
//  MainPresenterTests.swift
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

class MainPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: MainPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupMainPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupMainPresenter()
  {
    sut = MainPresenter()
  }
  
  // MARK: Test doubles
  
  class MainDisplayLogicSpy: MainDisplayLogic
  {
    // MARK: Method call expectations
    
    var displayFetchListCalled = false
    var displayErrorCalled = false
    var displayLoaderCalled = false
    var hideLoaderCalled = false
    
    // MARK: Argument expectations
    
    var viewModel: Main.Something.ViewModel!
    
    // MARK: Spied methods
    
    func displayFetchList(viewModel: Main.Something.ViewModel) {
      displayFetchListCalled = true
      self.viewModel = viewModel
    }
    
    func displayError(title: String, message: String) {
      displayErrorCalled = true
    }
    
    func displayLoader() {
      displayLoaderCalled = true
    }
    
    func hideLoader() {
      hideLoaderCalled = true
    }
  }
  
  // MARK: Tests
  func testDisplayFetchListFormatData() {
    // Given
    let listOrdersDisplayLogicSpy = MainDisplayLogicSpy()
    sut.viewController = listOrdersDisplayLogicSpy
    
    // When
    let mockMovieList = [Movie(title: "Inception", voteAverage: 10, posterPath: "InceptionPath", overview: "Some Inception detail"),
                         Movie(title: "Shutter Island", voteAverage: 8.5, posterPath: "ShutterIslandPath", overview: "Some Shutter Island detail")]
    let mockValidateErrorList = [Main.Something.Response.validateError(validateErrorIndex: 1, validateErrorMessage: "Empty Input.")]
    let mockResponse: Main.Something.Response = Main.Something.Response(movieList: MovieList(movies: mockMovieList, page: 1), validateError: mockValidateErrorList)
    sut.presentMovieList(response: mockResponse)
    
    // Then
    let displayedOrders = listOrdersDisplayLogicSpy.viewModel.movieList
    let sourceOrders  = mockResponse.movieList.movies.compactMap{$0}
    for (displayedOrder, sourceOrder) in zip(displayedOrders, sourceOrders) {
      XCTAssertEqual(displayedOrder.movieTitle, sourceOrder.title, "Presenting fetched orders should properly format order movieTitle")
      XCTAssertEqual(displayedOrder.movieRating, "Rating: \(sourceOrder.voteAverage)/10", "Presenting fetched orders should properly format order movieRating")
      XCTAssertEqual(displayedOrder.moviePosterPath, "https://image.tmdb.org/t/p/w200\(sourceOrder.posterPath)", "Presenting fetched orders should properly format order moviePosterPath")
    }
    XCTAssertEqual(mockResponse.validateError?.first?.validateErrorMessage, displayedOrders[1].movieInputErrorMessage, "Presenting fetched orders should properly format order movieInputErrorMessage")
  }
  
  func testDisplayFetchList() {
    // Given
    let spy = MainDisplayLogicSpy()
    sut.viewController = spy
    let response = Main.Something.Response(movieList: MovieList(movies: [Movie](), page: 1))
    
    // When
    sut.presentMovieList(response: response)
    
    // Then
    XCTAssertTrue(spy.hideLoaderCalled, "presentMovieList(response:) should ask the view controller to hide loader")
    XCTAssertTrue(spy.displayFetchListCalled, "presentMovieList(response:) should ask the view controller to display the result")
  }
  
  func testDisplayError() {
    // Given
    let spy = MainDisplayLogicSpy()
    sut.viewController = spy
    let error = Main.Something.Error(errorMessage: "Error")
    
    // When
    sut.presentErrorMessage(error: error)
    
    // Then
    XCTAssertTrue(spy.hideLoaderCalled, "presentErrorMessage(error:) should ask the view controller to hide loader")
    XCTAssertTrue(spy.displayErrorCalled, "presentErrorMessage(error:) should ask the view controller to display the error")
  }
  
}
