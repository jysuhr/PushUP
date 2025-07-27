//
//  ARFaceTrackingView.swift
//  PushUP
//
//  Created by 서준영 on 7/23/25.
//

import ARKit
import SwiftUI

struct ARFaceTrackingView: UIViewRepresentable {
    @Binding var currentCount: Int
    let targetCount: Int
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        
        // AR 세션 설정
        let configuration = ARFaceTrackingConfiguration()
        if ARFaceTrackingConfiguration.isSupported {
            arView.session.run(configuration)
            arView.delegate = context.coordinator
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
//        context.coordinator.currentCount = currentCount
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(currentCount: $currentCount, targetCount: targetCount)
    }
    
    private func playCountSound() {
        AudioServicesPlaySystemSound(1057) // 클릭 사운드
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        @Binding var currentCount: Int
        let targetCount: Int
        var audioPlayer: AVAudioPlayer?
        
        // 간단한 카운팅을 위한 변수들
        private var lastDistance: Float = 0.0
        private var hasCountedRecently = false
        private let countThreshold: Float = 0.20  // 18cm 기준
        private let resetThreshold: Float = 0.25  // 25cm 이상 멀어지면 리셋
        
        init(currentCount: Binding<Int>, targetCount: Int) {
            self._currentCount = currentCount
            self.targetCount = targetCount
            super.init()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            
            // 얼굴의 Z축 거리 (카메라로부터의 거리)
            let position = node.position
            let currentDistance = sqrt(position.x * position.x +
                                     position.y * position.y +
                                     position.z * position.z)
//            print("Face Distance: \(String(format: "%.4f", currentDistance))m")
            
            DispatchQueue.main.async {
                self.checkPushUpCount(distance: currentDistance)
            }
        }
        
        private func checkPushUpCount(distance: Float) {
            // 0.18m보다 가까워지면 카운트 (중복 카운트 방지 포함)
            if distance < countThreshold && !hasCountedRecently && currentCount < targetCount {
                currentCount += 1
                hasCountedRecently = true
                
                // 햅틱 피드백
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                // 사운드 피드백
                AudioServicesPlaySystemSound(1057) // 클릭 사운드
            }
            
            // 25cm 이상 멀어지면 다시 카운트 가능하도록 리셋
            if distance > resetThreshold {
                hasCountedRecently = false
            }
            
            lastDistance = distance
        }
    }
}
