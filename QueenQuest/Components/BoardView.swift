//
//  BoardView.swift
//  QueenQuest
//  
//  Created by Vander on 24/02/26.
//  

import SwiftUI

struct BoardView: View {
    let boardSize: Int
    let queens: Set<Position>
    let conflicts: Set<Position>
    let onTap: (Position) -> Void

    var body: some View {
        GeometryReader { geo in
            let boardWidth = geo.size.width
            let cellWidth = boardWidth / CGFloat(boardSize)

            VStack(spacing: 0) {
                ForEach(0..<boardSize, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<boardSize, id: \.self) { column in
                            let position = Position(row: row, column: column)
                            CellView(
                                isDark: (row + column).isMultiple(of: 2),
                                hasQueen: queens.contains(position),
                                isConflicting: conflicts.contains(position),
                                cellWidth: cellWidth
                            )
                            .frame(width: cellWidth, height: cellWidth)
                            .contentShape(Rectangle())
                            .onTapGesture { onTap(position) }
                        }
                    }
                }
            }
            .frame(width: boardWidth, height: boardWidth)
            .accessibilityElement(children: .contain)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct CellView: View {
    let isDark: Bool
    let hasQueen: Bool
    let isConflicting: Bool
    let cellWidth: CGFloat

    var body: some View {
        let iconSize = max(12, cellWidth * 0.40)
        let padding = max(2, cellWidth * 0.12)
        let stroke = max(1, cellWidth * 0.06)

        ZStack {
            Rectangle()
                .fill(isDark ? Color.gray.opacity(0.6) : Color.gray.opacity(0.2))

            if hasQueen {
                Image(systemName: "crown.fill")
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundStyle(isConflicting ? .red : .primary)
                    .padding(padding)
                    .background(Circle().fill(isConflicting ? Color.red.opacity(0.18) : .clear))
            }

            if isConflicting {
                Rectangle()
                    .inset(by: stroke / 2)
                    .stroke(Color.red.opacity(0.8), lineWidth: stroke)
            }
        }
    }
}
