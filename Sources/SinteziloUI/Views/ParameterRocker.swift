//
//  ParameterRocker.swift
//  
//
//  Created by Simon Lawrence on 12/10/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

public struct ParameterRocker: View {

  public init(viewModel: ParameterViewModel) {

    self.viewModel = viewModel
    toggleOn = ParameterRocker.isOn(viewModel: viewModel)
    if viewModel.pickerValues.count >= 2 {
      offTitle = viewModel.pickerValues[0].stringValue
      onTitle = viewModel.pickerValues[1].stringValue
    } else {
      offTitle = "Off"
      onTitle = "On"
    }
  }

  static func isOn(viewModel: ParameterViewModel, value: Float? = nil) -> Bool {
    let value = value ?? viewModel.currentValue
    if viewModel.pickerValues.count >= 2 {
      return value == viewModel.pickerValues[1].parameterValue
    }
    return value > 0
  }

  @State var toggleOn = false
  @ObservedObject var viewModel: ParameterViewModel
  var offTitle: String
  var onTitle: String

  func updateParameter(on: Bool) {
    let index = on ? 1 : 0
    if viewModel.pickerValues.count >= 2 {
      viewModel.currentValue = viewModel.pickerValues[index].parameterValue
    } else {
      viewModel.currentValue = Float(index)
    }
  }

  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 4) {
        VStack {
          ZStack(alignment: .center) {
            ZStack{
              Rectangle()
                .frame(width: 44, height: 80)
                .foregroundColor(.clear)
              Capsule()
                .frame(width: 36, height: 72)
                .foregroundColor(Color(.darkGray))
                .opacity(1.0)
            }
            ParameterRockerThumb()
            .offset(y: toggleOn ? -18 : 18)
          }
          .onTapGesture {
            viewModel.onEditingChanged(true)
            updateParameter(on: !toggleOn)
            viewModel.onEditingChanged(false)
          }}
        VStack(alignment: .leading, spacing: 0) {
          Text(onTitle)
          Spacer()
          Text(offTitle)
        }
        .font(DisplayFonts.caption)
        .padding(.vertical, 22)
      }.frame(maxHeight: 100)
      Text(viewModel.title)
        .font(DisplayFonts.mediumCaption)
        .foregroundColor(.primary)
        .frame(height: 10.0)
        .offset(CGSize(width: 0, height: -1))
    }
    .onReceive(viewModel.$currentValue) { newValue in
      let updatedValue = ParameterRocker.isOn(viewModel: viewModel, value: newValue)
      if updatedValue != toggleOn {
        withAnimation(.easeInOut) {
          toggleOn = updatedValue
        }
      }
    }
    .frame(width: Geometry.controlSize.width, height: Geometry.controlSize.height)
  }
}

struct ParameterRocker_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      ParameterRocker(viewModel: ParameterViewModel(parameter: MockParameters.lfo1Reset))
      ParameterRocker(viewModel: ParameterViewModel(parameter: MockParameters.lfo1Mono))
    }
  }
}
