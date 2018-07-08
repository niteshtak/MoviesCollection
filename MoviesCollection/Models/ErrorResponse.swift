//
//  ErrorResponse.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import Foundation

struct ErrorResponse {
	
	var message : String! = nil
	var code    : String! = nil
	
	init() { }
	
	init?(message: String, code: String) {
		self.message = message
		self.code    = code
	}
	
	static func parseErrorData(_ dictionary: [String: Any]) -> ErrorResponse? {
		
		let message  = dictionary["message"] as? String ?? ""
		let code     = dictionary["code"] as? String ?? ""
		
		guard let error = ErrorResponse(message: message,
										code: code) else { return nil }
		
		return error
	}
}
