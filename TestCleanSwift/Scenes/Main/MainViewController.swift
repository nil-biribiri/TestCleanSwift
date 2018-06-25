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

protocol MainDisplayLogic: BaseDisplayLogic {
  func displayFetchList(viewModel: Main.Something.ViewModel)
  func displayError(title: String, message: String)
}

class MainViewController: BaseViewController, MainDisplayLogic
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
    self.navigationController?.navigationBar.accessibilityLabel = "MainScene.Title"
    showMovieList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.title = "Movies"
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
      tableView.refreshControl = refreshControl
      tableView.accessibilityIdentifier = "MainScene.MainMovieTableView"
    }
  }

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(self.refreshMovieList),
                             for: .valueChanged)
    refreshControl.tintColor = .white

    return refreshControl
  }()

  lazy var loadingSpinner: UIActivityIndicatorView = {
    let loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    loadingSpinner.accessibilityIdentifier = "MainScene.LoadMoreView"
    loadingSpinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40.0)
    loadingSpinner.startAnimating()
    return loadingSpinner
  }()

  private func showMovieList() {
    let fetchMovieRequest = Main.Something.Request(loadingIndicator: true)
    interactor?.fetchMovie(request: fetchMovieRequest)
  }

  private func showMoreMovieList() {
    let fetchMovieRequest = Main.Something.Request(loadingIndicator: false)
    interactor?.fetchMoreMovie(request: fetchMovieRequest)
  }

  @objc private func refreshMovieList() {
    let fetchMovieRequest = Main.Something.Request(loadingIndicator: false)
    interactor?.refreshMovie(request: fetchMovieRequest)
  }

  func displayFetchList(viewModel: Main.Something.ViewModel) {
    movieList = viewModel.movieList
    refreshControl.endRefreshing()
    UIView.animate(withDuration: 0.1, animations: {
      self.tableView.tableFooterView = nil
    }) { [weak self] _ in
      self?.tableView.reloadData()
    }
  }

  func displayError(title: String, message: String) {
    showInfoAlert(title: title, message: message, buttonTitle: "OK") { _ in
      self.refreshControl.endRefreshing()
      self.tableView.tableFooterView = nil
    }
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellIdentifier, for: indexPath) as? MainTableViewCell,
      movieList.indices.contains(indexPath.row)
      else { return UITableViewCell() }
      let movie = movieList[indexPath.row]
      cell.configureData(data: movie, indexPath: indexPath.row)
      cell.delegate = self
      return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieList.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    router?.navigateToInfo(movie: movieList[indexPath.row])
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastElement = movieList.count - 1
    if indexPath.row == lastElement {
      // handle your logic here to get more items, add it to dataSource and reload tableview
      tableView.tableFooterView = loadingSpinner
      showMoreMovieList()
    }
  }
  
}

extension MainViewController: MainTableViewCellProtocol {
  func movieButtonAction(textInput: String?, indexPath: Int) {
    interactor?.validateInput(textInput: textInput, indexPath: indexPath)
  }
}
