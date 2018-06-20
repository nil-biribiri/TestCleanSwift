//
//  InfoViewController.swift
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

protocol InfoDisplayLogic: class
{
  func displayMovieDetail(viewModel: Info.Something.ViewModel)
}

class InfoViewController: UIViewController, InfoDisplayLogic
{
  
  var interactor: InfoBusinessLogic?
  var router: (NSObjectProtocol & InfoRoutingLogic & InfoDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = InfoInteractor()
    let presenter = InfoPresenter()
    let router = InfoRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor?.showMovieDetail()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUI()
  }
    
  // MARK: Do something
  
//  @IBOutlet weak var movieNameLabel: UILabel!
  @IBOutlet weak var movieImageView: NilImageCaching!
  @IBOutlet weak var blurImageView: NilImageCaching! {
    didSet{
      blurImageView.addBlurEffect(withStyle: .dark)
    }
  }
  @IBOutlet weak var movieDetailLabel: UILabel! {
    didSet{
      movieDetailLabel.textColor = .white
      movieDetailLabel.text = ""
    }
  }
  
  private func setUI() {
    view.backgroundColor = .black
  }
  
  
  func displayMovieDetail(viewModel: Info.Something.ViewModel) {
    title = viewModel.movie.movieTitle
    movieImageView.imageCaching(link: viewModel.movie.moviePosterPath, contentMode: .scaleAspectFill) {
      self.blurImageView.imageCaching(link: viewModel.movie.moviePosterPath, contentMode: .scaleAspectFill)
      self.movieDetailLabel.text = viewModel.movie.movieOverview
    }
    
  }
}
