//
//  PresetView.swift
//  PushUP
//
//  Created by 서준영 on 7/26/25.
//

import SwiftUI

struct PresetView: View {
    var count: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Text("목표를 선택하세요")
                .font(.title2)
                .fontWeight(.bold)
                .padding(50)
            PresetButton(set1: 2, set2: 2, set3: 3, set4: 2, set5: 2)
            PresetButton(set1: 2, set2: 2, set3: 3, set4: 3, set5: 2)
            PresetButton(set1: 2, set2: 3, set3: 4, set4: 3, set5: 2)
            PresetButton(set1: 2, set2: 3, set3: 4, set4: 4, set5: 2)
        }
    }
}

private struct PresetButton: View {
    let set1: Int
    let set2: Int
    let set3: Int
    let set4: Int
    let set5: Int
    
    var body: some View {
        Button(action: {
            print("버튼 눌림")
        }) {
            HStack(spacing: 0) {
                PresetCircle(num: set1)
                PresetDivider()
                PresetCircle(num: set2)
                PresetDivider()
                PresetCircle(num: set3)
                PresetDivider()
                PresetCircle(num: set4)
                PresetDivider()
                PresetCircle(num: set5)
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
                .foregroundStyle(.primary)
        }
    }
}

private struct PresetDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 18, height: 2)
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
        
        PresetView()
    }
}
