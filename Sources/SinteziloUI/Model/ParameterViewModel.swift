//
//  ParameterViewModel.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 17/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import Foundation
import CoreAudioKit

public class ParameterViewModel: ObservableObject, Identifiable, Hashable {

  public static func == (lhs: ParameterViewModel, rhs: ParameterViewModel) -> Bool {
    lhs.parameter.identifier == rhs.parameter.identifier
  }

  public func hash(into hasher: inout Hasher) {
    return hasher.combine(parameter.identifier)
  }

  enum EditingState {

    case inactive
    case began
    case active
    case ended
    case hostUpdate
  }

  struct PickerValue: Identifiable, Equatable {

    var id: UUID = UUID()
    var stringValue: String
    var parameterValue: AUValue
  }

  struct PointOfInterest: Identifiable {

    var id: UUID = UUID()
    var title: String
    var value: AUValue
    var displayValue: AUValue
  }

  /// The address of the uderlying ``AUParameter``.
  public var id: UInt64 { parameter.address }

  var parameter: AUParameter
  var observerToken: AUParameterObserverToken?
  var editingState: EditingState = .inactive

  var title: String
  var minValue: AUValue { displayConversion.displayMinValue }
  var maxValue: AUValue { displayConversion.displayMaxValue }
  var range: AUValue { maxValue - minValue }
  var pointsOfInterest: [PointOfInterest]
  var displayConversion: ParameterDisplayConversionType

  /// The current value of the parameter.
  @Published public var currentValue: AUValue {
    willSet {
      guard editingState != .hostUpdate else { return }

      let convertedValue = displayConversion.fromDisplay(newValue)
      let automationEventType = resolveEventType()

      if let observerToken {
        parameter.setValue(convertedValue,
                           originator: observerToken,
                           atHostTime: 0,
                           eventType: automationEventType)
      } else {
        parameter.value = convertedValue
      }
    }
  }

  var formattedCurrentValue: String {

    ParameterFormatter.formatParameterValue(value: displayConversion.fromDisplay(currentValue), parameter: parameter)
  }

  static func getPickerValues(parameter: AUParameter) -> [PickerValue] {

    parameter.valueStrings?.map({ stringValue in

      PickerValue(id: UUID(),
                  stringValue: stringValue,
                  parameterValue: parameter.value(from: stringValue))
    }) ?? []
  }

  let pickerValues: [PickerValue]
  
  var pickerIndex: Int {
    
    pickerValues.isEmpty ?
    Int(currentValue) :
    pickerValues.firstIndex(where: { $0.parameterValue == currentValue }) ?? 0
  }

  /// Initialise a view model with the supplied parameter, and optionally
  /// a list of values considered "points of interest" for scale marking.
  /// - Parameters:
  ///   - parameter: the parameter.
  ///   - pointsOfInterest: points of interest, in the units of the parameter.
  public init(parameter: AUParameter, pointsOfInterest: [AUValue]? = nil) {

    self.parameter = parameter

    let displayConversion = ParameterDisplayConversions.displayConversion(parameter: parameter)
    self.displayConversion = displayConversion

    title = parameter.displayName
    currentValue = displayConversion.toDisplay(parameter.value)

    let mapPointsOfInterest: (AUValue) -> PointOfInterest = {
      PointOfInterest(title: ParameterFormatter.formatParameterValue(value: $0, parameter: parameter),
                      value: $0,
                      displayValue: displayConversion.toDisplay($0))
    }

    let defaultPointsOfInterest: (AUParameter) -> [AUValue] = { parameter in
      var pointsOfInterest: [AUValue] = [parameter.minValue]
      if parameter.minValue < 0 && parameter.maxValue > 0 {
        pointsOfInterest.append(0.0)
      }
      pointsOfInterest.append(parameter.maxValue)
      return pointsOfInterest
    }

    if parameter.flags.contains(.flag_ValuesHaveStrings) {
      let pickerValues = ParameterViewModel.getPickerValues(parameter: parameter)
      self.pickerValues = pickerValues
      self.pointsOfInterest = pickerValues.map { value in
        PointOfInterest(title: value.stringValue, value: value.parameterValue, displayValue: value.parameterValue)
      }
    } else {
      pickerValues = []
      let pointsOfInterest = pointsOfInterest ?? defaultPointsOfInterest(parameter)
      self.pointsOfInterest = pointsOfInterest.map(mapPointsOfInterest)
    }

    self.observerToken = parameter.token { [weak self] (_ address: AUParameterAddress, _ auValue: AUValue) in

      guard address == self?.parameter.address else { return }

      DispatchQueue.main.async {
        guard let self,
          self.editingState == .inactive else { return }

        self.editingState = .hostUpdate
        let displayValue = displayConversion.toDisplay(auValue)
        self.currentValue = displayValue
        self.editingState = .inactive
      }
    }
  }

  func onEditingChanged(_ editing: Bool) {
    if editing {
      editingState = .began
    } else {
      editingState = .ended
      currentValue = currentValue
    }
  }

  private func resolveEventType() -> AUParameterAutomationEventType {

    let eventType: AUParameterAutomationEventType

    switch editingState {
    case .began:
      eventType = .touch
      editingState = .active
    case .ended:
      eventType = .release
      editingState = .inactive
    default:
      eventType = .value
    }

    return eventType
  }
}
