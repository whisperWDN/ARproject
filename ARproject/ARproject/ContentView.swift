//
//  ContentView.swift
//  ARproject
//
//  Created by whisper on 2022/5/1.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @StateObject var arViewModel = ARViewModel()
    @State var addCube = false
    @State var intensity = CGFloat(0.0)
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(addCube: $addCube, intensity: $intensity).gesture(TapGesture().onEnded(){
                
            })
            
            Button(action: {
                addCube = true
            }, label: {
                Text("放置一个立方体")
            })
                .buttonStyle(.bordered)
                .padding()
            
            Text("Intensity: \(intensity)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
        }
        .environmentObject(arViewModel)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var arViewModel :ARViewModel
    @Binding var addCube: Bool
    @Binding var intensity: CGFloat
    
    func makeUIView(context: Context) -> ARView {
        arViewModel.arView.enableTapGesture()
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if addCube{
            print("add Cube")
//            let boxMesh = MeshResource.generateBox(size: 1)
//            let material = SimpleMaterial(color: .blue, isMetallic: false)
//            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
//            let anchorEntity = AnchorEntity()
//
//            anchorEntity.addChild(modelEntity)
//            arViewModel.arView.scene.addAnchor(anchorEntity)

            do{
                let cup = try ModelEntity.load(named: "cup_saucer_set");
                cup.position.x = -1.0

                let anchorEntity = AnchorEntity()
                
                anchorEntity.addChild(cup)
                arViewModel.arView.scene.addAnchor(anchorEntity)
            }catch{
                
            }
            DispatchQueue.main.async {
                addCube = false
            }

//            let cowAnimationResource = cow.availableAnimations[0]
//            let horseAnimationResource = horse.availableAnimations[0]
//
//            cow.playAnimation(cowAnimationResource.repeat(duration: .infinity),
//                                                transitionDuration: 1.25,
//                                                      startsPaused: false)
//
//            horse.playAnimation(horseAnimationResource.repeat(duration: .infinity),
//                                                    transitionDuration: 0.75,
//                                                          startsPaused: false)
        }
    }
    
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate{
        var parent: ARViewContainer

        init(_ arViewContainer: ARViewContainer){
            parent = arViewContainer
            super.init()
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            if let intensity = frame.lightEstimate?.ambientIntensity{
                parent.intensity = intensity
            }

        }



    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
