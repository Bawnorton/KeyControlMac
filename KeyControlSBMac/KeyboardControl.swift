//
//  KeyboardControl.swift
//  KeyControlSBMac
//
//  Created by Benjamin Norton on 2021-12-06.
//

import Foundation
import Cocoa

struct Key {
    var keyCode: CGKeyCode!
    var representing: String!
    var pressed: Bool = false {
        didSet {
            keyAction(KeyID: self.keyCode, keyDown: self.pressed)
        }
    }
    func keyAction(KeyID: CGKeyCode, keyDown: Bool) {
        if [55, 56, 57, 58, 59, 60, 61, 62, 123].contains(KeyID) {
            return
        }
        let keyDownEvent = CGEvent(keyboardEventSource: CGEventSource.init(stateID: .hidSystemState), virtualKey: KeyID, keyDown: keyDown)
        keyDownEvent?.flags = CGEventFlags(rawValue: 536870912) // Reset Flags (bug in swift :') )
        if KeyboardControl.cpsLock {
            keyDownEvent?.flags.insert(.maskAlphaShift)
        }
        if KeyboardControl.shift {
            keyDownEvent?.flags.insert(.maskShift)
        }
        if KeyboardControl.cmd {
            keyDownEvent?.flags.insert(.maskCommand)
        }
        if KeyboardControl.alt {
            keyDownEvent?.flags.insert(.maskAlternate)
        }
        if KeyboardControl.ctrl {
            keyDownEvent?.flags.insert(.maskControl)
        }
        keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
}

var keyboard: [Int : Key] = [
    0 : Key(keyCode: 53, representing: "ESCAPE"),
    1 : Key(keyCode: 122, representing: "F1"),
    2 : Key(keyCode: 120, representing: "F2"),
    3 : Key(keyCode: 99, representing: "F3"),
    4 : Key(keyCode: 118, representing: "F4"),
    5 : Key(keyCode: 96, representing: "F5"),
    6 : Key(keyCode: 97, representing: "F6"),
    7 : Key(keyCode: 98, representing: "F7"),
    8 : Key(keyCode: 100, representing: "F8"),
    9 : Key(keyCode: 101, representing: "F9"),
    10 : Key(keyCode: 109, representing: "F10"),
    11 : Key(keyCode: 103, representing: "F11"),
    12 : Key(keyCode: 111, representing: "F12"),
    13 : Key(keyCode: 123, representing: "EJECT"),
    14 : Key(keyCode: 10, representing: "§"),
    15 : Key(keyCode: 18, representing: "1"),
    16 : Key(keyCode: 19, representing: "2"),
    17 : Key(keyCode: 20, representing: "3"),
    18 : Key(keyCode: 21, representing: "4"),
    19 : Key(keyCode: 23, representing: "5"),
    20 : Key(keyCode: 22, representing: "6"),
    21 : Key(keyCode: 26, representing: "7"),
    22 : Key(keyCode: 28, representing: "8"),
    23 : Key(keyCode: 25, representing: "9"),
    24 : Key(keyCode: 29, representing: "0"),
    25 : Key(keyCode: 27, representing: "-"),
    26 : Key(keyCode: 24, representing: "="),
    27 : Key(keyCode: 51, representing: "DELETE"),
    28 : Key(keyCode: 48, representing: "TAB"),
    29 : Key(keyCode: 12, representing: "q"),
    30 : Key(keyCode: 13, representing: "w"),
    31 : Key(keyCode: 14, representing: "e"),
    32 : Key(keyCode: 15, representing: "r"),
    33 : Key(keyCode: 17, representing: "t"),
    34 : Key(keyCode: 16, representing: "y"),
    35 : Key(keyCode: 32, representing: "u"),
    36 : Key(keyCode: 34, representing: "i"),
    37 : Key(keyCode: 31, representing: "o"),
    38 : Key(keyCode: 35, representing: "p"),
    39 : Key(keyCode: 33, representing: "["),
    40 : Key(keyCode: 30, representing: "]"),
    41 : Key(keyCode: 42, representing: "\\"),
    42 : Key(keyCode: 57, representing: "CPSLOCK"),
    43 : Key(keyCode: 0, representing: "a"),
    44 : Key(keyCode: 1, representing: "s"),
    45 : Key(keyCode: 2, representing: "d"),
    46 : Key(keyCode: 3, representing: "f"),
    47 : Key(keyCode: 5, representing: "g"),
    48 : Key(keyCode: 4, representing: "h"),
    49 : Key(keyCode: 38, representing: "j"),
    50 : Key(keyCode: 40, representing: "k"),
    51 : Key(keyCode: 37, representing: "l"),
    52 : Key(keyCode: 41, representing: ";"),
    53 : Key(keyCode: 39, representing: "'"),
    54 : Key(keyCode: 36, representing: "ENTER"),
    55 : Key(keyCode: 56, representing: "SHIFT"),
    56 : Key(keyCode: 50, representing: "`"),
    57 : Key(keyCode: 6, representing: "z"),
    58 : Key(keyCode: 7, representing: "x"),
    59 : Key(keyCode: 8, representing: "c"),
    60 : Key(keyCode: 9, representing: "v"),
    61 : Key(keyCode: 11, representing: "b"),
    62 : Key(keyCode: 45, representing: "n"),
    63 : Key(keyCode: 46, representing: "m"),
    64 : Key(keyCode: 43, representing: ","),
    65 : Key(keyCode: 47, representing: "."),
    66 : Key(keyCode: 44, representing: "/"),
    67 : Key(keyCode: 60, representing: "SHIFT"),
    68 : Key(keyCode: 59, representing: "CTRL"),
    69 : Key(keyCode: 58, representing: "ALT"),
    70 : Key(keyCode: 55, representing: "CMD"),
    71 : Key(keyCode: 49, representing: "SPACE"),
    72 : Key(keyCode: 55, representing: "CMD"),
    73 : Key(keyCode: 61, representing: "ALT"),
    74 : Key(keyCode: 62, representing: "CTRL")
]

class KeyboardControl {
    static var cpsLock = false, shift = false, cmd = false, alt = false, ctrl = false;
    
    func keyAction(KeyID: Int, pressed: Int) {
        let value: Bool = pressed == 0 ? true : false
        if keyboard[KeyID]?.pressed != value {
            keyboard[KeyID]?.pressed = value
            switch keyboard[KeyID]?.representing {
            case "CPSLOCK":
                if value == true {
                    KeyboardControl.cpsLock = !KeyboardControl.cpsLock
                }
            case "SHIFT":
                KeyboardControl.shift = value
            case "CMD":
                KeyboardControl.cmd = value
            case "ALT":
                KeyboardControl.alt = value
            case "CTRL":
                KeyboardControl.ctrl = value
            default:
                break
            }
        }
    }
}
