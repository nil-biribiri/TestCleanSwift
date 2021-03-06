//
//  MainTableViewCell.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 31/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import UIKit

protocol MainTableViewCellProtocol: class {
  func movieButtonAction(textInput: String?, indexPath: Int)
}

class MainTableViewCell: UITableViewCell {
  
  static let cellIdentifier = String(describing: MainTableViewCell.self)
  
  @IBOutlet weak var moviePosterImageView: NilImageCaching!{
    didSet{
      moviePosterImageView.accessibilityIdentifier    = "mainCell.moviePosterImageView"
    }
  }
  @IBOutlet weak var movieNameLabel: UILabel!
  @IBOutlet weak var movieRateLabel: UILabel!
  @IBOutlet weak var movieInput: UITextField!
  @IBOutlet weak var movieButton: UIButton!

  weak var delegate: MainTableViewCellProtocol?
  
  private var rowOfIndexPath : Int = 0

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setUI()
    setIdentifier()
  }
  
  private func setUI() {
    movieNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    movieRateLabel.font = UIFont.systemFont(ofSize: 14.0)
    
    selectionStyle = .none
    backgroundColor = .black
    movieNameLabel.textColor = .white
    movieRateLabel.textColor = .white
  }

  private func setIdentifier() {
    movieNameLabel.accessibilityIdentifier          = "mainCell.movieNameLabel"
    movieRateLabel.accessibilityIdentifier          = "mainCell.movieRateLabel"
    moviePosterImageView.accessibilityIdentifier    = "mainCell.moviePosterImageView"

  }

  
  func configureData(data: Main.Something.ViewModel.Movie, indexPath: Int) {
    accessibilityIdentifier = "mainCell_\(indexPath)"
    movieNameLabel.text = data.movieTitle
    movieRateLabel.text = data.movieRating
    moviePosterImageView.imageCaching(link: data.moviePosterPath, contentMode: .scaleAspectFit, withDownloadIndicator: true)
    movieInput.text = data.movieInputErrorMessage
    rowOfIndexPath = indexPath
  }
  
  @IBAction func movieButtonAction(_ sender: Any) {
    delegate?.movieButtonAction(textInput: movieInput.text, indexPath: rowOfIndexPath)
  }
 
}
