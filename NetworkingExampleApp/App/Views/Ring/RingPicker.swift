import SwiftUI

struct RingPicker: View {
  @Binding var selectedRing: UUID
  let rings: [Ring]

    var body: some View {
      VStack {
        Picker("Ring:", selection: $selectedRing) {
          ForEach(rings) {
            Text($0.name).tag($0.id)
          }
        }
        .pickerStyle(.menu)
      }
    }
}

struct RingPicker_Previews: PreviewProvider {
    static var previews: some View {
      RingPicker(
        selectedRing: .constant(MockRing().ring.id),
        rings: [
          Ring(id: UUID(), name: "Dummy", languages: nil),
          Ring(id: UUID(), name: "Other", languages: nil),
          MockRing().ring
        ]
      )
    }
}
