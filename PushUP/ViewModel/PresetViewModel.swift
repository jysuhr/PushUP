//
//  PresetViewModel.swift
//  PushUP
//
//  Created by 서준영 on 9/3/25.
//

import Foundation

class PresetViewModel: ObservableObject {
    @Published var presets: [Preset] = []
    
    init() {
        // ViewModel이 생성될 때 프리셋 데이터 로드
        loadPresets()
    }
    
    private func loadPresets() {
        self.presets = [
            Preset(name: "Beginner A", sets: [2, 2, 3, 2, 2]),
            Preset(name: "Beginner B", sets: [2, 2, 3, 3, 2]),
            Preset(name: "Intermediate A", sets: [2, 3, 4, 3, 2]),
            Preset(name: "Intermediate B", sets: [2, 3, 4, 4, 2]),
            Preset(name: "Hard", sets: [4, 5, 6, 5])
        ]
    }
}
