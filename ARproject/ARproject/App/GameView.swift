//
//  GameView.swift
//  ARproject
//
//  Created by admin on 2022/5/15.
//

import SwiftUI
struct GameView:UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
    
    
    typealias UIViewControllerType = ViewController


}
