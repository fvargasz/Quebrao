//
//  QCategory.swift
//  Quebrao
//
//  Created by Francisco Vargas on 2/4/25.
//

import SwiftUI

struct CategoryExpense: Identifiable {
    let id = UUID()
    let type: String
    let amount: Double
}
