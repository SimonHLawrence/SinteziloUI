//
//  ParameterGroupPopover.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 26/03/2024.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

public struct ParameterGroupPopover: View {
  @State private var showingPopover = false
  var viewModel: ParameterGroupViewModel

  public var body: some View {
    VStack(alignment: .leading, spacing: 4.0) {
      Text(viewModel.title).font(DisplayFonts.subheadline)
      HStack(alignment: .top, spacing: 4.0) {
        Button(viewModel.title) {
          showingPopover = true
        }
        .frame(width: Geometry.controlSize.width, height: Geometry.controlSize.height)
        .popover(isPresented: $showingPopover) {
          ParameterGroup(viewModel: viewModel)
            .padding(8)
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

  public init(showingPopover: Bool = false, viewModel: ParameterGroupViewModel) {
    self.showingPopover = showingPopover
    self.viewModel = viewModel
  }
}

struct ParameterGroupPopover_Previews: PreviewProvider {
  static var previews: some View {

    let filterParameters: [ParameterViewModel] = [
      ParameterViewModel(parameter: MockParameters.lfo1Reset),
      ParameterViewModel(parameter: MockParameters.lfo1Mono),
      ParameterViewModel(parameter: MockParameters.cutoff,
                         pointsOfInterest: [10.0, 110.0, 330.0, 1000.0, 2700.0, 6000.0, 12000.0]),
      ParameterViewModel(parameter: MockParameters.resonance,
                         pointsOfInterest: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ]

    let filterViewModel = ParameterGroupViewModel(name: "Filter", parameters: filterParameters)

    ParameterGroupPopover(viewModel: filterViewModel)
  }
}
