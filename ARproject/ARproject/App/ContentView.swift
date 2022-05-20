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
    @State var addEntity = false
    @State var add3DWord = false
    @State var EntityName = ""
    @State var intensity = CGFloat(0.0)
    @State var showingList = false
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(addEntity: $addEntity, EntityName:$EntityName,add3DWord:$add3DWord, intensity: $intensity).gesture(TapGesture().onEnded(){
                
            })
            

            HStack{
                if showingList{
                    AddEntityList(addEntity: $addEntity, EntityName: $EntityName,showingList:$showingList)
                }else {
                    Button(action: {
                        showingList = true
                    }, label: {
                        Image(systemName: "chevron.right.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75, alignment: .center)
                            .clipShape(Circle())
                            .opacity(0.5)
                    })
                }
                
                Button(action: {
                    add3DWord = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75, alignment: .center)
                        .foregroundColor(.white)
                        .opacity(0.5)
                })
                

            }




        }
        .environmentObject(arViewModel)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var arViewModel :ARViewModel
    @Binding var addEntity: Bool
    @Binding var EntityName: String
    @Binding var add3DWord :Bool
    @Binding var intensity: CGFloat
    
    
    func makeUIView(context: Context) -> ARView {
//        arViewModel.arView.enableTapGesture()
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if addEntity{
            do{
                let entity = try ModelEntity.load(named:EntityName);
                let modelEntity = ModelEntity()
                entity.generateCollisionShapes(recursive: true)
                arViewModel.arView.installGestures([.translation],for:modelEntity)
                modelEntity.addChild(entity)
                let anchorEntity = AnchorEntity()
                anchorEntity.addChild(modelEntity)
                arViewModel.arView.scene.addAnchor(anchorEntity)
            }catch{
                let boxMesh = MeshResource.generateBox(size: 0.1)
                let material = SimpleMaterial(color: .blue, isMetallic: false)
                let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
                modelEntity.generateCollisionShapes(recursive: true)
                arViewModel.arView.installGestures([.translation],for: modelEntity)
                let anchorEntity = AnchorEntity()
                anchorEntity.addChild(modelEntity)
                arViewModel.arView.scene.addAnchor(anchorEntity)
            }

            DispatchQueue.main.async {
                addEntity = false
            }
        }
        
        if add3DWord{
            let anchorEntity = AnchorEntity(plane: .horizontal)
            let textMesh = MeshResource.generateText("桌面设计",extrusionDepth: 0.05,font: .systemFont(ofSize: 0.2),containerFrame: CGRect(),alignment: .left,lineBreakMode: .byWordWrapping)
            let material = SimpleMaterial(color: .red, isMetallic: true)
            let textEntity = ModelEntity(mesh: textMesh, materials: [material])
            textEntity.generateCollisionShapes(recursive: false)
            arViewModel.arView.installGestures([.translation],for: textEntity)
            
            anchorEntity.addChild(textEntity)
            arViewModel.arView.scene.addAnchor(anchorEntity)
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
