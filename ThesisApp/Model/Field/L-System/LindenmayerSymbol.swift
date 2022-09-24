//
//  LindenmayerSymbol.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 21.09.22.
//

import Foundation

//         | cos(α)  sin(α) 0 |
// RU(α) = | -sin(α) cos(α) 0 |
//         |    0      0    1 |

//         | cos(α) 0 -sin(α) |
// RL(α) = |   0    1    0    |
//         | sin(α) 0  cos(α) |

//         | 1    0      0    |
// RH(α) = | 0 cos(α) -sin(α) |
//         | 0 sin(α)  cos(α) |


enum LindenmayerSymbol: Character, CaseIterable {
    case forward = "F"
    case turnLeft = "+"     // turn left by angle δ, using RU(δ)
    case turnRight = "-"    // turn right by angle δ, using RU(-δ)
    case pitchDown = "&"    // pitch down by angle δ, using RL(δ)
    case pitchUp = "^"      // pitch up by angle δ, using RL(-δ)
    case rollLeft = "\\"    // roll left by angle δ, using RH(δ)
    case rollRight = "/"    // roll right by angle δ, using RH(-δ)
    case turnAround = "|"   // turn around, using RU(180°)
    case startBranch = "["
    case endBranch = "]"
}
