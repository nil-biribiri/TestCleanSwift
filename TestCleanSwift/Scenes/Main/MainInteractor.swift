//
//  MainInteractor.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 25/5/2561 BE.
//  Copyright (c) 2561 NilNilNil. All rights reserved.
//
//  This file was generated by the Clean varft Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainBusinessLogic
{
  func fetchMovie(request: Main.Something.Request)
  func fetchMoreMovie(request: Main.Something.Request)
  func refreshMovie(request: Main.Something.Request)
  func validateInput(textInput: String?, indexPath: Int)
}

protocol MainDataStore
{
  var movieList: MovieList? { get }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
  
  var movieList: MovieList?
  var currentPage: Int?
  var response: Main.Something.Response?
  
  var presenter: MainPresentationLogic?
  var worker = MainWorker()
  
  // MARK: Do something
  
  func fetchMovie(request: Main.Something.Request) {
    request.loadingIndicator ? presenter?.showLoading() : nil

    let fetchingPage = String(currentPage ?? 1)
    worker.fetchList(page: fetchingPage) { (result) in
      switch result {
      case .success(let value):
        if self.movieList == nil {
          self.movieList = value.bodyObject
        } else {
          self.movieList?.movies += value.bodyObject.movies
        }
        self.currentPage = value.bodyObject.page
        self.response = Main.Something.Response(movieList: self.movieList!, validateError: self.response?.validateError)
        self.presenter?.presentMovieList(response: self.response!)
      case .failure(let error):
        self.presenter?.presentErrorMessage(error: Main.Something.Error(errorMessage: error.localizedDescription))
      }
    }
  }

  func fetchMoreMovie(request: Main.Something.Request) {
    if currentPage != nil {
      currentPage! += 1
    }
    fetchMovie(request: request)
  }

  func refreshMovie(request: Main.Something.Request) {
    movieList = nil
    currentPage = nil
    response = nil
    fetchMovie(request: request)
  }
  
  func validateInput(textInput: String?, indexPath: Int) {
    guard let text = textInput, text != "" else {
      let validateError = Main.Something.Response.validateError(validateErrorIndex: indexPath, validateErrorMessage: "Empty input.")
      if response?.validateError == nil {
        response?.validateError = []
      }
      if var storedValidate = response?.validateError {
        storedValidate.append(validateError)
        response?.validateError = storedValidate
      }
      
      guard let checkMovieList = movieList else { return }
      response = Main.Something.Response(movieList: checkMovieList, validateError: response?.validateError)
      self.presenter?.presentMovieList(response: response!)
      return
    }
  }
}

