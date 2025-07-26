//
//  ContentView.swift
//  PushUP
//
//  Created by 서준영 on 7/20/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var count = 0
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var isMuted: Bool = false
    @State private var borderProgress: CGFloat = 0.0
    @State private var restTime: Int = 30
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.2, green: 0.8, blue: 0.8),
                             Color(red: 0.4, green: 0.4, blue: 0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                TitleView()
                
                TabView {
                    VStack(spacing: 0) {
                        CountView(count: $count,
                                  isMuted: $isMuted,
                                  speechSynthesizer: speechSynthesizer)
                        
                        ButtonView(count: $count,
                                   isMuted: $isMuted,
                                   restTime: $restTime,
                                   speechSynthesizer: speechSynthesizer)
                        
                        Spacer()
                    }
                    
                    PresetView(restTime: $restTime)
                    
                    SettingView(restTime: $restTime)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
            }
        }
    }
}

private struct TitleView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Push UP")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.leading, 30)
                Spacer()
            }
            Spacer()
        }
    }
}

private struct CountView: View {
    @Binding var count: Int
    @Binding var isMuted: Bool
    let speechSynthesizer: AVSpeechSynthesizer
    
    var body: some View {
        VStack {
            Text("이번 푸시업 목표는?")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 150)
                .padding(.bottom, 50)
            HStack {
                Text("\(count)")
                    .font(.system(size: 45, weight: .bold))
                Text("개")
                    .font(.system(size: 32, weight: .medium))
            }
            .padding(.bottom, 60)
            
            HStack(spacing: 0) {
                Button(action: {
                    if (count > 0) {
                        count -= 1
                    }
                    if (!isMuted) {
                        speakCount()
                    }
                }) {
                    Text("감소")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 5)
                
                Button(action: {
                    count += 1
                    if (!isMuted) {
                        speakCount()
                    }
                }) {
                    Text("증가")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(.ultraThinMaterial)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 5)
            }
            .padding(.top, 5)
        }
    }
    
    private func speakCount() {
        // 현재 재생 중인 음성을 중단
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: "\(count)개")
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR") // 한국어 음성
        utterance.rate = 0.5 // 말하기 속도 (0.0 ~ 1.0)
        utterance.volume = 1.0 // 음량
        
        speechSynthesizer.speak(utterance)
    }
}

private struct ButtonView: View {
    @Binding var count: Int
    @Binding var isMuted: Bool
    @Binding var restTime: Int
    let speechSynthesizer: AVSpeechSynthesizer
    
    var body: some View {
        NavigationLink(destination: ExerciseView(restTime: restTime, targetCount: [count])) {
            Text("운동 시작!")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold))
                .frame(width: 155, height: 50)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
                .background(.blue)
                .cornerRadius(10)
        }
        .disabled(count <= 0)
        .padding(.top, 10)
        
        Button(action: {
            isMuted.toggle()
            
            if isMuted {
               speechSynthesizer.stopSpeaking(at: .immediate)
            }
        }) {
            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.2.fill")
                .frame(width: 20, height: 20)
                .font(.title2)
                .foregroundColor(.white)
                .padding(20)
                .background(.ultraThinMaterial)
                .background(isMuted ? .red : .clear)
                .clipShape(Circle())
        }
        .padding(.top, 80)
        .padding(.bottom, 100)
    }
}


#Preview {
    ContentView()
}
