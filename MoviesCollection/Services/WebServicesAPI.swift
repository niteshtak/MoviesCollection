//
//  WebServicesAPI.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = (_ response: Any?, _ error: ErrorResponse?) -> Void

class WebServiceAPI: Any {
	
	static let sharedInstance = WebServiceAPI()
	
	
	func getData(_ path: String, parameters: [String: Any]?, completion: @escaping CompletionHandler) {
		
		Alamofire.request(URL(string: path)!, method: .get, parameters: parameters, encoding: JSONEncoding.init(options: []), headers: nil)
			.responseJSON { (response) in
			
				guard let httpResponse = response.response else {
					let error = ErrorResponse(message: "Can't fetch data, Please try again later!", code: "503")
					completion(nil, error)
					return
				}
				
				let statusCode = Int(httpResponse.statusCode)
				
				let json = response.result.value as? [String: Any]
				switch statusCode {
				case (200...300):
					guard let value = json else {
						print("No data available!")
						let error = ErrorResponse(message: "No Data Available", code: "200")
						completion(nil, error)
						return
					}
					completion(value, nil)
					break
					
				case 403:
					guard let value = json,
						let message = value["message"] else {
							print("No data available!")
							let error = ErrorResponse(message: "Session expired, please logout and login again!", code: "200")
							completion(nil, error)
							return }
					let error = ErrorResponse(message: message as! String, code: "403")
					completion(nil, error)
					break
					
				case (400...499):
					guard let value = json,
						let message = value["message"], let code = value["code"] else {
							print("No data available!")
							let error = ErrorResponse(message: "No Data Available", code: "200")
							completion(nil, error)
							return }
					let error = ErrorResponse(message: message as! String, code: code as! String)
					completion(nil, error)
					break
					
				case 500:
					print("Internal server error")
					let error = ErrorResponse(message: "Internal server error", code: "500")
					completion(nil, error)
					break
					
				default:
					print("Internet connection error")
					let error = ErrorResponse(message: "Please check your internet connection", code: "500")
					completion(nil, error)
				}
		}
	}
	
}
