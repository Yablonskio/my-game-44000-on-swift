//
//  ContentView.swift
//  loler-ios-3
//
//  Created by Rostik Yablonski on 01.01.2023.
//

import SwiftUI
import Foundation


struct ContentView: View {
  @StateObject var GL = GeneralLogic()
  
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  
  @State var shopS = false
  @State var settingsS = false
  @State var guideS = false
  let userDefaults = UserDefaults()
  // array color start
  var ACS:Array<Any>
  // array colorButton start
  var ACBS:Array<Any>
  // array colorFont start
  var ACFS:Array<Any>
  @State var color:Color
  @State var colorButton:Color
  @State var colorFont:Color
  init() {
    if userDefaults.array(forKey: "colorButton") == nil {
      UserDefaults.standard.set([0.940046, 0.571929, 0.52642], forKey: "color")
    }
    if userDefaults.array(forKey: "colorButton") == nil {
      UserDefaults.standard.set([0.949639, 0.662919, 0.517958], forKey: "colorButton")
    }
    if userDefaults.array(forKey: "colorFont") == nil {
      UserDefaults.standard.set([0.0, 0.0, 0.0], forKey: "colorFont")
    }
    ACS = userDefaults.array(forKey: "color")!
    color = Color(red: ACS[0] as! Double, green: ACS[1] as! Double, blue: ACS[2] as! Double)
    ACBS = userDefaults.array(forKey: "colorButton")!
    colorButton = Color(red: ACBS[0] as! Double, green: ACBS[1] as! Double, blue: ACBS[2] as! Double)
    ACFS = userDefaults.array(forKey: "colorFont")!
    colorFont = Color(red: ACFS[0] as! Double, green: ACFS[1] as! Double, blue: ACFS[2] as! Double)
  }
  

  
  @StateObject var OL = OtherLogic()
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        ZStack(alignment: .topLeading) {
          Image("field").resizable()
            .scaledToFit()
            .frame(width: screenWidth - screenWidth / 100 * 0.6, height: screenWidth - screenWidth / 100 * 0.6)
            .padding(EdgeInsets(top: screenWidth / 100 * 0.3, leading: screenWidth / 100 * 0.3, bottom: screenWidth / 100 * 0.3, trailing: screenWidth / 100 * 0.3))
          ZStack {
            Circle().fill((GL.clickOrbWithTimer) ? .purple : (GL.clickOrb) ? .green : .red).frame(width: screenWidth * 0.126, height: screenWidth * 0.126)
            Button {
              if GL.clickOrb {
                GL.plusPointsTap()
                GL.clickOrb = false
                GL.clickOrbWithTimer = false
              } else if GL.clickOrbWithTimer {
                GL.doublePointsTap()
                GL.clickOrb = false
                GL.clickOrbWithTimer = false
              }
            } label: {
              Text((!GL.playWithOutSec) ? String(GL.secOrb) : " ")
            }.foregroundColor(.white).font(.system(size: screenWidth * 0.1, weight: .bold)).clipped()
          }.frame(width: screenWidth * 0.126, height: screenWidth * 0.126)
            .offset(x: screenWidth / 1000 * GL.posOX, y: screenWidth / 1000 * GL.posOY)
            .animation(.interpolatingSpring(mass: 0.2, stiffness: 100, damping: 10, initialVelocity: 10), value: GL.posOX)
            .animation(.interpolatingSpring(mass: 0.2, stiffness: 100, damping: 10, initialVelocity: 10), value: GL.posOY)
          
          Image("lolerClassic").resizable().frame(width: screenWidth * 0.126, height: screenWidth * 0.126)
            .offset(x: screenWidth / 1000 * GL.posLX, y: screenWidth / 1000 * GL.posLY)
            .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 20), value: GL.posLX)
            .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 20), value: GL.posLY)
        }
        HStack(spacing: 0) {
          HStack {
            Spacer().frame(width: (screenWidth - screenHeight / 14) / 35)
            Text("Points: \((GL.recordGame == false) ? String(GL.points) : String(GL.pointsRec))").font(.system(size: screenWidth / 16, weight: .regular)).foregroundColor(colorFont)
            Spacer()
            Spacer()
            Spacer()
            
            Button {
              if self.GL.freez == false {
                GL.startRecord()
              }
            } label: {
              Text("\(GL.recordText): \(GL.recordP)")
                .padding((GL.freez == true) ? EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) : EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(height: (screenHeight / 20) - 8)
                .font(.system(size: screenWidth / 16, weight: .regular))
                .foregroundColor((GL.freez == true) ? Color.white : Color.black)
                .background((GL.freez == true) ? nil : colorButton)
                .cornerRadius(screenWidth / 30).foregroundColor(.black)
                .animation(.easeInOut(duration: 0.2), value: GL.recordP)
            }
            Spacer().frame(width: (screenWidth - screenHeight / 14) / 35)
          }.frame(width: screenWidth - screenHeight / 14,height: screenHeight / 20).background(color).cornerRadius(screenWidth / 25).padding(EdgeInsets(top: 10.0, leading: 5.0, bottom: 10.0, trailing: 5.0))
          Button {
            if self.GL.freez == false {
              shopS.toggle()
            }
          } label: {
            Image(systemName: "cart").resizable().frame(width: screenHeight / 30, height: screenHeight / 30)
          }.frame(width: screenHeight / 20, height: screenHeight / 20).background(colorButton).cornerRadius(screenWidth / 25).foregroundColor(.white).padding(EdgeInsets(top: 10.0, leading: 0, bottom: 10.0, trailing: 5.0))
            .sheet(isPresented: $shopS, content: {
              ShopView()
            })
        }
      }
      VStack {
        Spacer()
        HStack(spacing: 15) {
          Button {
            guideS.toggle()
          } label: {
            Text("Guide\n game").frame(width: screenWidth * 0.27, height: screenWidth * 0.27)
              .background(colorButton).foregroundColor(colorFont).font(.title).cornerRadius(20).padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: screenWidth * 0.03, trailing: screenWidth * 0.03))
          }.sheet(isPresented: $guideS, content: {
            if self.GL.freez == false {
              GuideView()
            }
          })
          Button(action: {}) {
            Image(systemName: "arrowshape.left.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).rotationEffect(.degrees(90)).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .background(colorButton).foregroundColor(colorFont).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8).onEnded { _ in
              GL.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9).onEnded { _ in
              GL.move(type: 1)
            }
          )
          
          Button {
            if self.GL.freez == false {
              settingsS.toggle()
            }
          } label: {
            Text("Settings").frame(width: screenWidth * 0.27, height: screenWidth * 0.27)
              .background(colorButton).foregroundColor(colorFont).font(.system(size: screenWidth * 0.07)).cornerRadius(20).padding(EdgeInsets(top: 0.0, leading: UIScreen.main.bounds.width * 0.03, bottom: UIScreen.main.bounds.width * 0.03, trailing: 0.0))
          }.sheet(isPresented: $settingsS, content: {
            SettingsView(
              color: $color,
              colorButton: $colorButton,
              colorFont: $colorFont,
              playWithOutSec: self.$GL.playWithOutSec,
              pickerState: self.$GL.secMainTimer
            )
          }).onChange(of: GL.secMainTimer) {newValue in
            GL.resetTimer()
            //UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
          }
        }
        Spacer().frame(height: 15)
        HStack(spacing: 15) {
          Button(action: {}) {
            Image(systemName: "arrowshape.left.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .background(colorButton).foregroundColor(colorFont).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8).onEnded { _ in
              GL.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9).onEnded { _ in
              GL.move(type: 3)
            }
          )
          
          Button(action: {}) {
            Image(systemName: "arrowshape.left.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).rotationEffect(.degrees(-90)).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .background(colorButton).foregroundColor(colorFont).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8).onEnded { _ in
              GL.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9).onEnded { _ in
              GL.move(type: 2)
            }
          )
          
          Button(action: {}) {
            Image(systemName: "arrowshape.right.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .background(colorButton).foregroundColor(colorFont).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8).onEnded { _ in
              GL.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9).onEnded { _ in
              GL.move(type: 4)
            }
          )
        }.frame(width: screenWidth).padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 30, trailing: 0.0))
        Spacer()
      }.frame(maxHeight: .infinity).background(color).onChange(of: color) {newValue in
        let colorWrite: String? = "\(color)"
        if (colorWrite != nil) {
          let arrayColor = colorWrite!.dropFirst(22).dropLast(1).components(separatedBy: " ").map{ Double($0)! }
          UserDefaults.standard.set([arrayColor[0], arrayColor[1], arrayColor[2]], forKey: "color")
          print(colorWrite!)
        }
      }.onChange(of: colorButton) {newValue in
        let colorWrite: String? = "\(colorButton)"
        if (colorWrite != nil) {
          let arrayColor = colorWrite!.dropFirst(22).dropLast(1).components(separatedBy: " ").map{ Double($0)! }
          UserDefaults.standard.set([arrayColor[0], arrayColor[1], arrayColor[2]], forKey: "colorButton")
        }
      }.onChange(of: colorFont) {newValue in
        let colorWrite: String? = "\(colorFont)"
        if (colorWrite != nil) {
          let arrayColor = colorWrite!.dropFirst(22).dropLast(1).components(separatedBy: " ").map{ Double($0)! }
          UserDefaults.standard.set([arrayColor[0], arrayColor[1], arrayColor[2]], forKey: "colorFont")
        }
      }.onAppear {
        GL.start()
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
