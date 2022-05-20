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
        arView.session.delegate = arView
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
#if DEBUG
//        arView.debugOptions = [.showAnchorOrigins, .showAnchorGeometry]
#endif
    }
}

extension ARView:ARCoachingOverlayViewDelegate{
    func setupForARWorldConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.isAutoFocusEnabled = false
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
    
    func setupForARImageConfiguration(){
        let config = ARImageTrackingConfiguration()
        guard let trackedImagesLib = ARReferenceImage.referenceImages(inGroupNamed: "ReferenceImageLibrary", bundle: Bundle.main) else {
            fatalError("无法加载参考图像库")
        }
        config.trackingImages = trackedImagesLib
        config.maximumNumberOfTrackedImages = 1
        self.session.run(config,options: [])
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

extension ARView:ARSessionDelegate{
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        guard let arError = error as? ARError else{return}
        let isRecoverable = (arError.code == .worldTrackingFailed)
        if isRecoverable{
            print("由于运动跟踪的错误可恢复")
        }
        else{
            print("错误不可恢复，失败code=\(arError.code),错误描述：\(arError.localizedDescription)")
        }
    }
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let imageAnchor = anchors[0]as?ARImageAnchor else{
            return
        }
        let referenceImageName = imageAnchor.referenceImage.name ?? "book"
        DispatchQueue.main.async {
            do{
                let myModelEntity = try Entity.load(named: referenceImageName)
                let imageAnchorEntity = AnchorEntity(anchor: imageAnchor)
                imageAnchorEntity.addChild(myModelEntity)
                self.scene.addAnchor(imageAnchorEntity)
            }catch{
                print("无法加载模型")
            }
        }
    }
    

}
