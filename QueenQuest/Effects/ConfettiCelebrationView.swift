//
//  ConfettiView.swift
//  QueenQuest
//  
//  Created by Vander on 25/02/26.
//  

import SwiftUI
import UIKit

struct ConfettiCelebrationView: UIViewRepresentable {
    private static let emissionStopDelay: Duration = .seconds(1)
    private let isActive: Bool

    init(isActive: Bool) {
        self.isActive = isActive
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.stopEmitterTask?.cancel()
        context.coordinator.stopEmitterTask = nil

        uiView.layer.sublayers?.removeAll(where: { $0.name == "confetti" })
        guard isActive else { return }

        let emitter = CAEmitterLayer()
        emitter.name = "confetti"
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: uiView.bounds.midX, y: -10)
        emitter.emitterSize = CGSize(width: uiView.bounds.width, height: 1)

        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow]

        emitter.emitterCells = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 6
            cell.velocity = 180
            cell.velocityRange = 80
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3
            cell.spinRange = 4
            cell.scale = 0.6
            cell.scaleRange = 0.3
            cell.contents = particleImage(color: color).cgImage
            return cell
        }

        uiView.layer.addSublayer(emitter)

        context.coordinator.stopEmitterTask = Task { @MainActor in
            try? await Task.sleep(for: Self.emissionStopDelay)
            guard !Task.isCancelled else { return }
            emitter.birthRate = 0
            context.coordinator.stopEmitterTask = nil
        }
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.stopEmitterTask?.cancel()
        coordinator.stopEmitterTask = nil
        uiView.layer.sublayers?.removeAll(where: { $0.name == "confetti" })
    }

    private func particleImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 10, height: 6)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.cgContext.fill(CGRect(origin: .zero, size: size))
        }
    }

    final class Coordinator {
        var stopEmitterTask: Task<Void, Never>?
    }
}
