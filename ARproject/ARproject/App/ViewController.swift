//
//  ViewController.swift
//  ARproject
//
//  Created by admin on 2022/5/15.
//

import UIKit
import RealityKit

class ViewController:UIViewController{
    @IBOutlet var arView:ARView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let anchor = AnchorEntity(plane:.horizontal,minimumBounds:[0.2,0.2])
        arView.scene.addAnchor(anchor)
    }
    
}
