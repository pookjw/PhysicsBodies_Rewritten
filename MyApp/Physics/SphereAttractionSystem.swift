//
//  SphereAttractionSystem.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import RealityKit

struct SphereAttractionSystem: System {
    private let entityQuery: EntityQuery
    
    init(scene: Scene) {
        let attractionComponentType = SphereAttractionComponent.self
        entityQuery = .init(where: .has(attractionComponentType))
    }
    
    func update(context: SceneUpdateContext) {
        let sphereEntities: QueryResult<Entity> = context.entities(
            matching: entityQuery,
            updatingSystemWhen: .rendering
        )
        
        for case let sphere as ModelEntity in sphereEntities {
            // 총(aggregate) 힘
            var aggregateForce: SIMD3<Float>
            
            // 중심으로 뭉치게 하는 벡터
            let position: SIMD3<Float> = sphere.position(relativeTo: nil)
            
            // 유클리드 길이를 제곱한 것
            let distanceSquared: Float = length_squared(position)
            
            aggregateForce = normalize(position) / distanceSquared
            
            let centerForceStrengh: Float = 0.05
            
            aggregateForce *= -centerForceStrengh
            
            
            // 구 하나를 정하고, 나머지 구와 연결된 벡터들을 구해고 그 벡터를 힘으로 변환하여 구 하나에 힘을 부여한다.
            // 이 작업을 모든 구에 반복한다
            for neighbor in sphereEntities where neighbor != sphere {
                let neighborPosition: SIMD3<Float> = neighbor.position(relativeTo: nil)
                let distance: Float = length(neighborPosition - position)
                
                // Calculate the force from the sphere to the neighbor.
                let forceFactor: Float = 0.1
                let forceVector: SIMD3<Float> = normalize(neighborPosition - position)
                let neighborForce: SIMD3<Float> = forceFactor * forceVector / pow(distance, 2)
                aggregateForce += neighborForce
            }
            
            // Add the combined force from all the sphere's neighbors.
            sphere.addForce(aggregateForce, relativeTo: nil)
        }
    }
}
