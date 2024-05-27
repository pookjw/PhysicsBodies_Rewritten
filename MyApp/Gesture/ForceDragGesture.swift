//
//  ForceDragGesture.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import SwiftUI
import RealityKit

struct ForceDragGesture: Gesture {
    var body: some Gesture {
        EntityDragGesture { entity, targetPosition in
            guard let modelEntity: ModelEntity = entity as? ModelEntity else {
                return
            }
            
            let spherePosition: SIMD3<Float> = entity.position(relativeTo: nil)
            let direction: SIMD3<Float> = targetPosition - spherePosition
            
            var strength: Float = length(direction)
            if strength < 1.0 {
                strength *= strength
            } else {
                strength = sqrtf(strength)
            }
            
            let forceFactor: Float = 3000.0
            let force: SIMD3<Float> = forceFactor * strength * simd_normalize(direction)
            modelEntity.addForce(force, relativeTo: nil)
        }
    }
}
