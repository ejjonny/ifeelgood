//
//  Constants.swift
//  shrinkbot
//
//  Created by Ethan John on 3/5/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

let chillBlue: UIColor = #colorLiteral(red: 0.9126966596, green: 0.9402826428, blue: 0.998428762, alpha: 1)
let deepChillBlue: UIColor = #colorLiteral(red: 0.7379525547, green: 0.8377566145, blue: 0.9988933206, alpha: 1)
let middleChillBlue: UIColor = #colorLiteral(red: 0.8476651309, green: 0.9208347701, blue: 0.9988933206, alpha: 1)
let legendColors = [#colorLiteral(red: 0.7883887887, green: 0.7393109202, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8194651824, blue: 0.894031874, alpha: 1), #colorLiteral(red: 1, green: 0.9575231352, blue: 0.7737829244, alpha: 1), #colorLiteral(red: 0.7617713751, green: 1, blue: 0.8736094954, alpha: 1), #colorLiteral(red: 1, green: 0.6711962363, blue: 0.9908545294, alpha: 1), #colorLiteral(red: 0.7044421855, green: 0.9814820289, blue: 1, alpha: 1)]

enum EntryDateStyles: String {
	case all = "all"
	case day = "day"
	case week = "week"
	case month = "month"
	case year = "year"
}

enum GraphRangeOptions {
	case allTime
	case thisWeek
	case thisMonth
	case thisYear
	case today
}

enum Frequency: Int16 {
	case daily
	case weekly
}

let day = TimeInterval(exactly: 86400)!
let week = TimeInterval(exactly: 604800)!
let month = TimeInterval(exactly: 2629800)!
let year = TimeInterval(exactly: 31557600)!
