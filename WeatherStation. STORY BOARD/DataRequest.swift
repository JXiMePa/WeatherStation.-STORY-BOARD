//
//  DataRequest.swift
//  WeatherStation. STORY BOARD
//
//  Created by Tarasenko Jurik on 24.05.2018.
//  Copyright © 2018 Tarasenko Jurik. All rights reserved.
//

import UIKit

struct StationData: CustomStringConvertible {
    var description: String {
        return "\(year), \(month), \(tmax), \(tmin), \(afDays), \(rein), \(sunHours)" }
    
    let year: String
    let month: String
    let tmax: String
    let tmin: String
    let afDays: String
    let rein: String
    let sunHours: String
}

final class DataRequest {
    
    static let shared = DataRequest()
    private init() {}
    
    func getStringFromUrl(stringUrl: String, completion: @escaping (Error?, String?, [StationData]?) -> ()) {
        var allStationData = [StationData]()
        
        if let url = URL(string: stringUrl) {
            URLSession.shared.dataTask(with: url) { (data, response , error) in
                DispatchQueue.main.async {
                    guard error == nil else {
                        completion(error, nil, nil)
                        return
                    }
                    guard let data = data else { return }
                    guard let stringFromData = String(data: data, encoding: .utf8) else { return }
                    
                    let separatedByNewLine = stringFromData.components(separatedBy: "\n")
                    var location = separatedByNewLine[1]
                    
                    if !separatedByNewLine[2].hasPrefix("Estimated") {
                        location += separatedByNewLine[2]
                    }
                    for value in separatedByNewLine {
                        if let data = self.tryToGetDataFrom(value: value) {
                            allStationData.append(data)
                        }
                    }
                    completion(nil, location, allStationData)
                }
            }.resume()
        }
    }
    
    private func tryToGetDataFrom(value: String) -> StationData? {
        var clearData = [String]()
        let count = 7
        if value.hasPrefix("   1") || value.hasPrefix("   2") {
            
            let separatedByElement = value.components(separatedBy: "  ")
            for element in separatedByElement {
                
                if element != "" {
                    clearData.append(element)
                }
            }
            
            if clearData.count < count {
                for _ in 0...(count - clearData.count) {
                    clearData.append("---")
                }
            }
            
            let oneData = StationData(year: clearData[0], month: clearData[1], tmax: clearData[2], tmin: clearData[3], afDays: clearData[4], rein: clearData[5], sunHours: clearData[6])
            return oneData
        }
        return nil
    }
}

