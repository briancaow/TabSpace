//
//  Constants.swift
//  TabSpace
//
//  Created by Brian Cao on 3/12/23.
//

import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static var spaces: Dictionary<String, KeyboardShortcuts.Name> = [:]
    static var clearDesktop = Self("clearDesktop")
    static var editSpaces = Self("editSpaces")
}

class Constants {
    static let delay: Double = 0.1
}
