//
//  AnamolyDetection.swift
//  AIComponentKit
//
//  Created by Kidus Yohannes on 3/11/24.
//  Copyright © 2024 Massachusetts Institute of Technology. All rights reserved.
//

import Foundation
import UIKit
import Network

struct inputData {
  var x: Double
  var y: Double
  var threshold: Double
}

@objc class AnomalyDetection: NonvisibleComponent {
  func detectAnomalies(dataList: [Double], threshold: Double) -> [(index: Int, value: Double)] {
    
    let mean = dataList.reduce(0, +) / Double(dataList.count)
    let variance = (dataList.reduce(0) { $0 + pow($1 - mean, 2) }) / Double(dataList.count)
    let standardDeviation = sqrt(variance)
    
    var anomalies: [(index: Int, value: Double)] = []
    
    for (index, value) in dataList.enumerated() {
      let zScore = abs((value - mean) / standardDeviation)
      if zScore > threshold {
        anomalies.append((index + 1, value))
      }
    }
    return anomalies
  }
  func detectAnomaliesInChartData(chartData: [inputData], threshold: Double) -> [(Double, Double)] {
    let yValues = chartData.map { $0.y }
    let detectedAnomalies = detectAnomalies(dataList: yValues, threshold: threshold)
    
    var anomalies = detectedAnomalies.map { anomaly in
      let (index, _) = anomaly
      let correspondingEntry = chartData[index - 1]
      return (correspondingEntry.x, correspondingEntry.y)
    }
    return anomalies
  }
  func cleanData(anomalyIndex: Int, xList: [Double], yList: [Double]) -> [(Double, Double)] {
    guard xList.count == yList.count else {
      fatalError("Must have equal X and Y data points")
    }
    
    var xData = xList
    var yData = yList
    
    if anomalyIndex > 0 && anomalyIndex <= xData.count {
      xData.remove(at: anomalyIndex - 1)
      yData.remove(at: anomalyIndex - 1)
    }
    
    return Array(zip(xData, yData))
  }
  
}
extension YailList {
  @objc func toDoubleArray() throws -> [Double] {
        var doubleArray = [Double]()
        for (i, item) in self.enumerated() {
            if let number = item as? Double {
                doubleArray.append(number)
            } else {
                throw ListParseError(index: i)
            }
        }
        return doubleArray
    }
}

struct ListParseError: Error {
    let index: Int
}

@objc extension AnomalyDetection {
    func DetectAnomalies(_ dataList: YailList<AnyObject>, _ threshold: Double) -> YailList<YailList<AnyObject>> {
        do {
            let cleanData = try dataList.toDoubleArray()
            let anomalies = detectAnomalies(dataList: cleanData, threshold: threshold)
            return YailList(anomalies.map { YailList([$0.index as AnyObject, $0.value as AnyObject]) })
        } catch {
            if let error = error as? ListParseError {
                let index = error.index
            }
            return YailList()
        }
    }
}

