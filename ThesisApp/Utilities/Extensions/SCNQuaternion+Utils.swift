//
//  SCNQuaternion+Utils.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 20.09.22.
//

import SceneKit

extension SCNQuaternion {
    
    init(axis: SCNVector3, angle: Angle) {
        let s: Float = sin(angle.radians / 2);
        self.init(
            x: axis.x * s,
            y: axis.y * s,
            z: axis.z * s,
            w: cos(angle.radians / 2)
        )
    }
    
    func copy() -> SCNQuaternion {
        .init(x, y, z, w)
    }
}

extension SCNQuaternion {
    
    mutating func multiply(axis: SCNVector3, angle: Angle) {
        return self.multiply(SCNQuaternion(axis: axis, angle: angle))
    }
    
    mutating func multiply(_ q: SCNQuaternion) {
        x = x * q.w + y * q.z - z * q.y + w * q.x
        y = -x * q.z + y * q.w + z * q.x + w * q.y
        z = x * q.y - y * q.x + z * q.w + w * q.z
        w = -x * q.x - y * q.y - z * q.z + w * q.w
    }
}
