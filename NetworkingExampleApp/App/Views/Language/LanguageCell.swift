import SwiftUI

struct LanguageCell: View {
  var languageName: String

  var body: some View {
    HStack(spacing: 20) {
      Image(systemName: "rectangle.3.group.bubble.left.fill")
        .resizable()
        .frame(width: 30, height: 30)
      VStack(alignment: .leading) {
        Text(languageName)
          .kerning(2)
          .bold()
          .foregroundColor(Color(UIColor(named: "LabelColor")!))
      }
    }
  }
}

struct LanguageCell_Previews: PreviewProvider {
  static var previews: some View {
    LanguageCell(languageName: "Dummy")
  }
}
