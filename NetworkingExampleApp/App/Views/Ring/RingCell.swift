import SwiftUI

struct RingCell: View {
  var name: String
  var color: UIColor

  var body: some View {
    HStack(spacing: 20) {
      RingShape(color: color)
      Text(name)
        .kerning(2)
        .bold()
        .foregroundColor(Color(UIColor(named: "LabelColor")!))
    }
  }
}

struct RingCell_Previews: PreviewProvider {
  static var previews: some View {
    RingCell(name: "Dummy", color: UIColor(named: "GreenColor")!)
  }
}
