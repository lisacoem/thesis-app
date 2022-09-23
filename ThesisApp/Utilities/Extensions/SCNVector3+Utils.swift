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
    
    var length: Float {
        sqrt(x * x + y * y + z * z)
    }
}

extension SCNVector3 {
    
    static let xAxis = SCNVector3(1, 0, 0)
    static let yAxis = SCNVector3(0, 1, 0)
    static let zAxis = SCNVector3(0, 0, 1)    
}

extension SCNVector3 {
    
    mutating func multiplyScalar(_ scalar: Float) {
        self.x = x * scalar
        self.y = y * scalar
        self.z = z * scalar
    }
    
    mutating func divideScalar(_ scalar: Float) {
        self.x = x / scalar
        self.y = y / scalar
        self.z = z / scalar
    }
}

extension SCNVector3 {
    
    mutating func add(_ vector: SCNVector3) {
        self.x = x + vector.x
        self.y = y + vector.y
        self.z = z + vector.z
    }
    
    mutating func sub(_ vector: SCNVector3) {
        self.x = x - vector.x
        self.y = y - vector.y
        self.z = z - vector.z
    }
    
    mutating func multiply(_ vector: SCNVector3) {
        self.x = x * vector.x
        self.y = y * vector.y
        self.z = z * vector.z
    }
    
    static func cross(_ v1: SCNVector3, _ v2: SCNVector3) -> SCNVector3 {
        .init(
            v1.y * v2.z - v1.z * v2.y,
            v1.z * v2.x - v1.x * v2.z,
            v1.x * v2.y - v1.y * v2.x
        )
    }
}

extension SCNVector3 {
    
    mutating func applyQuaternion(_ q: SCNQuaternion) {
        let ix = q.w * x + q.y * z - q.z * y
        let iy = q.w * y + q.z * x + q.x * z
        let iz = q.w * z + q.x * y + q.y * x
        let iw = -q.x * x - q.y * y - q.z * z
        
        x = ix * q.w + iw * -q.x + iy * -q.z - iz * -q.y
        y = iy * q.w + iw * -q.y + iz * -q.x - ix * -q.z
        z = iz * q.w + iw * -q.z + ix * -q.y - iy * -q.x
    }
}
