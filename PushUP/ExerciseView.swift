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
    var restTime: Int
    let targetCount: [Int]
    
    var totalSetNum: Int { targetCount.count }
    @State private var restTimeRemaining: Int = 30
    @State private var currentSetIndex: Int = 0
    @State private var isResting: Bool = false
    @State private var isFinished: Bool = false
    
    init(restTime: Int, targetCount: [Int]) {
        self.restTime = restTime
        self.targetCount = targetCount
        self._restTimeRemaining = State(initialValue: restTime)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.yellow, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            
            VStack {
                Text(isResting ? "휴식 시간입니다!" : "푸시업을 시작하세요!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 120)
                
                if isResting {
                    // 휴식화면
                    RestView(timeRemaining: $restTimeRemaining) {
                        nextSet()
                    }
                } else {
                    if currentSetIndex < targetCount.count {
                        CountView(targetCount: targetCount[currentSetIndex], isFinished: isFinished) { isCompleted in
                            if isCompleted {
                                 startRest()
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    private func startRest() {
        if currentSetIndex < totalSetNum - 1 {
            isResting = true
            restTimeRemaining = restTime
        } else {
            print("모든 세트 완료")
            isFinished = true
        }
    }
    
    private func nextSet() {
        isResting = false
        currentSetIndex += 1
    }
}

private struct RestView: View {
    @Binding var timeRemaining: Int
    let onRestComplete: () -> Void
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("다음 세트까지")
                .font(.headline)
                .padding(30)
            
            Text("\(timeRemaining)초")
                .font(.system(size: 70, weight: .light))
                .foregroundStyle(.yellow)
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                onRestComplete()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

private struct CountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentCount: Int = 0
    @State private var showARCamera = false
    var targetCount: Int
    var isFinished: Bool
    let onSetComplete: (Bool) -> Void
    
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
                    Text(isFinished ? "모든 세션 완료! 🎊" : "이번 세션 완료! 🎉")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                onSetComplete(true)
                            }
                        }
                }
            }
            
            ZStack {
                ProgressView(value: progressValue)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.8, green: 0.1, blue: 0.1)))
                    .scaleEffect(x: 1, y: 16)
                    .animation(.easeInOut(duration: 0.5), value: progressValue)
                    .padding(.horizontal, 30)
                if isFinished {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(.green)
                                .frame(width: 345, height: 64)
                                .cornerRadius(5)
                            
                            Text("홈으로")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
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
//    ExerciseView(targetCount: [10])
}
