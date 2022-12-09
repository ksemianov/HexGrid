//
//  Hexagon.swift
//  HexGrid
//
//  Created by Konstantin Semianov on 12/9/22.
//

import SwiftUI

/// A hexagonal shape aligned inside the frame of the view containing it in a flat-top orientation.
public struct Hexagon: Shape {
    /// The ratio of hexagon width to height.
    public static let aspectRatio: CGFloat = 2 / sqrt(3)

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = min(rect.width, rect.height * Self.aspectRatio)
        let size = width / 2
        let corners = (0..<6)
            .map {
                let angle = -CGFloat.pi / 3 * CGFloat($0)
                let dx = size * cos(angle)
                let dy = size * sin(angle)

                return CGPoint(x: center.x + dx, y: center.y + dy)
            }

        path.move(to: corners[0])
        corners[1..<6].forEach { point in
            path.addLine(to: point)
        }

        path.closeSubpath()

        return path
    }

    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        let size = proposal.replacingUnspecifiedDimensions(by: .infinity)

        let width = min(size.width, size.height * Self.aspectRatio)
        let height = width / Self.aspectRatio

        return CGSize(width: width, height: height)
    }

    /// Creates a new hexagon shape.
    public init() {}
}

extension CGSize {
    static var infinity: Self {
        CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
    }
}

struct Hexagon_Previews: PreviewProvider {
    static var previews: some View {
        Hexagon()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
