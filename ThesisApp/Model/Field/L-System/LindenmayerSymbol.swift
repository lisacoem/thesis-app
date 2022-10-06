//
//  LindenmayerSymbol.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 21.09.22.
//

import Foundation

//         | 1    0      0    |
// Rx(α) = | 0 cos(α) -sin(α) |
//         | 0 sin(α)  cos(α) |

//         | cos(α)  sin(α) 0 |
// Ry(α) = | -sin(α) cos(α) 0 |
//         |    0      0    1 |

//         | cos(α) 0 -sin(α) |
// Rz(α) = |   0    1    0    |
//         | sin(α) 0  cos(α) |


enum LindenmayerSymbol: Character, CaseIterable {
    case forward = "F"
    case turnLeft = "+"     // turn left by angle δ, using Ry(δ)
    case turnRight = "-"    // turn right by angle δ, using Ry(-δ)
    case pitchDown = "&"    // pitch down by angle δ, using Rx(δ)
    case pitchUp = "^"      // pitch up by angle δ, using Rx(-δ)
    case rollLeft = "\\"    // roll left by angle δ, using Rz(δ)
    case rollRight = "/"    // roll right by angle δ, using Rz(-δ)
    case turnAround = "|"   // turn around, using Ry(180°)
    case startBranch = "["
    case endBranch = "]"
    case leaf = "J"
    case bud = "K"
    case flower = "L"
    case fruit = "M"
}
