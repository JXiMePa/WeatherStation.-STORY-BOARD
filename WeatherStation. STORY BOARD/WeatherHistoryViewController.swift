//
//  ViewController.swift
//  WeatherStation. STORY BOARD
//
//  Created by Tarasenko Jurik on 24.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

final class WeatherHistoryViewController: UIViewController {

    private let baseURL = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/"
    private let cellId = "cellId"
    private let station = ["bradford", "yeovilton", "valley", "wickairport", "waddington", "whitby"]
    private var dataSource: [StationData] = [] {
        didSet {  stationDataTableView.reloadData()  }
    }
    private var sortDataSwitcher = true
    
    @IBOutlet private weak var spiner: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stationLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var stationDataTableView: UITableView!
    @IBOutlet private weak var selectStationPickerView: UIPickerView!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spiner.startAnimating()

        imageView.image = #imageLiteral(resourceName: "Weather")
        selectStationAt(index: 0)
        
        // configure tableView
        stationDataTableView.estimatedRowHeight = 30.0
        stationDataTableView.rowHeight = UITableViewAutomaticDimension
    }
  
    //MARK: sortByYear
    @IBAction private func sortByYearButton(_ sender: UIButton) {
        if sortDataSwitcher {
            dataSource = dataSource.sorted(by: ) {$0.year > $1.year}
            sortDataSwitcher = !sortDataSwitcher
        } else {
            dataSource = dataSource.sorted(by: ) {$0.year < $1.year}
            sortDataSwitcher = !sortDataSwitcher
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            stationDataTableView.reloadData()
        }
    }
    
    @IBAction private func infoShowButton(_ sender: UIButton) {
        infoLabel.isHidden = !infoLabel.isHidden
    }
    
    @IBAction private func toTopButton(_ sender: UIButton) {
        stationDataTableView.setContentOffset(.zero, animated: true)
    }
   
    private func alert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func selectStationAt(index: Int) {
        DataRequest.shared.getStringFromUrl(stringUrl: "\(baseURL)\(station[index])data.txt") { [weak self] error, location, dataSourse in
            guard error == nil else {
                self?.alert(message: "Please check your internet connection and try again.", title: "Error 😓")
                
                return
            }
            
            self?.spiner.stopAnimating()
            guard let dataArray = dataSourse, let locationName = location else { return }
            
            self?.dataSource = dataArray
            self?.locationLabel.text = locationName
            self?.stationDataTableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension WeatherHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? WeatherCell else { return WeatherCell() }
        let currentItem = dataSource[indexPath.item]
        
        cell.setupCellValuesBy(itemData: currentItem)
        
        return cell
    }
}

//MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension WeatherHistoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return station.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        spiner.startAnimating()
        stationLabel.text = station[row].capitalized
        selectStationAt(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: station[row].capitalized, attributes: [ .foregroundColor : #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) ])
    }
}
