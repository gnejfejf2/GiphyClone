import UIKit
// 1
class Section: Hashable {
  var id = UUID()
  // 2
  var section: SectionEnum
  var items: [Any]
  
  init(section: SectionEnum, items : [Any]) {
    self.section = section
    self.items = items
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Section, rhs: Section) -> Bool {
    lhs.id == rhs.id
  }
}



extension Section {
  static var allSections: [Section] = [
    Section(section: .trending, items: []),
    Section(section: .recent, items: []),
    Section(section: .most, items: [])
  ]
}
