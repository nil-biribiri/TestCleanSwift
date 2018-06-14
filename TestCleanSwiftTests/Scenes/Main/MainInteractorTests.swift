//
//  MainInteractorTests.swift
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

class MainInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: MainInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupMainInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupMainInteractor()
  {
    sut = MainInteractor()
  }
  
  // MARK: Test doubles
  
  class MainPresentationLogicSpy: MainPresentationLogic
  {
    // MARK: Method call expectations

    var presentMovieListCalled = false
    var presentErrorMessage = false
    var presentShowLoading = false
    var presentHideLoading = false
    
    // MARK: Spied methods
    
    func presentErrorMessage(error: Main.Something.Error) {
      presentErrorMessage = true
    }
    
    func showLoading() {
      presentShowLoading = true
    }
    
    func hideLoading() {
      presentHideLoading = true
    }
    
    func presentMovieList(response: Main.Something.Response)
    {
      presentMovieListCalled = true
    }
  }
  
  class MainWorkerSuccessSpy: MainWorker {
    var fetchListCalled = false
    var movieList = MovieList(movies: [Movie(name: "", voteAverage: 0, posterPath: "", overview: "")], page: 1)
    override func fetchList(page: String, completion: @escaping (Result<(MovieList)>) -> Void) {
      fetchListCalled = true
      completion(Result.success(movieList))
    }
  }
  
  class MainWorkerFailureSpy: MainWorker {
    var fetchListCalled = false
    override func fetchList(page: String, completion: @escaping (Result<(MovieList)>) -> Void) {
      fetchListCalled = true
      completion(Result.failure(NetworkServiceError.cannotGetErrorMessage))
    }
  }
  
  
}

// MARK: Tests

extension MainInteractorTests {
  
  func testFetchMovieSuccessInteractor() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    let workerSpy = MainWorkerSuccessSpy()
    sut.worker = workerSpy
    let request = Main.Something.Request(loadingIndicator: true)
    
    // When
    sut.fetchMovie(request: request)
    
    // Then
    XCTAssertTrue(workerSpy.fetchListCalled, "fetchMovie() should ask MainWorker to fetch orders")
    XCTAssertTrue(spy.presentShowLoading, "fetchMovie() should ask the presenter to show loading")
    XCTAssertTrue(spy.presentMovieListCalled, "fetchMovie() should ask the presenter present movie list")
  }
  
  func testFetchMovieFailureInteractor() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    let workerSpy = MainWorkerFailureSpy()
    sut.worker = workerSpy
    let request = Main.Something.Request(loadingIndicator: true)
    
    // When
    sut.fetchMovie(request: request)
    
    // Then
    XCTAssertTrue(workerSpy.fetchListCalled, "fetchMovie() should ask MainWorker to fetch orders")
    XCTAssertTrue(spy.presentShowLoading, "fetchMovie() should ask the presenter to show loading")
    XCTAssertTrue(spy.presentErrorMessage, "fetchMovie() should ask the presenter present error message")
  }
  
}

extension MainInteractorTests {
  
  func testRefreshMovieSuccessInteractor() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    let workerSpy = MainWorkerSuccessSpy()
    sut.worker = workerSpy
    sut.movieList = MovieList(movies: [Movie](), page: 1)
    sut.currentPage = 10
    let request = Main.Something.Request(loadingIndicator: false)

    // When
    sut.refreshMovie(request: request)
    
