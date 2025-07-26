//
//  SettingView.swift
//  PushUP
//
//  Created by 서준영 on 7/26/25.
//

import SwiftUI
import Combine

struct SettingView: View {
    @Binding var restTime: Int
    
    @State private var restTimeString: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isTextFieldFocused = false
                }
            
            VStack {
                Text("설정")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 180)
                
                Spacer()
            }
            
            HStack {
                Text("세션간 휴식시간")
                    .font(.system(size: 20))
                    .padding(.trailing, 30)
                
                TextField("30", text: $restTimeString)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($isTextFieldFocused)
                    .onReceive(Just(restTimeString)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.restTimeString = filtered
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("완료") {
                                isTextFieldFocused = false
                                restTime = Int(restTimeString) ?? 30
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                    )
                    .frame(width: 60)
                
                Text("초")
                    .font(.system(size: 20))
            }
        }
    }
}

#Preview {
//    SettingView(restTime: 30)
}
