//
//  Constants.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import Foundation

enum MovieDetailSection: String {
	case Overview = "Overview"
	case Title = "Title"
	case Synopsis = "Synopsis"
	case Genres = "Genres"
	case Duration = "Running Time"
	case Language = "Language"
}

enum MoviesError: Error {
	case EmptyResponse
	case InvalidResponse
}

public struct Constants {
	
	public static let APIKey = "328c283cd27bd1877d9080ccb1604c91"
	public static let APIUrlPrefix = "https://api.themoviedb.org/3/"
	
	public static let imageUrlPrefix = "https://image.tmdb.org/t/p/"
	public static let releaseDatePath = "discover/movie?sort_by=release_date.desc"
	public static let moviePath = "movie/"
	public static let searchPath = "search/movie?api_key="
	
	static var byReleaseDate: String {
		return APIUrlPrefix + releaseDatePath
	}
	
	static var movieDetailPath: String {
		return APIUrlPrefix + moviePath
	}
	
	static var movieSearchPath: String {
		return APIUrlPrefix + searchPath + APIKey
	}
	
	public struct ServerKey {
		static let results = "results"
		static let totalPages = "total_pages"
		static let page = "page"
		static let genres = "genres"
		static let name = "name"
		static let id = "id"
		
	}
	
	struct MovieKeys {
		static let id = "id"
		static let title = "title"
		static let posterPath = "poster_path"
		static let backdropPath = "backdrop_path"
		static let genreIds = "genre_ids"
		static let overview = "overview"
		static let popularity = "popularity"
		static let voteAverage = "vote_average"
		static let synopsis = "synopsis"
		static let runtime = "runtime"
		static let spokenLanguages = "spoken_languages"
		static let originalLanguage = "origianl_language"
		static let releaseDate = "release_date"
	}
}
