//
//  MovieCell.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var moviewPoster: UIImageView!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	@IBOutlet weak var parentView: UIView!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		moviewPoster.clipsToBounds = true
		moviewPoster.layer.cornerRadius = 5.0
		parentView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
