//
//  ContainmentCollisionBox.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import RealityKit

final class ContainmentCollisionBox: Entity {
    var lastBoundingBox: BoundingBox?
    
    func update(_ boundingBox: BoundingBox) {
        guard boundingBox != lastBoundingBox else {
            return
        }
        
        lastBoundingBox = boundingBox
        
        children.removeAll()
        
        let min: SIMD3<Float> = boundingBox.min
        let max: SIMD3<Float> = boundingBox.max
        let center: SIMD3<Float> = boundingBox.center
        
        /*
           +---------------+
          /|              /|
         / |     4       / |
         +--------------+  |
         | |            |  |
         |1|      5     | 2|
         | |            |  |
         | |    6       |  |
         | +------------|--+
         |/      3      | /
         +--------------+/
         
           y+
           |
           +- x+
          /
         z+
         
         lHandFace : 1
         rHandFace : 2
         lowerFace : 3
         upperFace : 4
         nearFace : 5
         afarFace : 6
         */
        let lHandFace: SIMD3<Float> = .init(x: min.x, y: center.y, z: center.z)
        let rHandFace: SIMD3<Float> = .init(x: max.x, y: center.y, z: center.z)
        let lowerFace: SIMD3<Float> = .init(x: center.x, y: min.y, z: center.z)
        let upperFace: SIMD3<Float> = .init(x: center.x, y: max.y, z: center.z)
        let nearFace: SIMD3<Float> = .init(x: center.x, y: center.y, z: min.z)
        let afarFace: SIMD3<Float> = .init(x: center.x, y: center.y, z: max.z)
        
        let thickness: Float = 1E-3
        
        // Configure the size for the left and right faces.
        var size: SIMD3<Float> = boundingBox.extents
        
        size.x = thickness
        
        var face: Entity = .boxWithCollisionPhysics(location: lHandFace, boxSize: size)
        addChild(face)
        
        face = .boxWithCollisionPhysics(location: rHandFace, boxSize: size)
        addChild(face)
        
        //
        
        size = boundingBox.extents
        size.y = thickness
        
        face = .boxWithCollisionPhysics(location: lowerFace, boxSize: size)
        addChild(face)
        
        face = .boxWithCollisionPhysics(location: upperFace, boxSize: size)
        addChild(face)
        
        //
        
        size = boundingBox.extents
        size.z = thickness
        
        face = .boxWithCollisionPhysics(location: nearFace, boxSize: size)
        addChild(face)
        
        face = .boxWithCollisionPhysics(location: afarFace, boxSize: size)
        addChild(face)
    }
}
