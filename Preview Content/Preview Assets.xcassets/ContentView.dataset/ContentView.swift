//
//  ContentView.swift
//  loler-ios-3
//
//  Created by Rostik Yablonski on 01.01.2023.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Text("lol")
      HStack {
        Text("lol")
        Text("lol")
        Text("lol")
      }
    }
      
  }
}
  
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ContentView().preferredColorScheme(.dark)
    }
  }
}
