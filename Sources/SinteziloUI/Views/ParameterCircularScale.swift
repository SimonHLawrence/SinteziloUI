//
//  ParameterCircularScale.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 02/10/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

extension CGRect {

  var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }
}

struct ParameterCircularScale: View {
  internal init(radius: CGFloat = 30.0, viewModel: ParameterViewModel) {
    self.viewModel = viewModel
    self.radius = radius
  }

  var viewModel: ParameterViewModel
  let tickLength = 4.0
  var radius: CGFloat

  func arcPoint(angle: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint {

    let x = center.x + radius * cos(angle)
    let y = center.y + radius * sin(angle)

    return CGPoint(x: x, y: y)
  }

  func radius(textSize: CGSize, angle: CGFloat) -> CGFloat {

    let angleCos = cos(angle)
    let angleSin = sin(angle)

    let horizontalRadius = angleCos != 0.0 ? (textSize.width / 2.0) / angleCos : .greatestFiniteMagnitude
    let verticalRadius = (angleSin != 0.0) ? (textSize.height / 2.0) / angleSin : .greatestFiniteMagnitude

    return min(abs(horizontalRadius), abs(verticalRadius))
  }

  var body: some View {

    Canvas { context, size in

      if size.width <= 32 || size.height <= 32 {
        return
      }

      let arcRange = ParameterKnob.angleRangeProportion
      let bounds = CGRect(origin: CGPoint.zero, size: size).insetBy(dx: 24, dy: 24)
      let center = bounds.center
      let startAngle = Angle(radians: -.pi * arcRange - (.pi / 2))
      let endAngle = Angle(radians: .pi * arcRange  - (.pi / 2))

      var path = Path()
      path.addArc(center: CGPoint(x: center.x, y: center.y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

      let pointsOfInterest = viewModel.pointsOfInterest
      if !pointsOfInterest.isEmpty {

        let angleRange = endAngle.radians - startAngle.radians
        let largeSize = CGSize(width: 1000.0, height: 1000.0)

        for pointOfInterest in pointsOfInterest {

          let proportion = (pointOfInterest.displayValue - viewModel.minValue) / viewModel.range
          let angle = startAngle.radians + angleRange * Double(proportion)
          path.move(to: arcPoint(angle: angle, center: center, radius: radius))
          path.addLine(to: arcPoint(angle: angle, center: center, radius: radius + tickLength))
          let text = Text(pointOfInterest.title)
          let resolved = context.resolve(text.font(DisplayFonts.caption).foregroundColor(.white))
          let textSize = resolved.measure(in: largeSize)
          let textRadius = self.radius(textSize: textSize, angle: angle)
          var textPosition = arcPoint(angle: angle, center: center, radius: radius + tickLength + textRadius + 2.0)
          textPosition.x -= textSize.width / 2
          textPosition.y -= textSize.height / 2
          let textRect = CGRect(origin: textPosition, size: textSize).integral
          context.draw(resolved, in: textRect)
        }
      }

      context.stroke(path, with: .color(.white))
    }.background(.clear)
  }
}

struct ParameterCircularScale_Previews: PreviewProvider {
  static var previews: some View {
    let pointsOfInterest: [Float] = [10.0, 110.0, 330.0, 1000.0, 2700.0, 6000.0, 12000.0]
    let viewModel = ParameterViewModel(parameter: MockParameters.cutoff,
                                       pointsOfInterest: pointsOfInterest)

    ParameterCircularScale(viewModel: viewModel)
  }
}
