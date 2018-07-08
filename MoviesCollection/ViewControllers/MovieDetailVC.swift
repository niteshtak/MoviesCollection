//
//  MovieDetailVC.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import UIKit
import MBProgressHUD

class MovieDetailVC: UITableViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var headerView: UIView!
	
	var movie: Movie?
	var order: [MovieDetailSection] = [.Title, .Duration, .Overview, .Genres, .Synopsis, .Language]
	private var genreMap = [Int : String]()
	private var movieLanguage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.tableFooterView = nil
		self.tableView.tableHeaderView = headerView
		
		configureView()
		self.getMovieDetails()
    }
	
	func configureView() {
		if movie != nil {
			title = movie?.title
			//imageView.image = UIImage(named:"placeholder")
			if let url = movie!.backdropURL {
				self.imageView.af_setImage(withURL: url)
			} else {
				self.tableView.tableHeaderView = nil
			}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}
	
	// MARK: Genres
	private func genreIdsToText(_ genres:[Int]) -> String {
		if genreMap.count == 0 {
			return "Not Available"
		}
		var genreText = [String]()
		for id in genres {
			if let genre = genreMap[id] {
				genreText += [genre]
			}
		}
		return genreText.joined(separator: ", ")
	}
	
	// MARK: Language
	private func getLanguage(_ languageSpoken: [[String: Any]]?) -> String {
		
		if languageSpoken != nil && languageSpoken?.count == 0 {
			return self.movieLanguage
		}
		
		var languageText = [String]()
		if (languageSpoken?.count)! > 0 {
			for language in languageSpoken! {
				languageText += [language[Constants.ServerKey.name] as! String]
			}
		}
		return languageText.joined(separator: ", ")
	}
	
	func getMovieDetails() {
		
		guard let movie = self.movie else { return }
		
		let path = Constants.movieDetailPath + "\(movie.id)"
		
		MBProgressHUD.showAdded(to: self.tableView, animated: true)
		
		WebServiceAPI.sharedInstance.getData(path, parameters: nil) { (response, error) in
			
			MBProgressHUD.hide(for: self.tableView, animated: true)
			
			guard let response = response as? [String : Any] else { return }
			guard let movie = Movie(response: response as AnyObject) else { return }
			
			let oldMovieData = self.movie
			if let genresIds = oldMovieData?.genereIds, genresIds.count > 0  {
				self.movie = movie
				self.movie?.genereIds = oldMovieData!.genereIds
			}
			
			if let generes = self.movie?.genres {
				var genres = [Int : String]()
				let results =  generes
				for result in results {
					if let name = result[Constants.ServerKey.name] as? String {
						let id = result[Constants.ServerKey.id] as! Int
						genres[id] = name
					}
				}
				
				if genres.count > 0  {
					self.genreMap = genres
				}
			}
			self.tableView.reloadData()
		}
	}
	
	// MARK: Table view
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.order.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: indexPath) as! MovieDetailCell
		
		cell.descriptionLabel.text = self.textForCell(indexPath:indexPath)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView =  UIView()
		headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
		
		let titleLabel = UILabel()
		titleLabel.frame = CGRect(x: 8, y: 0, width: headerView.frame.size.width, height: 30)
		titleLabel.textColor = AppColors.peachColor
		titleLabel.font = AppFonts.defaultSemiBoldFontWithSize(size: 18)
		titleLabel.text = self.order[section].rawValue
		
		headerView.addSubview(titleLabel)
		
		if section == 0 {
			headerView.backgroundColor = .black
		} else {
			headerView.backgroundColor = .clear
		}

		return headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30.0
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.1
	}

	func textForCell(indexPath i:IndexPath) -> String {
		let section = self.order[i.section]
		
		switch section {
		case .Overview:
			return movie?.overview ?? "not available"
		case .Title:
			return movie?.title ?? "not available"
		case .Duration:
			if let runtime = movie?.runtime, runtime > 0 {
				return "\(runtime) minutes"
			}
			return "Not Available"
		case .Genres:
			return genreIdsToText((movie?.genereIds)!)
		case .Synopsis:
			if let synopsis = movie?.synopsis, synopsis != "" {
				return synopsis
			}
			return "Not Available"
		case .Language:
			if let languageSpoken = self.movie?.spokenLanguages {
				return getLanguage(languageSpoken)
			}
			return "Not Available"
		}
	}
}
