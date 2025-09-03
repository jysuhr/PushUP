//
//  PresetView.swift
//  PushUP
//
//  Created by 서준영 on 7/26/25.
//

import SwiftUI

struct PresetView: View {
    @StateObject private var viewModel = PresetViewModel()
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("세션 목표를 선택하세요")
                .font(.title2)
                .fontWeight(.bold)
                .padding(50)
            ForEach(viewModel.presets) { preset in
                PresetButton(contentViewModel: contentViewModel, preset: preset)
            }
        }
    }
}

private struct PresetButton: View {
    @ObservedObject var contentViewModel: ContentViewModel
    let preset: Preset
    
    var body: some View {
        NavigationLink(destination: ExerciseView(restTime: contentViewModel.restTime, targetCount: preset.sets)) {
            HStack(spacing: 0) {
                ForEach(Array(preset.sets.enumerated()), id: \.offset) { index, setCount in
                    PresetCircle(num: setCount)
                    if index < preset.sets.count - 1 {
                        PresetDivider()
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}

private struct PresetCircle: View {
    let height: CGFloat = 50
    let num: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: height, height: height)
            Text("\(num)")
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(.white)
        }
    }
}

private struct PresetDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 18, height: 2)
            .foregroundStyle(.white.opacity(0.6))
    }
}


#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.8, blue: 0.8),
                     Color(red: 0.4, green: 0.4, blue: 0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(.all)
        
//        PresetView(contentViewModel: )
    }
}

/**
 - Preset Model 형식에 맞는 데이터를 ViewModel에서 가져옴으로써 하드코딩을 제거했다.
 - ForEach를 이용해서 뷰를 그림 --> 동적인 뷰가 가능해졌다.
 */

/**
 # 문제
 - SettingView에서 restTime을 수정해도 쉬는 시간이 40초로 고정되는 문제
 - ContnetViewModel을 직접 관찰하여 restTime을 받아오면 될것이라 생각했다.
 - @StateObject로 contentViewModel을 관찰하도록 했다.
 - 완전히 새로운 ContentViewModel이 생성됨으로써 settingView에서 수정한 restTime 값이 반영되지 않았다.
 - Single Souce of Truth에 위배되었다.
 
 # 해결 법
 - PresetVeiw의 상위 View인 ContentView로부터 ViewModel을 전달받아야 한다.
 - @ObservedObject로 ContentVeiw에서 생성된 ContnetViewModel을 전달 받는다.
 - restTime을 제공하는 원천인 ContnetViewModel을 유일하게 하여 SSoT를 준수한다.
 */
