//
//  ExerciseView.swift
//  PushUP
//
//  Created by 서준영 on 7/22/25.
//

import SwiftUI
import ARKit
import SceneKit
import AVFoundation

private func checkARSupport() -> Bool {
    return ARFaceTrackingConfiguration.isSupported
}

struct ExerciseView: View {
    let targetCount: Int
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.yellow, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            VStack {
                Text("푸시업을 시작하세요!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 120)
                CountView(targetCount: self.targetCount)
                Spacer()
            }
        }
    }
}

private struct CountView: View {
    @State private var currentCount: Int = 0
    var targetCount: Int
    @State private var showARCamera = false
    
    private var progressValue: Double {
        guard targetCount > 0 else { return 0.0 }
        return Double(currentCount) / Double(targetCount)
    }
    
    var body: some View {
        VStack {
            if ARFaceTrackingConfiguration.isSupported {
                if showARCamera {
                    ARFaceTrackingView(currentCount: $currentCount, targetCount: targetCount)
                        .frame(height: 200)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .onAppear {
                            // 카메라 권한 요청
                            requestCameraPermission()
                        }
                } else {
                    // AR 시작 버튼
                    Button("카메라 시작") {
                        showARCamera = true
                    }
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
            } else {
                Text("이 기기는 TrueDepth 카메라를 지원하지 않습니다.")
                    .foregroundStyle(.red)
                    .padding()
            }
            ZStack {
                Text("\(currentCount) / \(targetCount)")
                    .font(.system(size: 60, weight: .bold))
                    .padding(.top, 20)
                    .padding(.bottom, 140)
                
                if currentCount >= targetCount {
                    Text("완료! 🎉")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .padding()
                }
            }
            
            ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.8, green: 0.1, blue: 0.1)))
                .scaleEffect(x: 1, y: 16)
                .animation(.easeInOut(duration: 0.5), value: progressValue)
                .padding(.horizontal, 30)
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                DispatchQueue.main.async {
                    showARCamera = false
                }
            }
        }
    }
}


#Preview {
    ExerciseView(targetCount: 10)
}
