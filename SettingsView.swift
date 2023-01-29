//
//  SettingsView.swift
//  loler-ios-3
//
//  Created by Rostik Yablonski on 24.01.2023.
//

import SwiftUI

struct SettingsView: View {
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  @Environment(\.dismiss) var dismiss
  
  @Binding var color:Color
  @Binding var colorButton:Color
  @Binding var colorFont:Color
  @Binding var playWithOutSec:Bool
  @Binding var pickerState:Int
  
  var pickerContent = ["1.6s","1.8s","2.0s"]
  
  
  
  var body: some View {
    VStack(spacing: 0) {
      /*HStack(spacing: 0) {
        Image(systemName: "chevron.compact.down").resizable().frame(width: 45, height: 15)
      }*/
      HStack(spacing: 0) {
        Spacer()
        Text("SETTINGS").font(.system(size: screenWidth * 0.14)).fontWeight(.heavy)
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
    }
    Form {
      Section(header: Text("Color")) {
        ColorPicker("Set the background color", selection: $color, supportsOpacity: false)
        ColorPicker("Set the button color", selection: $colorButton, supportsOpacity: false)
        ColorPicker("Set the font color", selection: $colorFont, supportsOpacity: false)
      }
      Section(header: Text("Time option")) {
        Picker(selection: $pickerState, label: Text("lol")) {
          ForEach(0 ..< pickerContent.count) {
            Text(self.pickerContent[$0])
          }
        }.pickerStyle(SegmentedPickerStyle()).listRowSeparatorTint(Color.clear)
        HStack {
          Text("Earn:")
          Spacer()
          Text((pickerState == 0) ? "5 Points" : (pickerState == 1) ? "3 Points" : "1 Points")
          Spacer()
        }
        Toggle(isOn: $playWithOutSec) {
          Text("Play without second")
        }.onChange(of: playWithOutSec) { newValue in
          UserDefaults.standard.set(playWithOutSec, forKey: "playWithOutSec")
        }
      }
    }.frame(height: screenHeight * 0.8)
    
  }
}

/*struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
      SettingsView()
    }
}*/
