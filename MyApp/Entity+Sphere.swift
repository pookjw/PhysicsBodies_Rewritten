//
//  Entity+Sphere.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import RealityKit
import simd
import CoreGraphics

extension Entity {
    static func metallicSphere(
        _ sphereRadius: Float = 0.15 * .random(in: (0.2)...(1.0)),
        sceneFrame: BoundingBox
    ) -> Entity {
        let sphereEntity: ModelEntity = .init(
            mesh: .generateSphere(radius: sphereRadius),
            materials: [
                metallicSphereMaterial()
            ]
        )
        
        //
        
        let shape: ShapeResource = .generateSphere(radius: sphereRadius)
        
        sphereEntity.components.set(CollisionComponent(shapes: [shape]))
        
        //
        
        var physics: PhysicsBodyComponent = .init(
            shapes: [shape],
            density: 10_000
        )
        
        physics.isAffectedByGravity = false
        
        sphereEntity.components.set(physics)
        
        //
        
        // Highlight the sphere when a person looks at it.
        sphereEntity.components.set(HoverEffectComponent())
    
        // Configure the sphere to receive gesture inputs.
        sphereEntity.components.set(InputTargetComponent())
        
        // Add an attaction force to the sphere.
        sphereEntity.components.set(SphereAttractionComponent())
        
        var ambient: __AmbientLightComponent = .init()
        ambient.intensity = 50
        ambient.color = .init(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        sphereEntity.components.set(ambient)
        
        //
        
        sphereEntity.position = .init(
            x: sceneFrame.min.x + .random(in: sphereRadius..<(sceneFrame.extents.x - sphereRadius)),
            y: sceneFrame.min.y + .random(in: sphereRadius..<(sceneFrame.extents.y - sphereRadius)),
            z: sceneFrame.min.z + .random(in: sphereRadius..<(sceneFrame.extents.z - sphereRadius))
        )
        
        return sphereEntity
    }
}

private func metallicSphereMaterial(
    hue: CGFloat = .random(in: (0.0)...(1.0))
) -> PhysicallyBasedMaterial {
    var material: PhysicallyBasedMaterial = .init()
    
    let color: RealityKit.Material.Color = .init(
        hue: hue,
        saturation: .random(in: (0.5)...(1.0)),
        brightness: 0.9,
        alpha: 1.0
    )
    
    material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color, texture: nil)
    material.metallic = 1.0
    material.roughness = 0.5
    material.clearcoat = 1.0
    material.clearcoatRoughness = 0.1
    
    return material
}
