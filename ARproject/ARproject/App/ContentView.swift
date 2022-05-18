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
    @State var addCup = false
    @State var intensity = CGFloat(0.0)
    @State var showingList = false
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(addCube: $addCube, addCup:$addCup,intensity: $intensity).gesture(TapGesture().onEnded(){
                
            })
            
//            Button(action: {
//                addCube = true
//            }, label: {
//                Text("放置一个立方体")
//            })
//                .buttonStyle(.bordered)
//                .padding()
//            if showingList{
//
//            }else {
//                HStack{
//                    List(){
//
//                    }
//                }
//            }
            Button(action: {
                addCup = true
            }, label: {
                Text("放置一个杯子")
            })
                .buttonStyle(.bordered)
                .padding()
            
        }
        .environmentObject(arViewModel)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var arViewModel :ARViewModel
    @Binding var addCube: Bool
    @Binding var addCup: Bool
    @Binding var intensity: CGFloat
    
    func makeUIView(context: Context) -> ARView {
        arViewModel.arView.enableTapGesture()
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if addCube{
            self.placeCube()
        }
        if addCup{
            self.placeCup()
        }
    }
    
    func placeCube(){
        print("add Cube")
        let boxMesh = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
        modelEntity.generateCollisionShapes(recursive: true)
        arViewModel.arView.installGestures([.translation],for: modelEntity)
        let anchorEntity = AnchorEntity(plane:.horizontal,classification:.table)
        anchorEntity.addChild(modelEntity)
        arViewModel.arView.scene.addAnchor(anchorEntity)

        DispatchQueue.main.async {
            addCube = false
        }
    }
    func placeCup(){
        print("add Cup")
        do{
            let cup = try Entity.load(named: "cup_saucer_set");
            let modelEntity = ModelEntity()
            cup.generateCollisionShapes(recursive: true)
            arViewModel.arView.installGestures([.translation],for:modelEntity)
            modelEntity.addChild(cup)
            let anchorEntity = AnchorEntity(plane: .horizontal,classification: .table)
            anchorEntity.addChild(modelEntity)
            arViewModel.arView.scene.addAnchor(anchorEntity)
        }catch{
            
        }


        DispatchQueue.main.async {
            addCup = false
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