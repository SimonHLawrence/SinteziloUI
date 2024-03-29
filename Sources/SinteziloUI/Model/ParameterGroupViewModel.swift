//
//  ParameterGroupViewModel.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 17/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import Foundation
import CoreAudioKit

/// View model representing a named group of parameters.
public class ParameterGroupViewModel: ObservableObject, Identifiable, Hashable {

  /// The display type for the group.
  public enum DisplayType: Int {
    // Shown inline with other controls
    case inline
    // Shown as a button toggling a popover
    case popover
  }

  var identifier = UUID()
  var title: String
  var parameters: [ParameterViewModel]
  public let displayType: DisplayType

  public static func == (lhs: ParameterGroupViewModel, rhs: ParameterGroupViewModel) -> Bool {
    lhs.identifier == rhs.identifier
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  /// Convenience initializer that will first create an array of ``ParameterViewModel`` instances
  /// and then initialize the view model with those.
  /// - Parameters:
  ///   - name: the name of the parameter group.
  ///   - parameters: an array of parameters for the group.
  ///   - pointsOfInterest: a dictionary associating parameter addresses with any associated points of interest for scale marking.
  public convenience init(name: String, parameters: [AUParameter], displayType: DisplayType = .inline, pointsOfInterest: [AUParameterAddress: [AUValue]] = [:]) {

    let mappedParameters = parameters.map { ParameterViewModel(parameter: $0, pointsOfInterest: pointsOfInterest[$0.address]) }
    self.init(name: name, displayType: displayType, parameters: mappedParameters)
  }

  /// Initializer that will create a group view model for the supplied parameter view models.
  /// - Parameters:
  ///   - name: the name of the parameter group.
  ///   - parameters: an array of parameter view models for the group.
  public init(name: String, displayType: DisplayType = .inline, parameters: [ParameterViewModel]) {

    self.title = name
    self.parameters = parameters
    self.displayType = displayType
  }
}

