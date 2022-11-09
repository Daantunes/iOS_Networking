import SwiftUI

struct RingsView: View {
  @State var rings: [Ring] = []
  @State private var buttonClicked = false
  
  var body: some View {
    VStack {
      List {
        ForEach(rings) { ring in
          NavigationLink(destination: UpdateRingView(ring: ring)) {
            Text(ring.name)
          }
        }
        .onDelete() { indexSet in
          for index in indexSet {
            deleteRing(id: rings[index].id)
            rings.remove(at: index)
          }
        }
      }

      Button("Get Rings") {
        getRings()
      }
      .disabled(buttonClicked)
    }
    .onAppear() {
      getRings()
    }
    .listStyle(.inset)
    .navigationTitle("Rings")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing: Button(action: {}) {
      addButton
    })
  }

  private var addButton: some View {
    NavigationLink(destination: CreateRingView()) {
      Image(systemName: "plus")
    }
  }

  private func getRings() {
    buttonClicked = true
    RequestManager().sendRequest(router: .rings, responseModel: [Ring].self) { completion in
      buttonClicked = false
      switch completion {
        case .success(let rings):
          self.rings = rings
        case .failure(let failure):
          print(failure)
      }
    }
  }

  private func deleteRing(id: UUID) {
    RequestManager().sendRequest(router: .deleteRing(id: id)) { completion in
      switch completion {
        case .success:
          getRings()
        case .failure(let failure):
          print(failure)
      }
    }
  }
}

struct RingsView_Previews: PreviewProvider {
  static var previews: some View {
    RingsView()
  }
}
