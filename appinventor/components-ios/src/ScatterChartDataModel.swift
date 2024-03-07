//
//  ScatterChartDataModel.swift
//  AIComponentKit
//
//  Created by David Kim on 3/6/24.
//  Copyright © 2024 Massachusetts Institute of Technology. All rights reserved.
//

import Foundation
import DGCharts

class ScatterChartDataModel: PointChartDataModel {
  var chartDataEntry: Array<ChartDataEntry> = []

  init(data: DGCharts.ScatterChartData, view: ScatterChartView) {
    super.init(data: data, view: view)
    let dataset = ScatterChartDataSet(entries: chartDataEntry, label: " ")
    self.dataset = dataset
    self.data.dataSets = [dataset]
    setDefaultStylingProperties()
  }

  public override func addEntryFromTuple(_ tuple: YailList<AnyObject>) {
    // Assuming getEntryFromTuple is a function that returns an optional ChartDataEntry.
    // The tuple parameter type adjusted for Swift.
    guard let entry = getEntryFromTuple(tuple) else {
      // Not a valid entry
      return
    }
    // Assuming a correctly implemented binarySearch function that returns the index
    // where the entry should be inserted or the negative index - 1 if not found.
    var index = binarySearch(entry, entries)
    if index < 0 {
      index = -(index + 1)
    } else {
      let entryCount = entries.count
      while index < entryCount && entries[index].x == entry.x  {
        index += 1
      }
    }

    // Insert the entry into the entries array.
    _entries.insert(entry, at: index)

    // Assuming you're updating some dataset that needs to be replaced entirely.
    // Performing UI updates asynchronously on the main thread.
    DispatchQueue.main.async {
      self.dataset?.replaceEntries(self._entries)
    }
  }

  public override func setDefaultStylingProperties() {
    guard let scatterDataSet = dataset as? DGCharts.ScatterChartDataSet else {
      return
    }
    scatterDataSet.setScatterShape(.circle)
  }


  public func setPointShape(_ shape: PointShape) {
    guard let scatterDataSet = dataset as? DGCharts.ScatterChartDataSet else {
      return
    }
    switch shape {
    case PointShape.Circle:
      scatterDataSet.setScatterShape(.circle)
      break
    case PointShape.Square:
      scatterDataSet.setScatterShape(.square)
      break
    case PointShape.Triangle:
      scatterDataSet.setScatterShape(.triangle)
      break
    case PointShape.Cross:
      scatterDataSet.setScatterShape(.cross)
      break
    case PointShape.X:
      scatterDataSet.setScatterShape(.x)
      break
    }
  }

}

