//
//  UIImageView+Download.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import UIKit

extension UIImageView {
	
	func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) -> URLSessionDataTask {
		contentMode = mode
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
		}
		
		task.resume()
		
		return task
	}
	
	func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) -> URLSessionDataTask? {
		guard let url = URL(string: link) else { return nil }
		
		return downloadedFrom(url: url, contentMode: mode)
	}
}

