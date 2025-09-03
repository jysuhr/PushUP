//
//  Preset.swift
//  PushUP
//
//  Created by 서준영 on 9/3/25.
//

import Foundation

struct Preset: Identifiable {
    let id = UUID()
    let name: String
    let sets: [Int]
}
