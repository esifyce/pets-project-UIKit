

import Foundation

struct Day {
    // Date represetnts a given day in a month
    let date: Date
    // The number to display on the collection view cell
    let number: String
    // Keeps track of whether this date isSelected
    let isSelected: Bool
    // Tracks if this date is within the currently-viewed month
    let isWithinDisplayedMonth: Bool
}
