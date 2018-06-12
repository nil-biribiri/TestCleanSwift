//
//  MainTableViewCell.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 31/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  
  static let cellIdentifier = String(describing: MainTableViewCell.self)
  
  @IBOutlet weak var moviePosterImageView: NilImageCaching!
  @IBOutlet weak var movieNameLabel: UILabel!
  @IBOutlet weak var movieRateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setUI()
  }
  
  private func setUI() {
    movieNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    movieRateLabel.font = UIFont.systemFont(ofSize: 14.0)
    
    selectionStyle = .none
    backgroundColor = .black
    movieNameLabel.textColor = .white
    movieRateLabel.textColor = .white
  }
  
  func configureData(data: Main.Something.ViewModel.Movie) {
    movieNameLabel.text = data.movieTitle
    movieRateLabel.text = data.movieRating
    moviePosterImageView.imageCaching(link: data.moviePosterPath, contentMode: .scaleAspectFit)
//    moviePosterImageView.downloadedFrom(link: data.posterPath, contentMode: .scaleAspectFill)
  }
  
 
}
