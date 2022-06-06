//
//  Created by Showmax
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("#1A Basic example") {
                    Example1.ContentView()
                        .navigationTitle("#1A Basic example")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#1B Basic example with Bindings") {
                    Example1b.ContentView()
                        .navigationTitle("#1B Basic example with Bindings")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#1C Basic example with unused closure") {
                    Example1c.ContentView()
                        .navigationTitle("#1C Basic example with unused closure")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#2 Separate observable objects") {
                    Example2.ContentView()
                        .navigationTitle("#2 Separate observable objects")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#3 Sub observable objects") {
                    Example3.ContentView()
                        .navigationTitle("#3 Sub observable objects")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#4 Publisher + onReceive + @State") {
                    Example4.ContentView()
                        .navigationTitle("#4 Publisher + onReceive + @State")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationTitle("Redrawing in SwiftUI")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
