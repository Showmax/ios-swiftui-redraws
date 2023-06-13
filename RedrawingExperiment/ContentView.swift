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
                NavigationLink("#1B Basic with Bindings") {
                    Example1b.ContentView()
                        .navigationTitle("#1B Basic with Bindings")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#1C Basic with unused closure") {
                    Example1c.ContentView()
                        .navigationTitle("#1C Basic with unused closure")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#1D Basic with 100.000 episodes") {
                    Example1d.ContentView()
                        .navigationTitle("#1D Basic with 100.000 episodes")
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
                NavigationLink("#3 Sub observable objects (report changes to parent via closure)") {
                    Example3b.ContentView()
                        .navigationTitle("#3 Sub observable objects (report changes to parent via closure)")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#3 Sub observable objects (report changes to parent via objectWillChange)") {
                    Example3c.ContentView()
                        .navigationTitle("#3 Sub observable objects (report changes to parent via objectWillChange)")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("#3 Sub observable objects (report changes to parent via common manager)") {
                    Example3d.ContentView()
                        .navigationTitle("#3 Sub observable objects (report changes to parent via common manager)")
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
