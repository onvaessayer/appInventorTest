// -*- mode: swift; swift-mode:basic-offset: 2; -*-
// Copyright © 2022 Massachusetts Institute of Technology, All rights reserved.

import Foundation
import DGCharts

@objc class ChartData2D: ChartDataBase {
  
  override init(_ chartContainer: Chart) {
    super.init(chartContainer)
    chartContainer.addDataComponent(self)
    dataFileColumns = [" ", " "]
    sheetColumns = [" ", " "]
    webColumns = [" ", " "]
  }
  
  @objc func AddEntry(_ x: String, _ y: String){
    // create a 2-tuple, and add the tuple to the Data series
    DispatchQueue.main.async {
      let pair: YailList<AnyObject> = [x, y]
      self._chartDataModel?.addEntryFromTuple(pair)
      // refresh chart with new data
      self.refreshChart()
    }
  }
  
  @objc func RemoveEntry(_ x: String, _ y: String){
    // create a 2-tuple, and remove the tuple from the Data series
    DispatchQueue.main.async {
      let pair: YailList<AnyObject> = [x, y]
      self._chartDataModel?.removeEntryFromTuple(pair)
      // refresh chart with new data
      self.refreshChart()
    }
  }
  
  // checks whether an (x, y) entry exists in the Coordinate Data. Returns true if the Entry exists, and false otherwise.
  @objc func DoesEntryExist(_ x: String, _ y: String) -> Bool{
    /* Original:
     DispatchQueue.main.sync {
      var pair: YailList<AnyObject> = [x, y]
      return self._chartDataModel!.doesEntryExist(pair) // TODO: is the ! okay?
    }*/
    
    let group = DispatchGroup()
    group.enter()
    var holder: Bool = false // holder variable for returned value of doesEntryExist()
    // avoid deadlocks by not using .main queue here
    DispatchQueue.global(qos: .default).async {
      var pair: YailList<AnyObject> = [x, y]
      holder =  self._chartDataModel!.doesEntryExist(pair)
      print("holder", holder)
      group.leave()
    }
    group.wait()
    return holder
  }
  
  // Highlights data points of choice on the Chart in the color of choice. This block expects a list of data points, each data pointis an index, value pair
  @objc func HighlightDataPoints(_ dataPoints: YailList<AnyObject>, _ color: Int) {
    let dataPointsList: Array<AnyObject> = dataPoints as! Array
    print("dataPointsList", dataPointsList)
    if !dataPoints.isEmpty {
      let entries = _chartDataModel?.entries
      var highlights: Array<Int> = []
      // populate highlights with the corresponding int color to each entries
      for _ in 0 ..< entries!.count {
        // let lineDataSet: LineChartDataSet = _chartDataModel?.dataset as! LineChartDataSet
        print("_colors", _colors)
        print("type", type(of: _colors))
        highlights = _colors as! Array<Int>
        // is _colors = getDataSet.getColor()
      }
      print("highlights", highlights)
      for dataPoint in dataPointsList {
        if let dataPoint = dataPoint as? YailList<AnyObject> {
          print("dataPoint", dataPoint)
          print("type dataPoint", type(of: dataPoint[0]))
          var dataPointInt: Array<Int> = []
          for point in dataPoint {
            print("point", point)
            print("typepoint", type(of: point))
            dataPointInt.append(point as! Int)
          }
          let dataPointIndex: Int = dataPoint[0] as! Int  // anomaly detection replacement
          print("dataPointIndex", dataPointIndex)
          highlights[dataPointIndex - 1] = color
        }
      }
      print("did i make it here")
      print("highlights", highlights)
      let lineDataSet: LineChartDataSet = _chartDataModel?.dataset as! LineChartDataSet
      var highlightsUI: Array<NSUIColor> = []
      for highlight in highlights {
        highlightsUI.append(argbToColor(Int32(highlight)))
      }
      print("highlightsUI", highlightsUI)
      lineDataSet.circleColors = highlightsUI
      onDataChange()
    }
  }
}
