//
//  OffsetCoordinate.swift
//  HexGrid
//
//  Created by Konstantin Semianov on 12/9/22.
//

import Foundation

/// A value representing a position in a hexagonal grid.
public struct OffsetCoordinate: Hashable, Equatable, Codable {
    /// The row in a hexagonal grid.
    public var row: Int

    /// The column in a hexagonal grid.
    public var col: Int

    /// Creates an offset coordinate with the given row and column.
    ///
    /// - Parameters:
    ///   - row: The row in a hexagonal grid.
    ///   - col: The column in a hexagonal grid.
    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

/// A type with a position in a hexagonal grid.
public protocol OffsetCoordinateProviding {
    /// The position in a hexagonal grid.
    var offsetCoordinate: OffsetCoordinate { get }
}
