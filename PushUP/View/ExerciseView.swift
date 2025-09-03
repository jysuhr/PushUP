//
//  ExerciseView.swift
//  PushUP
//
//  Created by 서준영 on 7/22/25.
//

import SwiftUI
import ARKit

struct ExerciseView: View {
    /// ViewModel을 이 View의 상태관리자로 지정한다.
    @StateObject private var viewModel: ExerciseViewModel
    
    init(restTime: Int, targetCount: [Int]) {
        // View가 생성될 때 ViewModel을 초기화한다.
        self._viewModel = StateObject(wrappedValue: ExerciseViewModel(restTime: restTime, targetCount: targetCount))
    }
    
    /*
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
    */
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.yellow, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            
            VStack {
                Text(viewModel.navTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 120)
                
//                if isResting {
//                    // 휴식화면
//                    RestView(timeRemaining: $restTimeRemaining) {
//                        nextSet()
//                    }
//                } else {
//                    if currentSetIndex < targetCount.count {
//                        CountView(targetCount: targetCount[currentSetIndex], isFinished: isFinished) { isCompleted in
//                            if isCompleted {
//                                 startRest()
//                            }
//                        }
//                    }
//                }
                
                /// viewModel의 상태에 따라 다른 View를 보여준다.
                switch viewModel.viewState {
                case .exercising, .finished:
                    CountView(viewModel: viewModel)
                case .resting:
                    RestView(viewModel: viewModel)
                }
                
                Spacer()
            }
        }
    }
    
    /// 변수를 변경하는 함수는 viewModel로 이동
    /*
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
     */
}

private struct RestView: View {
    /// 상위 View로부터 viewModel을 전달받는다.
    @ObservedObject var viewModel: ExerciseViewModel
    
//    @Binding var timeRemaining: Int
//    let onRestComplete: () -> Void
//    @State private var timer: Timer?
//    @State private var isMuted: Bool = false
    
    var body: some View {
        VStack {
            Text("다음 세트까지")
                .font(.headline)
                .padding(30)
            
            /*
            if timeRemaining > 10 {
                Text("\(timeRemaining)초")
                    .font(.system(size: 70, weight: .light))
                    .foregroundStyle(.primary)
            } else if timeRemaining > 5 {
                Text("\(timeRemaining)초")
                    .font(.system(size: 70, weight: .light))
                    .foregroundStyle(.orange)
            } else {
                Text("\(timeRemaining)초")
                    .font(.system(size: 70, weight: .light))
                    .foregroundStyle(.red)
            }
             */
            
            /// viewModel의 데이터를 사용하여 UI를 다시 그린다.
            Text("\(viewModel.restTimeRemaining)초")
                .font(.system(size: 70, weight: .light))
                .foregroundStyle(timerColor) // 색상 로직 분리
            
            Button(action: {
//                isMuted.toggle()
                viewModel.toggleMute()
            }) {
                Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.2.fill")
                    .frame(width: 20, height: 20)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .background(viewModel.isMuted ? .red : .clear)
                    .clipShape(Circle())
            }
            .padding(.top, 80)
            
        }
    }
    
    /// UI 로직은 View에 남겨놓는다.
    private var timerColor: Color {
        if viewModel.restTimeRemaining > 10 { .primary }
        else if viewModel.restTimeRemaining > 5 { .orange }
        else { .red }
    }
    
    /// 함수는 viewModel로 이동
    /*
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 1 {
                timeRemaining -= 1
                palyTickSound(timeRemaining)
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
    
    private func palyTickSound(_ timeRemaining: Int) {
        guard !isMuted else { return }
        if timeRemaining <= 10 && timeRemaining > 5 {
            AudioServicesPlaySystemSound(1057)
        } else if timeRemaining <= 5 && timeRemaining >= 0 {
            AudioServicesPlaySystemSound(1052)
        }
    }
     */
}

private struct CountView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ExerciseViewModel
    
    /*
    @State private var currentCount: Int = 0
    @State private var showARCamera = false
    var targetCount: Int
    var isFinished: Bool
    let onSetComplete: (Bool) -> Void
    
    private var progressValue: Double {
        guard targetCount > 0 else { return 0.0 }
        return Double(currentCount) / Double(targetCount)
    }
     */
    
    var body: some View {
        VStack {
            if ARFaceTrackingConfiguration.isSupported {
                if viewModel.showARCamera {
                    ARFaceTrackingView(currentCount: $viewModel.currentCount, targetCount: viewModel.currentTargetCount)
                        .frame(height: 200)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
//                        .onAppear {
//                            // 카메라 권한 요청
//                            requestCameraPermission()
//                        }
                        .onChange(of: viewModel.currentCount) { _ in
                            viewModel.onCountChanged()
                        }
                } else {
                    // AR 시작 버튼
                    Button("카메라 시작") {
//                        showARCamera = true
                        viewModel.startARSession()
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
            
            Text("\(viewModel.currentCount) / \(viewModel.currentTargetCount)")
                .font(.system(size: 60, weight: .bold))
                .padding(.top, 20)
                .padding(.bottom, 140)
            
            ZStack {
                ProgressView(value: viewModel.progressValue)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.8, green: 0.1, blue: 0.1)))
                    .scaleEffect(x: 1, y: 16)
                    .animation(.easeInOut(duration: 0.5), value: viewModel.progressValue)
                    .padding(.horizontal, 30)
                
                if viewModel.viewState == .finished {
                    Button(action: { dismiss() }) {
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
}

#Preview {
    ExerciseView(restTime: 3, targetCount: [10])
}
