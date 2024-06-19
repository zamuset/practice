//
//  Int+Extension.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

extension Int {
    func formatedDuration() -> String {
        let hours = self / 3600
        let minutes = (self / 60) % 60
        let seconds = self % 60
        if hours > 0 { return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds) }
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
