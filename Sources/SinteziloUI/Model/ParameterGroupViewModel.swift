//
//  ParameterGroupViewModel.swift
//  
//
//  Created by Simon Lawrence on 17/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import Foundation
import CoreAudioKit

public class ParameterGroupViewModel: ObservableObject, Identifiable, Hashable {

  var identifier = UUID()
  var title: String
  var parameters: [ParameterViewModel]

  public static func == (lhs: ParameterGroupViewModel, rhs: ParameterGroupViewModel) -> Bool {
    lhs.identifier == rhs.identifier
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  public convenience init(name: String, observerToken: AUParameterObserverToken? = nil, parameters: [AUParameter]) {

    let mappedParameters = parameters.map { ParameterViewModel(parameter: $0) }
    self.init(name: name, parameters: mappedParameters)
  }

  public init(name: String, parameters: [ParameterViewModel]) {

    self.title = name
    self.parameters = parameters
  }
}

