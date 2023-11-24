//
//  ParameterDisplayConversion.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 20/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import Foundation
import CoreAudioKit

protocol ParameterDisplayConversionType {

  var parameter: AUParameter { get }
  var displayMinValue: AUValue { get }
  var displayMaxValue: AUValue { get }

  func fromDisplay(_ value: AUValue) -> AUValue
  func toDisplay(_ value: AUValue) -> AUValue
}

extension ParameterDisplayConversionType {
  var displayMinValue: AUValue { toDisplay(parameter.minValue) }
  var displayMaxValue: AUValue { toDisplay(parameter.maxValue) }
}

struct ParameterDisplayConversions {

  static func displayConversion(parameter: AUParameter) -> ParameterDisplayConversionType {

    let flags = parameter.flags

    if (flags.contains(.flag_DisplayLogarithmic)) {
      return ParameterDisplayConversions.Logarithmic(parameter: parameter)
    } else if (flags.contains(.flag_DisplayExponential)) {
      return ParameterDisplayConversions.Exponential(parameter: parameter)
    } else if (flags.contains(.flag_DisplaySquared)) {
      return ParameterDisplayConversions.Squared(parameter: parameter)
    } else if (flags.contains(.flag_DisplaySquareRoot)) {
      return ParameterDisplayConversions.SquareRoot(parameter: parameter)
    } else if (flags.contains(.flag_DisplayCubed)) {
      return ParameterDisplayConversions.Cubed(parameter: parameter)
    } else if (flags.contains(.flag_DisplayCubeRoot)) {
      return ParameterDisplayConversions.CubeRoot(parameter: parameter)
    }

    return Identity(parameter: parameter)
  }

  struct Identity: ParameterDisplayConversionType {
    var parameter: AUParameter
    var displayMinValue: AUValue
    var displayMaxValue: AUValue

    func fromDisplay(_ value: AUValue) -> AUValue { value }
    func toDisplay(_ value: AUValue) -> AUValue { value }

    init(parameter: AUParameter) {

      self.parameter = parameter
      displayMinValue = parameter.minValue
      displayMaxValue = parameter.maxValue
    }
  }

  struct Logarithmic: ParameterDisplayConversionType {
    var scale: AUValue = 100
    var parameter: AUParameter

    func fromDisplay(_ value: AUValue) -> AUValue {
      let minValue = parameter.minValue
      let range = parameter.maxValue - minValue

      let absValue = pow(10, value) - 1.0

      return ((absValue / scale) * range) + minValue
    }

    func toDisplay(_ value: AUValue) -> AUValue {

      let minValue = parameter.minValue
      let range = parameter.maxValue - minValue

      let scaledValue = (((value - minValue) / range) * scale + 1.0)
      let displayValue = log10(scaledValue)

      return displayValue
    }

    init(parameter: AUParameter) {
      self.parameter = parameter
    }
  }

  struct Exponential: ParameterDisplayConversionType {

    func fromDisplay(_ value: AUValue) -> AUValue {
      let minValue = parameter.minValue
      let range = parameter.maxValue - minValue

      let scaledValue = (value - minValue) / range + 1.0
      let displayValue = log2(scaledValue)

      return displayValue
    }

    func toDisplay(_ value: AUValue) -> AUValue {

      let minValue = parameter.minValue
      let range = parameter.maxValue - minValue

      let absValue = pow(2, value) - 1.0

      return (absValue * range) + minValue
    }

    var parameter: AUParameter

    init(parameter: AUParameter) {
      self.parameter = parameter
    }
  }

  struct SquareRoot: ParameterDisplayConversionType {
    var parameter: AUParameter

    func fromDisplay(_ value: AUValue) -> AUValue { pow(value, 2.0) }
    func toDisplay(_ value: AUValue) -> AUValue { sqrt(value) }

    init(parameter: AUParameter) {
      self.parameter = parameter
    }
  }

  struct Squared: ParameterDisplayConversionType {
    var parameter: AUParameter

    func fromDisplay(_ value: AUValue) -> AUValue { sqrt(value) }
    func toDisplay(_ value: AUValue) -> AUValue { pow(value, 2.0) }

    init(parameter: AUParameter) {
      self.parameter = parameter
    }
  }

  struct Cubed: ParameterDisplayConversionType {
    var parameter: AUParameter

    func fromDisplay(_ value: AUValue) -> AUValue { cbrt(value) }
    func toDisplay(_ value: AUValue) -> AUValue { pow(value, 3.0) }

    init(parameter: AUParameter) {
      self.parameter = parameter
    }
  }

  struct CubeRoot: ParameterDisplayConversionType {
    var parameter: AUParameter

    func fromDisplay(_ value: AUValue) -> AUValue { pow(value, 3.0) }
    func toDisplay(_ value: AUValue) -> AUValue { cbrt(value) }

    init(parameter: AUParameter) {
      self.parameter = parameter
    }
  }
}
