//
//  ExerciseViewModel.swift
//  PushUP
//
//  Created by 서준영 on 8/14/25.
//

import Foundation
import UIKit
import AudioToolbox
import AVFoundation

enum ViewState {
    case exercising
    case resting
    case finished
}

class ExerciseViewModel: ObservableObject {
    /// View에 표시될 상태 (State)
    @Published var currentSetIndex: Int = 0
    @Published var currentCount: Int = 0
    @Published var restTimeRemaining: Int
    @Published var viewState: ViewState = .exercising
    @Published var isMuted: Bool = false
    
    /// UI와 직접 관련 없는 내부 상태 및 로직
    private let targetCountPreset: [Int]
    private let initialRestTime: Int
    private var timer: Timer?
    
    init(restTime: Int, targetCount: [Int]) {
        self.initialRestTime = restTime
        self.targetCountPreset = targetCount
//        self._restTimeRemaining = Published(initialValue: restTime)
        self.restTimeRemaining = restTime
    }
    
    deinit {
        timer?.invalidate()
    }
    
    /// View에서 사용할 계산된 프로퍼티
    var totalSetCount: Int { targetCountPreset.count }
    var currentTargetCount: Int {
        guard currentSetIndex < totalSetCount else { return 0 }
        return targetCountPreset[currentSetIndex]
    }
    var progressValue: Double {
        guard currentTargetCount > 0 else { return 0.0 }
        return Double(currentCount) / Double(currentTargetCount)
    }
    var navTitle: String {
        switch viewState {
        case .exercising:
            return "푸시업을 시작하세요!"
        case .resting:
            return "휴식 시간입니다!"
        case .finished:
            return "모든 세션을 완료했습니다! 🎊"
        }
    }
    
    func onCountChanged() {
        guard currentCount >= currentTargetCount  else { return }
        completeSet()
    }
    
    func finishRest() {
        stopTimer()
        currentSetIndex += 1
        currentCount = 0 // 카운트 초기화
        viewState = .exercising
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
    
    // AR 관련 로직
    @Published var showARCamera = false
    
    func startARSession() {
        requestCameraPermission { [weak self] granted in
            if granted {
                self?.showARCamera = true
            }
        }
    }
}


extension ExerciseViewModel {
    private func completeSet() {
        // 마지막 세트인지 확인
        if currentSetIndex >= totalSetCount - 1 {
            viewState = .finished
            UIApplication.shared.isIdleTimerDisabled = false // 화면 꺼짐 방지 해제
        } else {
            startRest()
        }
    }
    
    private func startRest() {
        viewState = .resting
        restTimeRemaining = initialRestTime
        startTimer()
    }
    
    // 타이머 로직
    private func startTimer() {
        // 화면이 꺼지지 않도록 설정
        UIApplication.shared.isIdleTimerDisabled = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.restTimeRemaining > 1 {
                self.restTimeRemaining -= 1
                self.playTickSound(self.restTimeRemaining)
            } else {
                self.finishRest()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        // 화면 꺼짐 방지 해제
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func playTickSound(_ time: Int) {
        guard !isMuted else { return }
        if time <= 10 && time > 5 {
            AudioServicesPlaySystemSound(SystemSoundID(1057))
        } else if time <= 5 && time >= 0 {
            AudioServicesPlaySystemSound(SystemSoundID(1052))
        }
    }
    
    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
