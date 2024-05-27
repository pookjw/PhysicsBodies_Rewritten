//
//  Entity+CollisionPhysicsBox.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import RealityKit
import CoreGraphics

fileprivate let defaultMass1Kg: Float = 1.0

extension Entity {
    // 외벽 정의
    static func boxWithCollisionPhysics(
        location: SIMD3<Float>,
        boxSize: SIMD3<Float>,
        boxMass: Float = defaultMass1Kg
    ) -> Entity {
        let boxEntity: ModelEntity = .init()
        
        let boxShape: ShapeResource = .generateBox(size: boxSize)
        
        let collisionComponent: CollisionComponent = .init(
            shapes: [boxShape],
            isStatic: true // collider이 고정인지 아닌지 - 고정이라면 true로 하면 성능에 좋아질 것
        )
        
        let physicsBodyComponent: PhysicsBodyComponent = .init(
            shapes: [boxShape],
            mass: boxMass,
            mode: .static // 벽은 움직이지 않는다.
        )
        
        let mesh: MeshResource = .generateBox(size: boxSize)
        
        boxEntity.position = location
        boxEntity.components.set(collisionComponent)
        boxEntity.components.set(physicsBodyComponent)
        boxEntity.model = .init(
            mesh: mesh,
            materials: [
                SimpleMaterial(color: .init(white: 1.0, alpha: 0.1), isMetallic: true)
            ]
        )
        
        return boxEntity
    }
}
