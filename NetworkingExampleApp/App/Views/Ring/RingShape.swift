import SwiftUI

struct RingShape: View {
  let color: UIColor

  var body: some View {
    let gradient = AngularGradient(
      gradient: Gradient(
        colors: [
          Color(UIColor(named: "LabelColor")!),
          Color(color)
        ]),
      center: .center,
      startAngle: .degrees(0),
      endAngle: .degrees(360)
    )
    Circle()
      .trim(from: 0.05, to: 0.95)
      .stroke(gradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
      .frame(width: 20, height: 20, alignment: .center)
  }
}

struct RingShape_Previews: PreviewProvider {
  static var previews: some View {
    RingShape(color: UIColor(named: "GreenColor")!)
  }
}
