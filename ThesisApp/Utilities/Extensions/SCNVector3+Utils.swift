//
//  SCNVector3+Utils.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 20.09.22.
//

import SceneKit

extension SCNVector3 {
    
    func copy() -> SCNVector3 {
        .init(x, y, z)
    }
}

extension SCNVector3 {
    
    static let xAxis = SCNVector3(1, 0, 0)
    static let yAxis = SCNVector3(0, 1, 0)
    static let zAxis = SCNVector3(0, 0, 1)    
}

extension SCNVector3 {
    
    func multiplyScalar(_ scalar: Float) -> SCNVector3 {
        .init(x: x * scalar, y: y * scalar, z: z * scalar)
    }
}

extension SCNVector3 {
    
    func add(_ vector: SCNVector3) -> SCNVector3 {
        .init(x: x + vector.x, y: y + vector.y, z: z + vector.z)
    }
}

extension SCNVector3 {
    
    func applyQuaternion(_ q: SCNQuaternion) -> SCNVector3 {
        let ix = q.w * x + q.y * z - q.z * y
        let iy = q.w * y + q.z * x + q.x * z
        let iz = q.w * z + q.x * y + q.y * x
        let iw = -q.x * x - q.y * y - q.z * z
        
        return .init(
            x: ix * q.w + iw * -q.x + iy * -q.z - iz * -q.y,
            y: iy * q.w + iw * -q.y + iz * -q.x - ix * -q.z,
            z: iz * q.w + iw * -q.z + ix * -q.y - iy * -q.x
        )
    }
}
