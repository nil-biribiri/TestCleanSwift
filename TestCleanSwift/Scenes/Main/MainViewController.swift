//
//  MainViewController.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 25/5/2561 BE.
//  Copyright (c) 2561 NilNilNil. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainDisplayLogic: class
{
  func displayFetchList(viewModel: Main.Something.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic
{
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
  var movieList: [Main.Something.ViewModel.Movie] = []

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
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    showMovieList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.title = "Movies"
    self.view.backgroundColor = .black
  }
  
  // MARK: Do something
  
  @IBOutlet weak var tableView: UITableView! {
    didSet{
      tableView.delegate        = self
      tableView.dataSource      = self
      tableView.tableFooterView = UIView(frame: .zero)
      tableView.register(
        UINib(nibName: MainTableViewCell.cellIdentifier, bundle: nil),
        forCellReuseIdentifier: MainTableViewCell.cellIdentifier
      )
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 150
      tableView.backgroundColor = .black
      tableView.separatorStyle = .none
    }
  }

  private func showMovieList()
  {
    interactor?.fetchMovie()
  }
  
  func displayFetchList(viewModel: Main.Something.ViewModel)
  {
    movieList = viewModel.movieList
    self.tableView.reloadData()
  }
    
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let movie = movieList[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellIdentifier, for: indexPath) as? MainTableViewCell
      else { return UITableViewCell() }
      cell.configureData(data: movie)
      return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieList.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    router?.navigateToInfo(movie: movieList[indexPath.row])
  }
  
}
