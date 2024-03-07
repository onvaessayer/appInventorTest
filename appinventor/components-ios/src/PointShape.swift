//
//  PointShape.swift
//  AIComponentKit
//
//  Created by David Kim on 3/6/24.
//  Copyright © 2024 Massachusetts Institute of Technology. All rights reserved.
//

import Foundation

public enum PointShape: Int32, CaseIterable {
  case Circle = 0
  case Square = 1
  case Triangle = 2
  case Cross = 3
  case X = 4

  static var LOOKUP : [Int32 : PointShape] {
    var table: [Int32 : PointShape] = [:]
    for val in PointShape.allCases {
      table[val.rawValue] = val
    }
    return table
  }
}
