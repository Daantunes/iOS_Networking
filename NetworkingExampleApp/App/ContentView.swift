import SwiftUI

struct ContentView: View {
  @State var rings: [Ring] = []
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(rings, id: \.id) { ring in
            Text(ring.name)
          }
        }
        GetRings(rings: $rings)
      }
      .listStyle(.inset)
      .navigationTitle("Rings")
    }
  }
}

struct GetRings: View {
  @Binding var rings: [Ring]

  var body: some View {
    Button("Get Rings") {
      RequestManager().sendRequest(router: .rings, responseModel: [Ring].self) { completion in
        switch completion {
          case .success(let rings):
            self.rings = rings
          case .failure(let failure):
            print(failure)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
