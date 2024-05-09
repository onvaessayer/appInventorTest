//
//  LinearRegression.swift
//  AIComponentKit
//
//  Created by Kidus Yohannes on 4/22/24.
//  Copyright © 2024 Massachusetts Institute of Technology. All rights reserved.
//

import Foundation
import UIKit
import Network

struct LinearInputData {
    var x: Double
    var y: Double
}

class LinearRegression {

    private func computeCoefficients(xList: [Double], yList: [Double]) -> (slope: Double, intercept: Double, correlationCoefficient: Double) {
        // Dummy calculation for illustration
        let slope = 0.0
        let intercept = 0.0
        let correlationCoefficient = 0.0
        return (slope, intercept, correlationCoefficient)
    }
    
    private func calculatePredictions(xList: [Double], slope: Double, intercept: Double) -> [Double] {
        return xList.map { intercept + slope * $0 }
    }

    func calculateLineOfBestFit(inputData: [LinearInputData]) -> [String: Any] {
        let xList = inputData.map { $0.x }
        let yList = inputData.map { $0.y }
        let (slope, intercept, correlationCoefficient) = computeCoefficients(xList: xList, yList: yList)
        let predictions = calculatePredictions(xList: xList, slope: slope, intercept: intercept)
        return [
            "slope": slope,
            "intercept": intercept,
            "correlationCoefficient": correlationCoefficient,
            "predictions": predictions
        ]
    }
    
    func exampleUsage() {
        let data = [LinearInputData(x: 1.0, y: 2.0), LinearInputData(x: 2.0, y: 4.0)]
        let lineOfBestFitValues = calculateLineOfBestFit(inputData: data)
        print("Line of Best Fit Values: \(lineOfBestFitValues)")
    }
}
