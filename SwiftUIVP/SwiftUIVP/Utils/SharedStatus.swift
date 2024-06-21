//
//  SharedStatus.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 21/06/24.
//

import Combine

class SharedStatus: ObservableObject {
    @Published var isOnline: Bool = false
}
