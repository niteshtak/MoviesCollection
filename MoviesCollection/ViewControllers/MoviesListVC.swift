//
//  MoviesListVC.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import UIKit
import MBProgressHUD
import AlamofireImage
import UIScrollView_InfiniteScroll

class MoviesListVC: UIViewController {
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.tableFooterView = UIView()
			tableView.rowHeight = UITableViewAutomaticDimension
			tableView.estimatedRowHeight = 44.0
		}
	}
	
	var loadInProgress = false
	private var page = 1
	private var totalPages = 1
	private var movies = [Movie]()
	
	var selectedMovie: Movie?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Movies Collection"

		//Set Navigation Bar
		self.navigationController?.navigationBar.tintColor = .black
		self.navigationController?.navigationBar.backgroundColor = .black
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): AppFonts.defaultMediumFontWithSize(size: 20), NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor.black]
		
		self.setBackButton()
		
		self.getMovieList()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.addInfiniteScroll { (tableView) -> Void in
			self.fetchNextPageMovies()
		}
	}
	
	func setBackButton() {
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
	}
	
	func getMovieList() {
		
		let query = "superman"
		let path = "\(Constants.movieSearchPath)&query=\(query)&page=\(self.page)"
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		WebServiceAPI.sharedInstance.getData(path, parameters: nil) { (response, error) in
			
			MBProgressHUD.hide(for: self.view, animated: true)
			self.tableView.finishInfiniteScroll()
			
			guard let response = response as? [String: Any] else { return }
			print(response)
			
			guard let resultArray = response["results"] as? [[String: Any]], resultArray.count > 0  else { return }
			
			guard let movies = Movie.parseListData(resultArray) else { return }

			self.totalPages = response["total_pages"] as? Int ?? 1
			self.movies = movies
			self.tableView.reloadData()
			self.page = self.page + 1
		}
	}
	
	func fetchNextPageMovies() {
		
		if loadInProgress {
			return
		}
		
		if self.page >= self.totalPages {
			self.tableView.removeInfiniteScroll()
			return
		}
		
		loadInProgress = true
		
		let query = "superman"
		let path = "\(Constants.movieSearchPath)&query=\(query)&page=\(self.page)"
		
		WebServiceAPI.sharedInstance.getData(path, parameters: nil) { (response, error) in
			
			if let error = error {
				//To Do: show error
				print(error.message)
				return
			}
			
			self.tableView.finishInfiniteScroll()
			
			guard let response = response as? [String: Any] else { return }
			print(response)
			
			guard let resultArray = response["results"] as? [[String: Any]], resultArray.count > 0  else { return }
			
			guard let movies = Movie.parseListData(resultArray) else { return }
			
			self.totalPages = response["total_pages"] as? Int ?? 1

			// insert new rows
			let count = self.movies.count
			let additional = movies.count
			
			var paths = [IndexPath]()
			for i in count..<(count + additional) {
				paths += [IndexPath(row: i, section: 0)]
			}
			
			self.movies += movies
			
			self.tableView.insertRows(at: paths, with: .fade)
			
			self.page = self.page + 1
			self.loadInProgress = false
		}
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowMovieDetail" {
			let vc = segue.destination as! MovieDetailVC
			vc.movie = self.selectedMovie
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
}

extension MoviesListVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let movie = self.movies[indexPath.row]
		self.selectedMovie = movie
		self.performSegue(withIdentifier: "ShowMovieDetail", sender: self)
		
	}
}

extension MoviesListVC: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.movies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
		
		let movie = self.movies[indexPath.row]
		if let urlString = movie.thumbnailURL?.absoluteString, urlString.count > 1 {
			cell.moviePoster.af_setImage(withURL: URL(string: urlString)!)
		}
		cell.titleLabel.text = movie.title
		cell.releaseDateLabel.text = "Release Date: " + movie.releaseDate
		cell.overviewLabel.text = movie.overview
		
		return cell
	}
}