    // Then
    XCTAssertTrue(workerSpy.fetchListCalled, "refreshMovie() should ask MainWorker to fetch orders")
    XCTAssertFalse(spy.presentShowLoading, "refreshMovie() should not ask the presenter to show loading")
    XCTAssertTrue(spy.presentMovieListCalled, "refreshMovie() should ask the presenter present movie list")
    XCTAssertEqual(sut.movieList!, workerSpy.movieList, "refreshMovie() should reset movieList to nil then set to new movie list")
    XCTAssertEqual(sut.movieList!.page, workerSpy.movieList.page, "refreshMovie() should reset page to nil then set to new page")
  }
  
  func testRefreshMovieFailureInteractor() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    let workerSpy = MainWorkerFailureSpy()
    sut.worker = workerSpy
    sut.movieList = MovieList(movies: [Movie](), page: 1)
    sut.currentPage = 10
    sut.response = Main.Something.Response(movieList: MovieList(movies: [Movie](), page: 11))
    let request = Main.Something.Request(loadingIndicator: false)
    
    // When
    sut.refreshMovie(request: request)
    
    // Then
    XCTAssertTrue(workerSpy.fetchListCalled, "refreshMovie() should ask MainWorker to fetch orders")
    XCTAssertFalse(spy.presentShowLoading, "refreshMovie() should not ask the presenter to show loading")
    XCTAssertTrue(spy.presentErrorMessage, "refreshMovie() should ask the presenter present error message")
    XCTAssertNil(sut.movieList, "refreshMovie() should reset movieList to nil")
    XCTAssertNil(sut.currentPage, "refreshMovie() should reset currentPage to nil")
    XCTAssertNil(sut.response, "refreshMovie() should reset response to nil")
  }
}

extension MainInteractorTests {
  func testLoadMoreMovieSuccessInteractor() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    let workerSpy = MainWorkerSuccessSpy()
    sut.worker = workerSpy
    sut.movieList = MovieList(movies: [Movie(name: "", voteAverage: 0, posterPath: "", overview: "")], page: 1)
    sut.currentPage = 10
    let request = Main.Something.Request(loadingIndicator: false)
    let storedMovieList = sut.movieList!
    
    // When
    sut.fetchMoreMovie(request: request)
    
    // Then
    XCTAssertTrue(workerSpy.fetchListCalled, "fetchMoreMovie() should ask MainWorker to fetch orders")
    XCTAssertFalse(spy.presentShowLoading, "fetchMoreMovie() should not ask the presenter to show loading")
    XCTAssertTrue(spy.presentMovieListCalled, "fetchMoreMovie() should ask the presenter present movie list")
    XCTAssertEqual(sut.movieList!.movies, storedMovieList.movies + workerSpy.movieList.movies, "fetchMoreMovie() should append movie list")
    XCTAssertEqual(sut.movieList!.page, workerSpy.movieList.page, "fetchMoreMovie() should set page to new page")
  }
  
  func testLoadMoreMovieFailureInteractor() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    let workerSpy = MainWorkerFailureSpy()
    sut.worker = workerSpy
    sut.movieList = MovieList(movies: [Movie](), page: 1)
    sut.currentPage = 10
    let request = Main.Something.Request(loadingIndicator: false)
    let storedMovieList = sut.movieList!

    // When
    sut.fetchMoreMovie(request: request)
    
    // Then
    XCTAssertTrue(workerSpy.fetchListCalled, "fetchMoreMovie() should ask MainWorker to fetch orders")
    XCTAssertFalse(spy.presentShowLoading, "fetchMoreMovie() should not ask the presenter to show loading")
    XCTAssertTrue(spy.presentErrorMessage, "fetchMoreMovie() should ask the presenter present error message")
    XCTAssertEqual(sut.movieList!.movies, storedMovieList.movies, "fetchMoreMovie() should not mutate movie list")
    XCTAssertEqual(sut.movieList!.page, storedMovieList.page, "fetchMoreMovie() should not mutate page")
  }

  func testValidateInput() {
    // Given
    let spy = MainPresentationLogicSpy()
    sut.presenter = spy
    sut.response = Main.Something.Response(movieList: MovieList(movies: [Movie](), page: 1))

    // When
    sut.validateInput(textInput: nil, indexPath: 1)
    sut.validateInput(textInput: "Some Input", indexPath: 2)

    // Then
    XCTAssertFalse(sut.response?.validateError?.filter{ $0.validateErrorIndex == 1 }.isEmpty ?? true, "testValidateInput() should append indexPath of incorrect input")
    XCTAssertEqual(sut.response?.validateError?.filter{ $0.validateErrorIndex == 1 }.first?.validateErrorMessage, "Empty input.", "testValidateInput() should append empty input message of incorrect indexPath")
    XCTAssertTrue(sut.response?.validateError?.filter{ $0.validateErrorIndex == 2 }.isEmpty ?? true, "testValidateInput() should not append indexPath of correct input")
  }
  
}
