//
//  ParameterRockerThumb.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 01/11/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

struct ParameterRockerThumb: View {
  public var body: some View {
    Circle()
      .stroke(Color.black, lineWidth: 10)
      .frame(width: 36, height: 36)
      .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
  }
}

struct ParameterRockerThumb_Previews: PreviewProvider {
  static var previews: some View {
    ParameterRockerThumb()
  }
}
