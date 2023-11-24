//
//  ParameterGroup.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 17/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

public struct ParameterGroup: View {

  public var viewModel: ParameterGroupViewModel

  public var body: some View {
    VStack(alignment: .leading, spacing: 4.0) {
      Text(viewModel.title).font(DisplayFonts.subheadline)
      HStack(alignment: .top, spacing: 4.0) {
        ForEach ( viewModel.parameters ) { parameter in
          if (parameter.pickerValues.count == 2) || (parameter.parameter.unit == .boolean) {
            ParameterRocker(viewModel: parameter)
          } else {
            ParameterKnob(viewModel: parameter)
          }
        }
      }
    }
    .padding([.leading, .trailing])
    .overlay {
      RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
        .stroke(lineWidth: 1)
        .foregroundColor(.gray)
        .padding(EdgeInsets(top: -2, leading: 4, bottom: -2, trailing: 8))
    }
  }

  public init(viewModel: ParameterGroupViewModel) {
    self.viewModel = viewModel
  }
}

struct ParameterGroup_Previews: PreviewProvider {
  static var previews: some View {

    let timePointsOfInterest: [Float] = [5, 25, 50, 100, 225, 500, 1000, 2000]
    let percentagePointsOfInterest: [Float] = [0, 20, 40, 60, 80, 100]

    let envelopeParameters: [ParameterViewModel] = [
      ParameterViewModel(parameter: MockParameters.attack,
                         pointsOfInterest: timePointsOfInterest),
      ParameterViewModel(parameter: MockParameters.decay,
                         pointsOfInterest: timePointsOfInterest),
      ParameterViewModel(parameter: MockParameters.sustain,
                         pointsOfInterest: percentagePointsOfInterest),
      ParameterViewModel(parameter: MockParameters.release,
                         pointsOfInterest: timePointsOfInterest),
    ]

    let envelopeViewModel = ParameterGroupViewModel(name: "Filter Envelope",
                                                    parameters: envelopeParameters)

    let filterParameters: [ParameterViewModel] = [
      ParameterViewModel(parameter: MockParameters.lfo1Reset),
      ParameterViewModel(parameter: MockParameters.lfo1Mono),
      ParameterViewModel(parameter: MockParameters.cutoff,
                         pointsOfInterest: [10.0, 110.0, 330.0, 1000.0, 2700.0, 6000.0, 12000.0]),
      ParameterViewModel(parameter: MockParameters.resonance,
                         pointsOfInterest: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ]

    let filterViewModel = ParameterGroupViewModel(name: "Filter",
                                                  parameters: filterParameters)
    let parameters: [ParameterViewModel] = [

      ParameterViewModel(parameter: MockParameters.osc1Waveform),
      ParameterViewModel(parameter: MockParameters.osc1FineTune,
                         pointsOfInterest: [-100, -50, 0, 50, 100]),
      ParameterViewModel(parameter: MockParameters.osc2Waveform),
    ]
    
    let oscillatorViewModel = ParameterGroupViewModel(name: "Oscillators",
                                            parameters: parameters)
    TabView {
      ParameterGroup(viewModel: filterViewModel).tabItem {
        Label(filterViewModel.title, systemImage: "chart.line.downtrend.xyaxis")
      }
      ParameterGroup(viewModel: envelopeViewModel).tabItem {
        Label(envelopeViewModel.title, systemImage: "chart.bar")
      }
      ParameterGroup(viewModel: oscillatorViewModel).tabItem {
        Label(oscillatorViewModel.title, systemImage: "badge.plus.radiowaves.right")
      }
    }
  }
}
