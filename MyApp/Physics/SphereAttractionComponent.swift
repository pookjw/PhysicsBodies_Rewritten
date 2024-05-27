//
//  SphereAttractionComponent.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import RealityKit

struct SphereAttractionComponent: Component {
    init() {
        SphereAttractionSystem.registerSystem()
    }
}
