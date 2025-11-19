//
//  LimitAction.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/19/25.
//

import Foundation
import SwiftUI

enum LimitAction: Int, Codable {
    case nothing = 0
    case liquidate = 1
    case block = 2
}
