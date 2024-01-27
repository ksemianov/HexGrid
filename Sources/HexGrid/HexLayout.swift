//
//  HexLayout.swift
//  HexGrid
//
//  Created by Konstantin Semianov on 12/9/22.
//

import SwiftUI

struct HexLayout: Layout {
    func makeCache(subviews: Subviews) -> CGRect {
        let coordinates = subviews.compactMap { $0[OffsetCoordinateLayoutValueKey.self] }

        return hexLayoutNormalizedBounds(coordinates: coordinates)
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CGRect) -> CGSize {
        if cache.isEmpty { return .zero }

        let proposalSize = proposal.replacingUnspecifiedDimensions()
        let cellStep = hexLayoutCellStep(proposal: proposalSize, normalizedSize: cache.size)
        return CGSize(width: cellStep.width * cache.width, height: cellStep.height * cache.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CGRect) {
        if cache.isEmpty { return }

        let proposalSize = proposal.replacingUnspecifiedDimensions()
        let cellStep = hexLayoutCellStep(proposal: proposalSize, normalizedSize: cache.size)
        let cellSize = hexLayoutCellSize(cellStep: cellStep)
        let subviewProposal = ProposedViewSize(width: cellSize.width, height: cellSize.height)

        for subview in subviews {
            guard let coordinate = subview[OffsetCoordinateLayoutValueKey.self] else { continue }

            let cellCenter = hexLayoutCellCenter(coordinate: coordinate, normalizedOrigin: cache.origin, cellStep: cellStep)
            let point = CGPoint(x: bounds.minX + cellCenter.x, y: bounds.minY + cellCenter.y)
            subview.place(at: point, anchor: .center, proposal: subviewProposal)
        }
    }
}

func hexLayoutNormalizedBounds(coordinates: [OffsetCoordinate]) -> CGRect {
    if coordinates.isEmpty { return .zero }

    let normalizedX = coordinates.map { CGFloat($0.col) }
    let normalizedY = coordinates.map { CGFloat($0.row) + 1 / 2 * CGFloat($0.col & 1) }

    let minX: CGFloat = normalizedX.min()!
    let maxX: CGFloat = normalizedX.max()!
    let width = maxX - minX + 4 / 3

    let minY: CGFloat = normalizedY.min()!
    let maxY: CGFloat = normalizedY.max()!
    let height = maxY - minY + 1

    return CGRect(x: CGFloat(minX), y: CGFloat(minY), width: width, height: height)
}

func hexLayoutCellStep(proposal size: CGSize, normalizedSize: CGSize) -> CGSize {
    let scaleX: CGFloat = min(size.width / normalizedSize.width, size.height / normalizedSize.height / Hexagon.aspectRatio)
    return CGSize(width: scaleX, height: scaleX * Hexagon.aspectRatio)
}

func hexLayoutCellSize(cellStep: CGSize) -> CGSize {
    return CGSize(width: cellStep.width * 4 / 3, height: cellStep.height)
}

func hexLayoutCellCenter(coordinate: OffsetCoordinate, normalizedOrigin: CGPoint, cellStep: CGSize) -> CGPoint {
    let normalizedX = CGFloat(coordinate.col) - normalizedOrigin.x + 2 / 3
    let normalizedY = CGFloat(coordinate.row) - normalizedOrigin.y + 1 / 2 * CGFloat(coordinate.col & 1) + 1 / 2
    return CGPoint(x: cellStep.width * normalizedX, y: cellStep.height * normalizedY)
}

struct OffsetCoordinateLayoutValueKey: LayoutValueKey {
    static let defaultValue: OffsetCoordinate? = nil
}
