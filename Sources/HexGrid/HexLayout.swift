//
//  HexLayout.swift
//  HexGrid
//
//  Created by Konstantin Semianov on 12/9/22.
//

import SwiftUI

struct HexLayout: Layout {
    struct CacheData {
        let offsetX: Int
        let offsetY: Int
        let width: CGFloat
        let height: CGFloat
    }

    func makeCache(subviews: Subviews) -> CacheData? {
        let coordinates = subviews.compactMap { $0[OffsetCoordinateLayoutValueKey.self] }

        if coordinates.isEmpty { return nil }

        let offsetX = coordinates.map { $0.col }.min()!
        let offsetY = coordinates.map { $0.row }.min()!

        let coordinatesX = coordinates.map { CGFloat($0.col) }
        let minX: CGFloat = coordinatesX.min()!
        let maxX: CGFloat = coordinatesX.max()!
        let width = maxX - minX + 4 / 3

        let coordinatesY = coordinates.map { CGFloat($0.row) + 1 / 2 * CGFloat($0.col & 1) }
        let minY: CGFloat = coordinatesY.min()!
        let maxY: CGFloat = coordinatesY.max()!
        let height = maxY - minY + 1

        return CacheData(offsetX: offsetX, offsetY: offsetY, width: width, height: height)
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData?) -> CGSize {
        guard let cache else { return .zero }

        let size = proposal.replacingUnspecifiedDimensions()
        let step = min(size.width / cache.width, size.height / cache.height / Hexagon.aspectRatio)

        return CGSize(width: step * cache.width, height: step * cache.height * Hexagon.aspectRatio)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData?) {
        guard let cache else { return }

        let size = proposal.replacingUnspecifiedDimensions()
        let step = min(size.width / cache.width, size.height / cache.height / Hexagon.aspectRatio)
        let width = step * 4 / 3
        let proposal = ProposedViewSize(width: width, height: width / Hexagon.aspectRatio)
        let x = width / 2 + bounds.minX
        let y = width / Hexagon.aspectRatio / 2 + bounds.minY

        for subview in subviews {
            guard let coord = subview[OffsetCoordinateLayoutValueKey.self] else { continue }

            let dx: CGFloat = step * CGFloat(coord.col - cache.offsetX)
            let dy: CGFloat = step * Hexagon.aspectRatio * (CGFloat(coord.row - cache.offsetY) + 1 / 2 * CGFloat(coord.col & 1))
            let point = CGPoint(x: x + dx, y: y + dy)

            subview.place(at: point, anchor: .center, proposal: proposal)
        }
    }
}

struct OffsetCoordinateLayoutValueKey: LayoutValueKey {
    static let defaultValue: OffsetCoordinate? = nil
}
