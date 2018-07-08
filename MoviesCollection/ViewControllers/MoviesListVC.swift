//
//  MoviesListVC.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import UIKit
import MBProgressHUD

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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Movies Collection"

		//Set Navigation Bar
		self.navigationController?.navigationBar.tintColor = .white
		self.navigationController?.navigationBar.backgroundColor = .black
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): AppFonts.defaultMediumFontWithSize(size: 20), NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor.black]
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.getMovieList()
	}
	
	func getMovieList() {
		
		let query = "superman"
		let path = "\(Constants.movieSearchPath)&query=\(query)&page=\(self.page)"
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		WebServiceAPI.sharedInstance.getData(path, parameters: nil) { (response, error) in
			
			MBProgressHUD.hide(for: self.view, animated: true)
			
			guard let response = response as? [String: Any] else { return }
			print(response)
			
			guard let resultArray = response["results"] as? [[String: Any]], resultArray.count > 0  else { return }
			
			guard let movies = Movie.parseListData(resultArray) else { return }

			self.totalPages = response["total_pages"] as? Int ?? 1
			self.movies = movies
			self.tableView.reloadData()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
}

extension MoviesListVC: UITableViewDelegate {
	
}

extension MoviesListVC: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
		
		let movie = self.movies[indexPath.row]
		cell.titleLabel.text = movie.title
		cell.releaseDateLabel.text = ""
		cell.overviewLabel.text = movie.overview
		
		return cell
	}
}
