//
//  ContentView.swift
//  Examples
//
//  Created by Konstantin Semianov on 12/9/22.
//

import SwiftUI
import HexGrid

struct HexCell: Identifiable, OffsetCoordinateProviding {
    var id: Int { offsetCoordinate.hashValue }
    var offsetCoordinate: OffsetCoordinate
    var colorName: String
}

struct ContentView: View {
    let cells: [HexCell] = [
        .init(offsetCoordinate: .init(row: 0, col: 0), colorName: "color1"),
        .init(offsetCoordinate: .init(row: 0, col: 1), colorName: "color2"),
        .init(offsetCoordinate: .init(row: 0, col: 2), colorName: "color3"),
        .init(offsetCoordinate: .init(row: 1, col: 0), colorName: "color4"),
        .init(offsetCoordinate: .init(row: 1, col: 1), colorName: "color5")
    ]

    var body: some View {
        HexGrid(cells) { cell in
            Color(cell.colorName)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
