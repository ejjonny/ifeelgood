//
//  Constants.swift
//  ifeelgood
//
//  Created by Ethan John on 3/5/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

let chillBlue: UIColor = #colorLiteral(red: 0.9126966596, green: 0.9402826428, blue: 0.998428762, alpha: 1)
let deepChillBlue: UIColor = #colorLiteral(red: 0.7379525547, green: 0.8377566145, blue: 0.9988933206, alpha: 1)
let middleChillBlue: UIColor = #colorLiteral(red: 0.8030086875, green: 0.8979549423, blue: 0.9988933206, alpha: 1)

enum EntryDateStyles {
	case all
	case day
	case week
	case month
	case year
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
