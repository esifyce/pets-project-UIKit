

import Foundation

class ChecklistItem: Hashable {
  var id: UUID
  var title: String
  var date: Date
  var completed: Bool

  init(title: String, date: Date, completed: Bool = false) {
    self.id = UUID()
    self.title = title
    self.date = date
    self.completed = completed
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
    return lhs.id == rhs.id
  }
}

extension ChecklistItem {
  static var exampleItems: [ChecklistItem] = [
    ChecklistItem(title: "Complete the Diffable Data Sources tutorial on raywenderlich.com", date: Date())
  ]
}
