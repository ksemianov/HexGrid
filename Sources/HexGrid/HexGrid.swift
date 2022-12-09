//
//  HexGrid.swift
//  HexGrid
//
//  Created by Konstantin Semianov on 12/9/22.
//

import SwiftUI

/// A view that arranges its subviews in a hexagonal grid.
public struct HexGrid<Data, ID, Content>: View where Data: RandomAccessCollection, Data.Element: OffsetCoordinateProviding, ID: Hashable, Content: View {
    /// The collection of underlying identified data that SwiftUI uses to create views dynamically.
    public let data: Data

    /// The  key path to get a stable identity for an element of data.
    public let id: KeyPath<Data.Element, ID>

    /// The spacing between neighbor subviews in a grid.
    public let spacing: CGFloat

    /// The function to create content on demand using the underlying data.
    public let content: (Data.Element) -> Content

    /// Creates a hex grid with the given data, id, spacing and content.
    ///
    /// - Parameters:
    ///   - data: The collection of underlying identified data that SwiftUI uses to create views dynamically.
    ///   - id: The  key path to get a stable identity for an element of data.
    ///   - spacing: The spacing between neighbor subviews in a grid.
    ///   - content: The function to create content on demand using the underlying data.
    @inlinable public init(_ data: Data,
                           id: KeyPath<Data.Element, ID>,
                           spacing: CGFloat = .zero,
                           @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.spacing = spacing / 2
        self.content = content
    }

    public var body: some View {
        HexLayout {
            ForEach(data, id: id) { element in
                content(element)
                    .clipShape(Hexagon())
                    .padding(.all, spacing)
                    .layoutValue(key: OffsetCoordinateLayoutValueKey.self,
                                 value: element.offsetCoordinate)
            }
        }
    }
}

public extension HexGrid where ID == Data.Element.ID, Data.Element: Identifiable {
    /// Creates a hex grid with the given data, spacing and content.
    ///
    /// - Note: The `id` is based on the `Data.Element` conformance to `Identifiable`.
    ///
    /// - Parameters:
    ///   - data: The collection of underlying identified data that SwiftUI uses to create views dynamically.
    ///   - spacing: The spacing between neighbor subviews in a grid.
    ///   - content: The function to create content on demand using the underlying data.
    @inlinable init(_ data: Data,
                    spacing: CGFloat = .zero,
                    @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.id, spacing: spacing, content: content)
    }
}
