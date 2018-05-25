//
//  WeatherCellViewController.swift
//  WeatherStation. STORY BOARD
//
//  Created by Tarasenko Jurik on 24.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class WeatherCell: UITableViewCell {

    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var tmaxLabel: UILabel!
    @IBOutlet private weak var tminLabel: UILabel!
    @IBOutlet private weak var afDaysLabel: UILabel!
    @IBOutlet private weak var rainLabel: UILabel!
    @IBOutlet private weak var sunLabel: UILabel!

    func setupCellValuesBy(itemData: StationData) {
        yearLabel.text = itemData.year
        monthLabel.text = itemData.month
        tmaxLabel.text = itemData.tmax
        tminLabel.text = itemData.tmin
        afDaysLabel.text = itemData.afDays
        rainLabel.text = itemData.rein
        sunLabel.text = itemData.sunHours
    }
}
