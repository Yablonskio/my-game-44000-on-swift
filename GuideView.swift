//
//  GuideView.swift
//  loler-ios-3
//
//  Created by Rostik Yablonski on 28.01.2023.
//

import SwiftUI

struct GuideView: View {
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  @Environment(\.dismiss) var dismiss
  
  
  var body: some View {
    VStack(spacing: 0) {
      /*HStack(spacing: 0) {
        Image(systemName: "chevron.compact.down").resizable().frame(width: 45, height: 15)
      }*/
      HStack(spacing: 0) {
        Spacer()
          Text("GUIDE").font(.system(size: screenWidth * 0.17)).fontWeight(.heavy)
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
        
        
        
      }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
