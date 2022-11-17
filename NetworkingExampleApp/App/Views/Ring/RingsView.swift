import SwiftUI

struct RingsView: View {
  @StateObject var viewModel: RingsViewModel

  private let colors = [
    UIColor(named: "GreenColor")!,
    UIColor(named: "YellowColor")!,
    UIColor(named: "BlueColor")!,
    UIColor(named: "RedColor")!
  ]

  var body: some View {
    VStack {
      List {
        ForEach(Array(viewModel.rings.enumerated()), id: \.offset) { index, ring in
          NavigationLink(destination: RingDetailView(viewModel: viewModel.generateViewModel(ring: ring))) {
            RingCell(name: ring.name, color: chooseColor(rowIndex: index))
          }
        }
        .onDelete() { indexSet in
          for index in indexSet {
            viewModel.deleteRing(id: viewModel.rings[index].id)
          }
        }
      }
    }
    .onAppear() {
      viewModel.getRings()
    }
    .listStyle(.inset)
    .navigationTitle("Rings")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing: Button(action: {}) {
      addButton
    })
  }

  private func chooseColor(rowIndex: Int) -> UIColor {
    let colorIndex = (rowIndex + 4) % 4

    return colors[colorIndex]
  }

  private var addButton: some View {
    NavigationLink(destination: RingDetailView(viewModel: viewModel.generateViewModel())) {
      Image(systemName: "plus")
    }
  }
}

struct RingsView_Previews: PreviewProvider {
  static var previews: some View {
    RingsView(viewModel: RingsViewModel())
  }
}
