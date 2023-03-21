import SwiftUI
import Foundation


struct ContentView: View {
  // Main class
  @StateObject var M = Main()
  // UI workers
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  // Sheet workers
  @State var shopS = false
  @State var settingsS = false
  @State var guideS = false
  // ^ Sheet workers
  // Colors workers
  // array color start
  var ACS = UserDefaults.standard.array(forKey: "color") ?? [0.940046, 0.571929, 0.52642]
  // array colorButton start
  var ACBS = UserDefaults.standard.array(forKey: "colorButton") ?? [0.949639, 0.662919, 0.517958]
  // array colorFont start
  var ACFS = UserDefaults.standard.array(forKey: "colorFont") ?? [0.0, 0.0, 0.0]
  @State var color:Color
  @State var colorButton:Color
  @State var colorFont:Color
  
  
  // ^ Colors workers
  init() {
    color = Color(red: ACS[0] as! Double, green: ACS[1] as! Double, blue: ACS[2] as! Double)
    colorButton = Color(red: ACBS[0] as! Double, green: ACBS[1] as! Double, blue: ACBS[2] as! Double)
    colorFont = Color(red: ACFS[0] as! Double, green: ACFS[1] as! Double, blue: ACFS[2] as! Double)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        ZStack(alignment: .topLeading) {
          Rectangle().fill(M.backgroundField).blur(radius: M.blurField).cornerRadius(screenWidth / 7.8)
            .frame(width: screenWidth - screenWidth / 31.5 * 2 + screenWidth / 17, height: screenWidth - screenWidth / 31.5 * 2 + screenWidth / 17)
            .border(M.colorField, width: screenWidth / 34)
            .background(in: Rectangle()).backgroundStyle(M.colorField)
            .padding(screenWidth / 31.5 - screenWidth / 34)
            .cornerRadius(screenWidth / 20)
            .animation(.easeInOut(duration: 0.2), value: M.blurField)
            .animation(.easeInOut(duration: 0.2), value: M.colorField)
          
          ZStack {
            Image(M.orbImage).resizable().frame(width: M.orbSize, height: M.orbSize).rotationEffect(.degrees(Double(M.orbRotate)), anchor: .center)
              .blur(radius: screenWidth / 900).background(Circle().fill(M.orbColorGradient).frame(width: M.orbSize / 1.3, height: M.orbSize / 1.3).blur(radius: screenWidth / 100)).animation(.interpolatingSpring(mass: 0.5, stiffness: 40, damping: 10, initialVelocity: 7), value: M.posOX)
              .animation(.interpolatingSpring(mass: 0.5, stiffness: 40, damping: 10, initialVelocity: 7), value: M.posOY).animation(.interpolatingSpring(mass: 0.5, stiffness: 40, damping: 10, initialVelocity: 7), value: M.orbRotate)
            Button {M.tapOnOrb()} label: {
              Text((!M.playWithOutSec) ? String(M.secOrb) : " ")
            }.foregroundColor(.white).font(.system(size: M.orbFontSize, weight: .bold, design: .rounded)).frame(width: M.orbClipShape, height: M.orbClipShape).clipShape(Circle()).animation(.interpolatingSpring(mass: 0.5, stiffness: 40, damping: 10, initialVelocity: 7), value: M.posOX)
              .animation(.interpolatingSpring(mass: 0.5, stiffness: 40, damping: 10, initialVelocity: 7), value: M.posOY).animation(.interpolatingSpring(mass: 0.5, stiffness: 40, damping: 10, initialVelocity: 7), value: M.orbRotate).animation(.easeInOut(duration: 0.3), value: M.secOrb)
            
          }.frame(width: screenWidth*0.126, height: screenWidth*0.126)
            .offset(x: screenWidth / 1000 * M.posOX, y: screenWidth / 1000 * M.posOY)
            
          ZStack {
            Rectangle().fill(M.lolerColor).cornerRadius(screenWidth / 38).frame(width: M.lolerWidth, height: M.lolerHeight)
            VStack {
              HStack {
                Rectangle().fill(M.lolerColorEyes).frame(width: screenWidth * 0.018, height: M.lolerEyeHeight).cornerRadius(screenWidth / 160)
                  .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 17), value: M.lolerEyeHeight)
                  .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 17), value: M.lolerEyesHeight)
                Spacer().frame(width: screenWidth * 0.04)
                Rectangle().fill(M.lolerColorEyes).frame(width: screenWidth * 0.018, height: M.lolerEyeHeight).cornerRadius(screenWidth / 160)
                  .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 17), value: M.lolerEyeHeight)
                  .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 17), value: M.lolerEyesHeight)
              }.frame(width: screenWidth * 0.13, height: screenWidth * 0.05)
              Spacer().frame(height: M.lolerEyesHeight)
                .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 17), value: M.lolerEyesHeight)
            }
          }.frame(width: screenWidth * 0.13, height: screenWidth * 0.13)
            .offset(x: screenWidth / 1000 * M.posLX - 0.8, y: screenWidth / 1000 * M.posLY - 0.8)
            .animation(.interpolatingSpring(mass: 0.3, stiffness: 70, damping: 13, initialVelocity: 10), value: M.posLX)
            .animation(.interpolatingSpring(mass: 0.3, stiffness: 70, damping: 13, initialVelocity: 10), value: M.posLY)
        }
        
        HStack(spacing: 0) {
          HStack(spacing: 0) {
            Spacer().frame(width: (screenWidth - screenHeight / 14) / 35)
            HStack(spacing: 0) {
              HStack(spacing: 0) {
                Text("Points: ").font(.system(size: screenWidth / 16, weight: .regular)).foregroundColor(colorFont)
                Text("\((M.recordGame == false) ? String(M.points) : String(M.pointsRec))").font(.system(size: screenWidth / 16, weight: .regular, design: .monospaced)).foregroundColor(colorFont).onChange(of: M.points) {_ in
                  M.animationPlusPoints()
                }.onChange(of: M.pointsRec) {_ in
                  M.animationPlusPoints()
                }
              }
              Text("+").frame(alignment: .trailing).foregroundColor(color).font(.system(size: screenWidth / 11, weight: .bold,design: .rounded)).opacity(M.numberPlusOpacity).colorInvert().padding(EdgeInsets(top: 0, leading: 0, bottom: M.numberPlusPosition, trailing: 0))
                .animation(.interpolatingSpring(mass: 0.1, stiffness: 30, damping: 10, initialVelocity: 17), value: M.numberPlusPosition)
                .animation(.easeOut(duration: 0.1), value: M.numberPlusOpacity)
            }
            Spacer()
            Button {
              if self.M.freez == false {
                M.startRecord()
              }
            } label: {
              Text("\(M.recordText): \(M.recordP)")
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(height: (screenHeight / 20) - 8)
                .font(.system(size: screenHeight / 35, weight: .bold, design: .rounded))
                .foregroundColor((M.freez == true) ? Color.black : Color.white)
                .background((M.freez == true) ? Color.white : Color.red)
                .cornerRadius(screenWidth / 30).foregroundColor(.black)
                .animation(.easeInOut(duration: 0.2), value: M.recordP)
            }
            Spacer().frame(width: screenWidth / 85)
          }.frame(width: screenWidth - screenWidth / 6,height: screenHeight / 20).background(M.gameTheme == "default" ? color : M.backgroundView).cornerRadius(screenWidth / 25).padding(EdgeInsets(top: screenHeight / 120, leading: screenWidth / 15, bottom: screenHeight / 120, trailing: screenWidth / 40))
          
          
          Button {
            if self.M.freez == false {
              shopS.toggle()
            }
          } label: {
            Image(systemName: "cart").resizable().frame(width: screenWidth / 12, height: screenWidth / 12)
          }.frame(width: screenWidth / 9, height: screenWidth / 9).background(M.gameTheme == "default" ? color : M.backgroundView).cornerRadius(screenWidth / 25).foregroundColor(.white).padding(EdgeInsets(top: 0.0, leading: 0, bottom: 0.0, trailing: screenWidth / 15))
            .sheet(isPresented: $shopS, content: {
              ShopView(gameTheme: $M.gameTheme)
            }).onChange(of: M.gameTheme) {newValue in
              M.changeGameTheme()
              UserDefaults.standard.set(newValue, forKey: "gameTheme")
              UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
      }
      VStack {
        Spacer()
        HStack(spacing: 15) {
          Button {
            if self.M.freez == false {
              guideS.toggle()
            }
          } label: {
            Text("Guide\n game").frame(width: screenWidth * 0.27, height: screenWidth * 0.27)
              .foregroundColor(colorButton).colorInvert().background(M.gameTheme != "default" ?M.buttonView:colorButton).opacity(0.5).font(.system(size: screenWidth * 0.07, design: .rounded)).cornerRadius(20).padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: screenWidth * 0.03, trailing: screenWidth * 0.03))
          }.sheet(isPresented: $guideS, content: {
            if self.M.freez == false {
              GuideView()
            }
          })
          Button(action: {}) {
            Image(systemName: "arrowshape.left.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).rotationEffect(.degrees(90)).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .foregroundColor(colorButton).colorInvert().background(M.gameTheme != "default" ?M.buttonView:colorButton).opacity(0.5).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2, maximumDistance: 0.21).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3, maximumDistance: 0.31).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4, maximumDistance: 0.41).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5, maximumDistance: 0.51).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6, maximumDistance: 0.61).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7, maximumDistance: 0.71).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8, maximumDistance: 0.81).onEnded { _ in
                M.move(type: 1)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9, maximumDistance: 0.91).onEnded { _ in
                M.move(type: 1)
            }
          )
          
          Button {
            if self.M.freez == false {
              settingsS.toggle()
            }
          } label: {
            Text("Settings").frame(width: screenWidth * 0.27, height: screenWidth * 0.27)
              .foregroundColor(colorButton).colorInvert().background(M.gameTheme != "default" ?M.buttonView:colorButton).opacity(0.5).font(.system(size: screenWidth * 0.07, design: .rounded)).cornerRadius(20).padding(EdgeInsets(top: 0.0, leading: UIScreen.main.bounds.width * 0.03, bottom: UIScreen.main.bounds.width * 0.03, trailing: 0.0))
          }.sheet(isPresented: $settingsS, content: {
            SettingsView(
              color: $color,
              colorButton: $colorButton,
              colorFont: $colorFont,
              playWithOutSec: $M.playWithOutSec,
              pickerState: $M.secMainTimer,
              playWithOutSound: $M.playWithOutSound,
              playWithOutSFX: $M.playWithOutSFX
            )
          }).onChange(of: M.secMainTimer) {newValue in
            M.resetTimer()
            //UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
          }
        }
        Spacer().frame(height: 15)
        HStack(spacing: 15) {
          Button(action: {}) {
            Image(systemName: "arrowshape.left.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .foregroundColor(colorButton).colorInvert().background(M.gameTheme != "default" ?M.buttonView:colorButton).opacity(0.5).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2, maximumDistance: 0.21).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3, maximumDistance: 0.31).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4, maximumDistance: 0.41).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5, maximumDistance: 0.51).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6, maximumDistance: 0.61).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7, maximumDistance: 0.71).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8, maximumDistance: 0.81).onEnded { _ in
              M.move(type: 3)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9, maximumDistance: 0.91).onEnded { _ in
              M.move(type: 3)
            }
          )
          
          Button(action: {}) {
            Image(systemName: "arrowshape.left.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).rotationEffect(.degrees(-90)).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .foregroundColor(colorButton).colorInvert().background(M.gameTheme != "default" ?M.buttonView:colorButton).opacity(0.5).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2, maximumDistance: 0.21).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3, maximumDistance: 0.31).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4, maximumDistance: 0.41).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5, maximumDistance: 0.51).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6, maximumDistance: 0.61).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7, maximumDistance: 0.71).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8, maximumDistance: 0.81).onEnded { _ in
              M.move(type: 2)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9, maximumDistance: 0.91).onEnded { _ in
              M.move(type: 2)
            }
          )
          
          Button(action: {}) {
            Image(systemName: "arrowshape.right.fill").resizable().frame(width: screenWidth * 0.2, height: screenWidth * 0.2).frame(width: screenWidth * 0.3, height: screenWidth * 0.3)
              .foregroundColor(colorButton).colorInvert().background(M.gameTheme != "default" ?M.buttonView:colorButton).opacity(0.5).font(.largeTitle).cornerRadius(20)
          }.simultaneousGesture(
            TapGesture().onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2, maximumDistance: 0.21).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3, maximumDistance: 0.31).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4, maximumDistance: 0.41).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5, maximumDistance: 0.51).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.6, maximumDistance: 0.61).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.7, maximumDistance: 0.71).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8, maximumDistance: 0.81).onEnded { _ in
              M.move(type: 4)
            }
          ).simultaneousGesture(
            LongPressGesture(minimumDuration: 0.9, maximumDistance: 0.91).onEnded { _ in
              M.move(type: 4)
            }
          )
        }.frame(width: screenWidth).padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: screenHeight / 15, trailing: 0.0))
        Spacer()
      }.frame(height: screenHeight / 2.6).background(Image(M.imageView).resizable().edgesIgnoringSafeArea(.bottom).opacity(M.gameTheme == "default" ? 0 : 1)).background(color)
      
      .onChange(of: color) {newValue in
        M.saveDataColor(color: color, forKey: "color")
      }.onChange(of: colorButton) {newValue in
        M.saveDataColor(color: colorButton, forKey: "colorButton")
      }.onChange(of: colorFont) {newValue in
        M.saveDataColor(color: colorFont, forKey: "colorFont")
      }.onAppear {
        M.changeOrbImage(action: 0)
        M.start()
        M.changeGameTheme()
        if M.playWithOutSec == true {
          M.orbNewPos()
        }
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

