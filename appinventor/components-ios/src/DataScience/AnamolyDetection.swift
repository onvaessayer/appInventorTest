//
//  AnamolyDetection.swift
//  AIComponentKit
//
//  Created by Kidus Yohannes on 3/11/24.
//  Copyright © 2024 Massachusetts Institute of Technology. All rights reserved.
//

import Foundation
import UIKit

struct InputData {
    var x: Double
    var y: Double
    var threshold: Double
}

class AnomalyDetection {

    private func statistics(for dataList: [Double]) -> (mean: Double, standardDeviation: Double) {
        let mean = dataList.reduce(0, +) / Double(dataList.count)
        let variance = dataList.reduce(0) { $0 + pow($1 - mean, 2) } / Double(dataList.count)
        let standardDeviation = sqrt(variance)
        return (mean, standardDeviation)
    }
    
    func detectAnomalies(dataList: [Double], threshold: Double) -> [(index: Int, value: Double)] {
        let (mean, sd) = statistics(for: dataList)
        return dataList.enumerated().compactMap { index, value in
            let zScore = abs((value - mean) / sd)
            return zScore > threshold ? (index + 1, value) : nil
        }
    }
    
    func detectAnomaliesInChartData(chartData: [InputData], threshold: Double) -> [(Double, Double)] {
        let yValues = chartData.map { $0.y }
        let anomalies = detectAnomalies(dataList: yValues, threshold: threshold)
        return anomalies.map { (chartData[$0.index - 1].x, $0.value) }
    }
    
    func cleanData(anomalyIndex: Int, xList: [Double], yList: [Double]) -> [(Double, Double)] {
        guard xList.count == yList.count, anomalyIndex > 0, anomalyIndex <= xList.count else {
            fatalError("Invalid input data")
        }
        var newXList = xList
        var newYList = yList
        newXList.remove(at: anomalyIndex - 1)
        newYList.remove(at: anomalyIndex - 1)
        return Array(zip(newXList, newYList))
    }

    func exampleUsage() {
        let data = InputData(x: 1.0, y: 2.0, threshold: 0.5)
        let anomalies = detectAnomaliesInChartData(chartData: [data], threshold: data.threshold)
        print("Detected anomalies: \(anomalies)")
    }
}


//@objc extension AnomalyDetection {
//    func DetectAnomalies(_ dataList: YailList<AnyObject>, _ threshold: Double) -> YailList<YailList<AnyObject>> {
//        do {
//            let cleanData = try dataList.toDoubleArray()
//            let anomalies = detectAnomalies(dataList: cleanData, threshold: threshold)
//            return YailList(anomalies.map { YailList([$0.index as AnyObject, $0.value as AnyObject]) })
//        } catch {
//            if let error = error as? ListParseError {
//                let index = error.index
//            }
//            return YailList()
//        }
//    }
//}

