//
//  Movie.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import Foundation

class Movie : CustomDebugStringConvertible {
	
	var title: String! = nil
	var posterPath: String! = nil
	var backdropPath: String! = nil
	var id: Int!
	var genereIds: [Int] = []
	var genres: [[String: Any]]?
	var overview: String! = nil
	var popularity: Float?
	var voteAverage: Float?
	var synopsis: String! = nil
	var runtime: Int?
	var spokenLanguages: [[String: Any]]?
	var originalLanguage: String
	
	var debugDescription: String {
		return title
	}
	
	init?(response: AnyObject) {
		id = response.object(forKey: Constants.MovieKeys.id) as! Int
		title = response.object(forKey: Constants.MovieKeys.title) as? String ?? ""
		overview = response.object(forKey: Constants.MovieKeys.overview) as? String ?? ""
		posterPath = response.object(forKey: Constants.MovieKeys.posterPath) as? String ?? ""
		backdropPath = response.object(forKey: Constants.MovieKeys.backdropPath) as? String ?? ""
		popularity = response.object(forKey: Constants.MovieKeys.popularity) as? Float ?? 0.0
		voteAverage = response.object(forKey: Constants.MovieKeys.voteAverage) as? Float ?? 0
		synopsis = response.object(forKey: Constants.MovieKeys.synopsis) as? String ?? ""
		runtime = response.object(forKey: Constants.MovieKeys.runtime) as? Int ?? 0
		genres = response.object(forKey: Constants.ServerKey.genres) as? [[String: Any]]
		spokenLanguages = response.object(forKey: Constants.MovieKeys.spokenLanguages) as? [[String: Any]]
		originalLanguage = response.object(forKey: Constants.MovieKeys.originalLanguage) as? String ?? ""
		
		if let genereids = response.object(forKey: Constants.MovieKeys.genreIds) as? [Int] {
			genereIds = genereids
		}
	}
	
	static func parseListData(_ dictionaries: [[String: Any]]?) -> [Movie]? {
		
		guard let dictionaries = dictionaries else { return nil }
		
		var itemList = [Movie]()
		for dictionary in dictionaries {
			if let item = Movie(response: dictionary as AnyObject) {
				itemList.append(item)
			}
		}
		return itemList
	}
	
	var thumbnailURL: URL? {
		return URL(string:  Constants.imageUrlPrefix + "w92" + posterPath)
	}
	
	var backdropURL: URL? {
		let path = !backdropPath.isEmpty ? backdropPath : posterPath
		guard !(path?.isEmpty)! else {
			return nil
		}
		return URL(string:  Constants.imageUrlPrefix + "w780" + path!)
	}
}
