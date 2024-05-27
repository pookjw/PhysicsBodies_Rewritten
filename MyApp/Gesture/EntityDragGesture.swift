//
//  EntityDragGesture.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import SwiftUI
import RealityKit

struct EntityDragGesture: Gesture {
    struct GestureStateComponent: Component {
        var startPosition: SIMD3<Float>
    }
    
    let gestureStateType = GestureStateComponent.self
    
    typealias Closure = (Entity, SIMD3<Float>) -> Void
    
    let closure: Closure
    
    init(closure: @escaping Closure) {
        self.closure = closure
    }
    
    var body: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { gestureValue in
                let entity: Entity = gestureValue.entity
                let startPosition: SIMD3<Float> = startPosition(entity)
                let targetPosition: SIMD3<Float> = gestureValue.convert(gestureValue.translation3D,
                                                                        from: .local, 
                                                                        to: .scene)
                
                // 초기 위치 + diff (translation)
                closure(entity, startPosition + targetPosition)
            }
            .onEnded { gestureValue in
                gestureValue.entity.components.remove(gestureStateType)
            }
        
    }
    
    func startPosition(_ entity: Entity) -> SIMD3<Float> {
        if let gestureStateComponent: GestureStateComponent = entity.components[gestureStateType] {
            return gestureStateComponent.startPosition
        } else {
            let position: SIMD3<Float> = entity.position(relativeTo: nil)
            let newComponent: GestureStateComponent = .init(startPosition: position)
            
            entity.components.set(newComponent)
            return position
        }
    }
}
