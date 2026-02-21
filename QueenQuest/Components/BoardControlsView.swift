//
//  BoardControlsView.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import SwiftUI

struct BoardControlsView: View {
    private let sizes: [Int] = Array(4...10)

    let boardSize: Int
    let onChangeSize: (Int) -> Void
    let onRestart: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("Board:")

            Picker("Board Size", selection: boardSizeBinding) {
                ForEach(sizes, id: \.self) { size in
                    Text("\(size)x\(size)").tag(size)
                }
            }
            .pickerStyle(.menu)

            Spacer()

            Button("Restart") { onRestart() }
        }
        .padding(.horizontal)
    }

    private var boardSizeBinding: Binding<Int> {
        Binding(
            get: { boardSize},
            set: { onChangeSize($0) }
        )
    }
}
