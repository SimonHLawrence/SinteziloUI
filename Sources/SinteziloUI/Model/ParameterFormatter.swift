//
//  ParameterFormatter.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 22/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import Foundation
import CoreAudioKit

struct ParameterFormatter {

  private static var measurementFormatter: MeasurementFormatter = {
    let result = MeasurementFormatter()
    result.unitStyle = .short
    result.unitOptions = .naturalScale
    return result
  }()

  private static var millisecondFormatter: MeasurementFormatter = {
    let result = MeasurementFormatter()
    result.unitStyle = .short
    result.unitOptions = .providedUnit
    result.numberFormatter.maximumFractionDigits = 0
    return result
  }()

  private static var secondFormatter: MeasurementFormatter = {
    let result = MeasurementFormatter()
    result.unitStyle = .short
    result.unitOptions = .naturalScale
    result.numberFormatter.maximumFractionDigits = 2
    return result
  }()

  private static var percentageFormatter: NumberFormatter = {
    let result = NumberFormatter()
    result.numberStyle = .percent
    result.maximumFractionDigits = 0
    return result
  }()

  private static var genericFormatter: NumberFormatter = {
    let result = NumberFormatter()
    result.maximumFractionDigits = 2
    return result
  }()

  static func formatParameterValue(value: AUValue, parameter: AUParameter) -> String {

    switch parameter.unit {

    case .percent:
      let percentValue = NSNumber(value: (value / parameter.maxValue))
      return percentageFormatter.string(from: percentValue) ?? ""

    case .hertz:
      let frequencyValue = Measurement(value: abs(Double(value)), unit: UnitFrequency.hertz)
      let formattedValue = measurementFormatter.string(from: frequencyValue)
      if (value < 0) {
        return "-\(formattedValue)"
      }
      return formattedValue

    case .milliseconds:
      let timeInterval = Measurement(value: Double(value), unit: UnitDuration.milliseconds)
      if value >= 1000 {
        return secondFormatter.string(from: timeInterval)
      }
      return millisecondFormatter.string(from: timeInterval)

    case .seconds:
      let timeInterval = Measurement(value: Double(value) * 1000, unit: UnitDuration.milliseconds)
      if value >= 1 {
        return secondFormatter.string(from: timeInterval)
      }
      return millisecondFormatter.string(from: timeInterval)

    case .BPM:
      let valueString = genericFormatter.string(from: NSNumber(value: value)) ?? "0"
      return "\(valueString) BPM"

    case .midiNoteNumber:
      let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
      let noteNumber = Int(value)
      let note = noteNumber % 12
      let octave = (noteNumber / 12) - 1
      return "\(noteNames[note])\(octave)"

    default:
      return genericFormatter.string(from: NSNumber(value: value)) ?? ""
    }
  }
}
