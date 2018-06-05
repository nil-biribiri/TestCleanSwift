//
//  InfoPresenter.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 28/5/2561 BE.
//  Copyright (c) 2561 NilNilNil. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol InfoPresentationLogic
{
  func presentSomething(response: Info.Something.Response)
  func presentMovie(response: Info.Something.Response)
}

class InfoPresenter: InfoPresentationLogic
{
  
  

  weak var viewController: InfoDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Info.Something.Response)
  {
//    let viewModel = Info.Something.ViewModel()
//    viewController?.displaySomething(viewModel: viewModel)
  }
  
  func presentMovie(response: Info.Something.Response) {
    let posterPath = "https://image.tmdb.org/t/p/original\(response.movie.posterPath)"
    let rating     = "Rating: \(response.movie.voteAverage)/10"
    let movie = Info.Something.ViewModel.Movie(movieTitle: response.movie.title,
                                               movieRating: rating,
                                               moviePosterPath: posterPath,
                                               movieOverview: response.movie.overview)
    let viewModel = Info.Something.ViewModel(movie: movie)
    viewController?.displayMovieDetail(viewModel: viewModel)
  }
  
}
