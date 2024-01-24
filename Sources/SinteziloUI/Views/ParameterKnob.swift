//
//  ParameterKnob.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 02/10/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

extension Array where Element: (Comparable & SignedNumeric) {

  func nearest(to value: Element) -> (offset: Int, element: Element)? {
    self.enumerated().min {
      abs($0.element - value) < abs($1.element - value)
    }
  }
}

/// A control representing a continuous or stepped knob for an ``AUParameter``.
public struct ParameterKnob: View {

  static let angleRangeProportion = 0.80
  static let angleRange = 2.0 * .pi * angleRangeProportion
  static let dragScale = 100.0
  static let knobImageSize = 60.0

  var isContinuous: Bool
  var minAngle: Double
  var maxAngle: Double
  var parameterValues: [Float]
  let baseAngle = (-.pi * ParameterKnob.angleRangeProportion) + 1.15

  @State var angle: Double = 0
  @State var dragLocation: CGPoint
  @ObservedObject var viewModel: ParameterViewModel

  public init(viewModel: ParameterViewModel) {
    minAngle = 0.0
    maxAngle = ParameterKnob.angleRange
    angle = ParameterKnob.toAngle(value: viewModel.currentValue, minValue: viewModel.minValue, range: viewModel.range)
    dragLocation = CGPoint.zero
    let isContinuous = !viewModel.parameter.flags.contains(.flag_ValuesHaveStrings)
    parameterValues = isContinuous ? [] : (viewModel.pointsOfInterest).map {$0.value}
    self.isContinuous = isContinuous
    self.viewModel = viewModel
  }

  static func toAngle(value: Float, minValue: Float, range: Float) -> Double {
    let proportion = (value - minValue) / range
    let angle = (angleRange) * Double(proportion)
    return angle
  }

  func toAngle(value: Float) -> Double {
    return ParameterKnob.toAngle(value: value, minValue: viewModel.minValue, range: viewModel.range)
  }

  func fromAngle(angle: Double) -> Float {
    let value = Float(angle / ParameterKnob.angleRange) * viewModel.range + viewModel.minValue
    return value
  }

  func setAngle(value: Double) {
    self.angle = min(max(minAngle, value), maxAngle)
  }
  
  func updateParameter(value: Float) {
    if !isContinuous,
       let nearestValue = parameterValues.nearest(to: value)?.element {
      if viewModel.currentValue != nearestValue {
        viewModel.currentValue = nearestValue
      }
    } else {
      viewModel.currentValue = value
    }
  }

  func dragChanged(value: DragGesture.Value) {
    if dragLocation == .zero {
      dragLocation = value.location
      viewModel.onEditingChanged(true)
      return
    }
    let difference =  dragLocation.y - value.location.y
    let dragAngle = angle + difference / ParameterKnob.dragScale * .pi
    setAngle(value: dragAngle)
    updateParameter(value: fromAngle(angle: dragAngle))
    dragLocation = value.location
  }

  func dragEnded() {
    dragLocation = .zero
    if !isContinuous {
      withAnimation(.easeInOut) {
        setAngle(value: toAngle(value: viewModel.currentValue))
      }
    }
    viewModel.onEditingChanged(false)
  }

  public var body: some View {
    VStack(alignment: .center, spacing: 0) {
      ZStack(alignment: .center) {
        ParameterCircularScale(viewModel: viewModel)
          .padding(-40.0)
        Image("SynthesizerKnob", bundle: .module)
          .resizable()
          .frame(width: ParameterKnob.knobImageSize, height: ParameterKnob.knobImageSize)
          .rotationEffect(Angle(radians: baseAngle + angle))
          .gesture(
            DragGesture(minimumDistance: 5, coordinateSpace: .global)
              .onChanged { value in
                dragChanged(value: value)
              }
              .onEnded { _ in
                dragEnded()
              }
          ).onReceive(viewModel.$currentValue, perform: { newValue in
            if viewModel.editingState == .hostUpdate {
              setAngle(value: toAngle(value: newValue))
            }
          })
      }
      if (!viewModel.title.isEmpty) {
        Text(viewModel.title)
          .font(DisplayFonts.mediumCaption)
          .foregroundColor(.primary)
          .background(Color.clear)
      }
    }
    .background(.clear)
    .frame(width: Geometry.controlSize.width, height: Geometry.controlSize.height)
  }
}

struct ParameterKnob_Previews: PreviewProvider {
  static var previews: some View {

    let cutoffPointsOfInterest: [Float] = [10.0, 110.0, 330.0, 1100.0, 3000.0, 6000.0, 12000.0]
    let resonancePointsOfInterest: [Float] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let timePointsOfInterest: [Float] = [5, 20, 50, 100, 250, 500, 1000, 2000]

    HStack(spacing: 0.0) {
      ParameterKnob(viewModel: ParameterViewModel(parameter: MockParameters.osc1Waveform))
      ParameterKnob(viewModel: ParameterViewModel(parameter: MockParameters.cutoff,
                                                  pointsOfInterest: cutoffPointsOfInterest))
      ParameterKnob(viewModel: ParameterViewModel(parameter: MockParameters.resonance,
                                                  pointsOfInterest: resonancePointsOfInterest))
      ParameterKnob(viewModel: ParameterViewModel(parameter: MockParameters.attack,
                                                  pointsOfInterest: timePointsOfInterest))
      ParameterKnob(viewModel: ParameterViewModel(parameter: MockParameters.decay,
                                                  pointsOfInterest: timePointsOfInterest))
    }.padding(.horizontal)
  }
}
