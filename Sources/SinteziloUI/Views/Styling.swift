//
//  Styling.swift
//  SinteziloUI
//
//  Created by Simon Lawrence on 19/08/2023.
//  Copyright © 2023 Akordo Limited. All rights reserved.
//

import SwiftUI

struct DisplayFonts {

  static let condensed = "AppleSDGothicNeo-Light"
  static let medium = "AppleSDGothicNeo-Medium"

  static var title: Font = .custom(medium, size: 24.0, relativeTo: .title)
  static var body: Font = .custom(medium, size: 17.0, relativeTo: .body)
  static var subheadline: Font = .custom(medium, size: 15.0, relativeTo: .subheadline)
  static var caption: Font = .custom(condensed, size: 11.0, relativeTo: .caption)
  static var mediumCaption: Font = .custom(medium, size: 11.0, relativeTo: .caption)
}

struct Geometry {

  static var controlSize: CGSize = {
    CGSize(width: 120.0,
           height: 100.0)
  }()
}
