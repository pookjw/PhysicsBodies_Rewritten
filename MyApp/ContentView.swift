//
//  ContentView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var containmentCollisionBox: ContainmentCollisionBox = .init()
    
    var body: some View {
        GeometryReader3D { geometry in
            RealityView { content in
                let localFrame: Rect3D = geometry.frame(in: .local)
                let sceneFrame: BoundingBox = content.convert(localFrame, from: .local, to: .scene)
                
                addSpheres(content, sceneFrame: sceneFrame)
                content.add(containmentCollisionBox)
            } update: { content in
                let localFrame: Rect3D = geometry.frame(in: .local)
                let sceneFrame: BoundingBox = content.convert(localFrame, from: .local, to: .scene)
                
                containmentCollisionBox.update(sceneFrame)
            }
            .gesture(ForceDragGesture())
//            .gesture(RelocateDragGesture())
        }
    }
    
    private func addSpheres(_ content: RealityViewContent, sceneFrame: BoundingBox) {
        for index in 0..<16 {
            let sphereEntity: Entity = .metallicSphere(sceneFrame: sceneFrame)
            sphereEntity.name = "Sphere_\(index)"
            
            content.add(sphereEntity)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
