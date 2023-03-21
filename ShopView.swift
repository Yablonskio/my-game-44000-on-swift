//
//  ShopView.swift
//  loler-ios-3
//
//  Created by Rostik Yablonski on 24.01.2023.
//

import SwiftUI
import Foundation

struct ShopView: View {
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  @Environment(\.dismiss) var dismiss
  
  @Binding var gameTheme:String
  @State var pickerWorker = 0
  
  let pickerContent = ["Minimalism","Star Guardian"]
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Spacer()
        Text("SHOP").font(.system(size: screenWidth * 0.17)).fontWeight(.heavy)
        Spacer()
        Spacer()
        Spacer()
        Spacer()
        Spacer()
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark.square.fill").resizable().frame(width: screenWidth * 0.12, height: screenWidth * 0.12).foregroundColor(.black)
        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screenWidth * 0.05))
      }.frame(width: screenWidth, height: screenWidth * 0.2).background(.yellow).position(x: screenWidth/2, y: screenWidth * 0.1)
      
  
      
      Form {
        Image(gameTheme).frame(height: screenHeight / 2)
        Section(header: Text("Theme option")) {
          Picker(selection: $pickerWorker, label: Text("lol")) {
            ForEach(0 ..< pickerContent.count, id: \.self) {
              Text(self.pickerContent[$0])
            }
          }.frame(height: screenHeight / 10)
          .pickerStyle(WheelPickerStyle()).listRowSeparatorTint(Color.clear)
          .onChange(of: pickerWorker) {newValue in
            if pickerWorker == 0 {
              gameTheme = "default"
            } else if pickerWorker == 1 {
              gameTheme = "starGuardian"
            }
          }
          .onAppear {
            if gameTheme == "default" {
              pickerWorker = 0
            } else if gameTheme == "starGuardian" {
              pickerWorker = 1
            }
          }
        }
      }.frame(height: screenHeight).position(x: screenWidth/2, y: screenWidth * 0.1 * 3)
    }
  }
}

/*struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}*/
