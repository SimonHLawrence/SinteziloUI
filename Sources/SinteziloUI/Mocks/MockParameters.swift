//
//  MockParameters.swift
//  
//
//  Created by Simon Lawrence on 17/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import Foundation
import CoreAudioKit

final class MockParameter: AUParameter {

  init(address: AUParameterAddress,
       flags: AudioUnitParameterOptions,
       initialValue: AUValue = 0.0,
       displayName: String,
       minValue: AUValue,
       maxValue: AUValue,
       unitName: String? = nil,
       unit: AudioUnitParameterUnit,
       valueStrings: [String]? = nil) {
    self._address = address
    self._flags = flags
    self._displayName = displayName
    self._minValue = minValue
    self._maxValue = maxValue
    self._unitName = unitName
    self._unit = unit
    self._valueStrings = valueStrings

    super.init()

    self.value = initialValue
  }

  private var _address: AUParameterAddress
  private var _flags: AudioUnitParameterOptions
  private var _displayName: String
  private var _minValue: AUValue
  private var _maxValue: AUValue
  private var _unitName: String?
  private var _unit: AudioUnitParameterUnit
  private var _valueStrings: [String]?

  override var address: AUParameterAddress { _address }
  override var flags: AudioUnitParameterOptions { _flags }
  override var displayName: String { _displayName }
  override var minValue: AUValue { _minValue }
  override var maxValue: AUValue { _maxValue }
  override var unitName: String? { _unitName }
  override var unit: AudioUnitParameterUnit { _unit }
  override var valueStrings: [String]? { _valueStrings }

  override func value(from string: String) -> AUValue {
    let values = (valueStrings ?? [])
    return AUValue(values.firstIndex(of: string) ?? values.startIndex)
  }

  override func setValue(_ value: AUValue, originator: AUParameterObserverToken?, atHostTime hostTime: UInt64, eventType: AUParameterAutomationEventType) {

    super.setValue(value, originator: originator, atHostTime: hostTime, eventType: eventType)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct MockParameters {

  static var cutoff = MockParameter(address: 1,
                                    flags: [.flag_DisplayLogarithmic, .flag_IsHighResolution, .flag_IsReadable, .flag_IsWritable],
                                    initialValue: 330.0,
                                    displayName: "Cutoff",
                                    minValue: 10.0,
                                    maxValue: 12000.0,
                                    unitName: "Hz",
                                    unit: .hertz)

  static var resonance = MockParameter(address: 2,
                                       flags: [.flag_IsHighResolution, .flag_IsReadable, .flag_IsWritable],
                                       initialValue: 5.0,
                                       displayName: "Resonance",
                                       minValue: 0.0,
                                       maxValue: 10.0,
                                       unit: .generic)

  static var osc1Waveform = MockParameter(address: 3,
                                          flags: [.flag_IsWritable, .flag_IsReadable, .flag_ValuesHaveStrings],
                                          initialValue: 1.0,
                                          displayName: "Osc 1 Waveform",
                                          minValue: 0, maxValue: 4,
                                          unit: .indexed,
                                          valueStrings: ["SIN", "TRI", "SQR", "SAW", "RAMP"])

  static var osc1FineTune = MockParameter(address: 4,
                                          flags: [.flag_IsWritable, .flag_IsReadable, .flag_IsHighResolution],
                                          initialValue: 50.0,
                                          displayName: "Osc 1 Fine Tuning",
                                          minValue: -100.0, maxValue: 100.0,
                                          unit: .percent)

  static var osc2Waveform = MockParameter(address: 5,
                                          flags: [.flag_IsWritable, .flag_IsReadable, .flag_ValuesHaveStrings],
                                          initialValue: 2.0,
                                          displayName: "Osc 2 Waveform",
                                          minValue: 0, maxValue: 3,
                                          unit: .indexed,
                                          valueStrings: ["SIN", "TRI", "SQR", "SAW"])

  static var lfo1Reset = MockParameter(address: 5,
                                       flags: [.flag_IsWritable, .flag_IsReadable, .flag_ValuesHaveStrings],
                                       initialValue: 1.0,
                                       displayName: "LFO 1 Reset",
                                       minValue: 0, maxValue: 1,
                                       unit: .indexed,
                                       valueStrings: ["Free", "Reset"])
  static var lfo1Mono = MockParameter(address: 6,
                                      flags: [.flag_IsWritable, .flag_IsReadable],
                                      initialValue: 1.0,
                                      displayName: "LFO 1 Mono",
                                      minValue: 0, maxValue: 1,
                                      unit: .boolean)

  static var attack = MockParameter(address: 7,
                                    flags: [.flag_IsWritable, .flag_IsReadable, .flag_IsHighResolution, .flag_DisplayLogarithmic],
                                    initialValue: 20,
                                    displayName: "Attack",
                                    minValue: 5,
                                    maxValue: 2000,
                                    unitName: "ms",
                                    unit: .milliseconds)
  static var decay = MockParameter(address: 9,
                                   flags: [.flag_IsWritable, .flag_IsReadable, .flag_IsHighResolution, .flag_DisplayLogarithmic],
                                   initialValue: 500,
                                   displayName: "Decay",
                                   minValue: 5,
                                   maxValue: 2000,
                                   unitName: "ms",
                                   unit: .milliseconds)
  static var sustain = MockParameter(address: 8,
                                     flags: [.flag_IsWritable, .flag_IsReadable, .flag_IsHighResolution],
                                     initialValue: 60.0,
                                     displayName: "Sustain Level",
                                     minValue: 0.0, maxValue: 100.0,
                                     unit: .percent)
  static var release = MockParameter(address: 10,
                                     flags: [.flag_IsWritable, .flag_IsReadable, .flag_IsHighResolution, .flag_DisplayLogarithmic],
                                     initialValue: 1000,
                                     displayName: "Release",
                                     minValue: 5,
                                     maxValue: 2000,
                                     unitName: "ms",
                                     unit: .milliseconds)

  static var modAmount = MockParameter(address: 67,
                                       flags: [.flag_IsWritable, .flag_IsReadable, .flag_IsHighResolution, .flag_DisplayLogarithmic],
                                       initialValue: 0.0,
                                       displayName: "",
                                       minValue: 0.0,
                                       maxValue: 100.0,
                                       unit: .percent)
}
