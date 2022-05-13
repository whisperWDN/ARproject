//
//  ARViewModel.swift
//  ARproject
//
//  Created by admin on 2022/5/2.
//

import Foundation
import RealityKit
import ARKit

class ARViewModel: ObservableObject{
    var arView: ARView
    init(){
        arView = ARView()
        arView.setupForARWorldConfiguration()
        arView.addCoaching()
#if DEBUG
//        arView.debugOptions = [.showAnchorOrigins, .showAnchorGeometry]
#endif
    }
}

extension ARView:ARCoachingOverlayViewDelegate{
    func setupForARWorldConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
//        configuration.isAutoFocusEnabled = false
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true

        if(ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth)){
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        if(ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)){
            configuration.sceneReconstruction = .mesh
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
        self.session.run(configuration)
    }
    func enableTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func handleTap(recognizer:UITapGestureRecognizer){
        let tapLocation = recognizer.location(in: self)
        let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
        if let firstRusult = results.first{
            let position = simd_make_float3(firstRusult.worldTransform.columns.3)
            placeCube(at:position)
        }
        
    }
    func placeCube(at position:SIMD3<Float>){
        let mesh = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh,materials: [material])
        modelEntity.generateCollisionShapes(recursive: true)
        self.installGestures([.translation],for: modelEntity)
        let anchorEntity = AnchorEntity(world:position)
        anchorEntity.addChild(modelEntity)
        self.scene.addAnchor(anchorEntity)
    }
    
    func placeCup(at position:SIMD3<Float>){
//        do{
//            let cup = try ModelEntity.load(named: "cup_saucer_set");
//            cup.generateCollisionShapes(recursive: true)
//            self.installGestures([.translation],for: cup as! HasCollision)
//            let tableAnchor = AnchorEntity(world: position)
//            tableAnchor.addChild(cup)
//            self.scene.addAnchor(tableAnchor)
//        }catch{
//        }
    }
    func addCoaching(){
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = true
        coachingOverlay.goal = .anyPlane
        self.addSubview(coachingOverlay)
    }
    
}

