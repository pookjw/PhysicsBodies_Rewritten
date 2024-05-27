//
//  RelocateDragGesture.swift
//  MyApp
//
//  Created by Jinwoo Kim on 5/27/24.
//

import SwiftUI
import RealityKit

struct RelocateDragGesture: Gesture {
    var body: some Gesture {
        EntityDragGesture { entity, targetPosition in
            entity.setPosition(targetPosition, relativeTo: nil)
        }
    }
}
