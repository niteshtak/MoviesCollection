//
//  AppFonts.swift
//  MoviesCollection
//
//  Created by Nitesh Tak on 7/8/18.
//  Copyright © 2018 nitesh. All rights reserved.
//

import Foundation
import UIKit

struct AppFonts {
	
	static let headerTitle: [NSAttributedStringKey: Any] = [
		NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): defaultRegularFontWithSize(size: 18),
		NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white
	]
	
	static func defaultRegularFontWithSize(size: CGFloat) -> UIFont {
		return UIFont(name: "Avenir-Book", size: size)!
	}
	
	static func defaultMediumFontWithSize(size: CGFloat) -> UIFont {
		return UIFont(name: "Avenir-Medium", size: size)!
	}
	
	static func defaultSemiBoldFontWithSize(size: CGFloat) -> UIFont {
		return UIFont(name: "AvenirNext-DemiBold", size: size)!
	}
	
	static func defaultBoldFontWithSize(size: CGFloat) -> UIFont {
		return UIFont(name: "AvenirNext-Bold", size: size)!
	}
	
	public static let whisper = UIFont(name: "Avenir-Book", size: 13)!
}
