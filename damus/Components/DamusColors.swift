//
//  DamusColors.swift
//  damus
//
//  Created by William Casarin on 2023-03-27.
//

import Foundation
import SwiftUI

class DamusColors {
    static let adaptableGrey = Color("DamusAdaptableGrey", bundle: Bundle(for: DamusColors.self))
    static let adaptableBlack = Color("DamusAdaptableBlack", bundle: Bundle(for: DamusColors.self))
    static let adaptableWhite = Color("DamusAdaptableWhite", bundle: Bundle(for: DamusColors.self))
    static let white = Color("DamusWhite", bundle: Bundle(for: DamusColors.self))
    static let black = Color("DamusBlack", bundle: Bundle(for: DamusColors.self))
    static let brown = Color("DamusBrown", bundle: Bundle(for: DamusColors.self))
    static let yellow = Color("DamusYellow", bundle: Bundle(for: DamusColors.self))
    static let gold = hex_col(r: 226, g: 168, b: 0)
    static let lightGrey = Color("DamusLightGrey", bundle: Bundle(for: DamusColors.self))
    static let mediumGrey = Color("DamusMediumGrey", bundle: Bundle(for: DamusColors.self))
    static let darkGrey = Color("DamusDarkGrey", bundle: Bundle(for: DamusColors.self))
    static let green = Color("DamusGreen", bundle: Bundle(for: DamusColors.self))
    static let purple = Color("DamusPurple", bundle: Bundle(for: DamusColors.self))
    static let deepPurple = Color("DamusDeepPurple", bundle: Bundle(for: DamusColors.self))
    static let blue = Color("DamusBlue", bundle: Bundle(for: DamusColors.self))
    static let bitcoin = Color("Bitcoin", bundle: Bundle(for: DamusColors.self))
    static let success = Color("DamusSuccessPrimary", bundle: Bundle(for: DamusColors.self))
    static let successSecondary = Color("DamusSuccessSecondary", bundle: Bundle(for: DamusColors.self))
    static let successTertiary = Color("DamusSuccessTertiary", bundle: Bundle(for: DamusColors.self))
    static let successQuaternary = Color("DamusSuccessQuaternary", bundle: Bundle(for: DamusColors.self))
    static let successBorder = Color("DamusSuccessBorder", bundle: Bundle(for: DamusColors.self))
    static let warning = Color("DamusWarningPrimary", bundle: Bundle(for: DamusColors.self))
    static let warningSecondary = Color("DamusWarningSecondary", bundle: Bundle(for: DamusColors.self))
    static let warningTertiary = Color("DamusWarningTertiary", bundle: Bundle(for: DamusColors.self))
    static let warningQuaternary = Color("DamusWarningQuaternary", bundle: Bundle(for: DamusColors.self))
    static let warningBorder = Color("DamusWarningBorder", bundle: Bundle(for: DamusColors.self))
    static let danger = Color("DamusDangerPrimary", bundle: Bundle(for: DamusColors.self))
    static let dangerSecondary = Color("DamusDangerSecondary", bundle: Bundle(for: DamusColors.self))
    static let dangerTertiary = Color("DamusDangerTertiary", bundle: Bundle(for: DamusColors.self))
    static let dangerQuaternary = Color("DamusDangerQuaternary", bundle: Bundle(for: DamusColors.self))
    static let dangerBorder = Color("DamusDangerBorder", bundle: Bundle(for: DamusColors.self))
    static let neutral1 = Color("DamusNeutral1", bundle: Bundle(for: DamusColors.self))
    static let neutral3 = Color("DamusNeutral3", bundle: Bundle(for: DamusColors.self))
    static let neutral6 = Color("DamusNeutral6", bundle: Bundle(for: DamusColors.self))
    static let pink = Color(red: 211/255.0, green: 76/255.0, blue: 217/255.0)
    static let lighterPink = Color(red: 248/255.0, green: 105/255.0, blue: 182/255.0)
    static let lightBackgroundPink = Color(red: 0xF8/255.0, green: 0xE7/255.0, blue: 0xF8/255.0)
}

func hex_col(r: UInt8, g: UInt8, b: UInt8) -> Color {
    return Color(.sRGB,
                 red: Double(r) / Double(0xff),
                 green: Double(g) / Double(0xff),
                 blue: Double(b) / Double(0xff),
                 opacity: 1.0)
}
