//
//  Created by Showmax
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("#1 Basic example") {
                    Example1.ContentView()
                        .navigationTitle("#1 Basic example")
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
