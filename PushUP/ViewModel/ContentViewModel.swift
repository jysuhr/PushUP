//
//  ContentViewModel.swift
//  PushUP
//
//  Created by 서준영 on 8/14/25.
//

import Foundation
import AVFoundation

/// ViewModel은 ObservableObject 프로토콜을 채택하여 다른 구조체가 볼 수 있도록 한다.
/// ViewModel을 보고있는 View는 ViewModel의 데이터 변화를 바로 감지할 수 있다.
class ContentViewModel: ObservableObject {
    /// @Published는 View가 데이터 변화를 감지하여 View를 새로 그리도록 한다.
    @Published var count: Int = 0
    @Published var isMuted: Bool = false
    @Published var restTime: Int = initialRestTime // 초기 휴식시간 설정
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    /// View에서 상황에 따라 요청하는 메소드
    
    func incrementCount() {
        count += 1
        speakCount()
    }
    
    func decrementCount() {
        if count > 0 {
            count -= 1
            speakCount()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    /// speakCount() 메소드는 외부에서 호출할 수 없도록 private 처리한다.
    private func speakCount() {
        /// isMuted를 speakCount() 메소드 내부에서 검사후 빠른 return을 시킨다.
        guard !isMuted else { return }
        
        // 현재 재생 중인 음성을 중단
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: "\(count)개")
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR") // 한국어 음성
        utterance.rate = 0.5 // 말하기 속도 (0.0 ~ 1.0)
        utterance.volume = 1.0 // 음량
        
        speechSynthesizer.speak(utterance)
    }
}
