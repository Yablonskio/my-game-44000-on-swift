import SwiftUI
import AVFoundation
let playerSleep = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "sleep", withExtension: "m4a")!)

class Main: ObservableObject {
  // MAIN CLASS
  // Theme
  @Published var gameTheme = UserDefaults.standard.string(forKey: "gameTheme") ?? "default"//"starGuardian"
  // ^ Theme
  
  // sound
  
  @Published var playWithOutSound = UserDefaults.standard.bool(forKey: "playWithOutSound")
  
  @Published var playWithOutSFX = UserDefaults.standard.bool(forKey: "playWithOutSFX") 
  // ^ sound
  // Button Controls
  @Published var freez = false
  
  @Published var playWithOutSec = UserDefaults.standard.bool(forKey: "playWithOutSec")
  @Published var clickOrb = false
  @Published var clickOrbWithTimer = false
  @Published var recordGame = false
  
  // UI Data
  @Published var points = UserDefaults.standard.integer(forKey: "points")
  @Published var pointsPlus = 5
  @Published var recordP = UserDefaults.standard.integer(forKey: "recordP")
  @Published var recordText = "Record"
  @Published var pointsRec = 0
  @Published var secOrb = 3
  @Published var secMainTimer = UserDefaults.standard.integer(forKey: "secMainTimer")
  var secSleep = 10
  var doublePoints = false
  var timerClickOrb = 0
  
  // position | 437 - this is center
  // 34 - this is start | 840 - this is end
  @Published var posLX = 840.0
  @Published var posLY = 840.0
  @Published var posOX = 437.0
  @Published var posOY = -140.0
  
  // Timers
  var mainTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false){ timer in}
  var timerSec = Timer.scheduledTimer(withTimeInterval: 0, repeats: false){ timerSec in}
  var lolerEyesTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false){ timerSec in}

  // additional class
  
  func start() {
    if points == 0 {
      playWithOutSound = true
      playWithOutSFX = true
      UserDefaults.standard.set(true, forKey: "playWithOutSound")
      UserDefaults.standard.set(true, forKey: "playWithOutSFX")
    }
    let secMainTimerWorker:Double
    switch secMainTimer {
    case 0:
      secMainTimerWorker = 1.6
    case 1:
      secMainTimerWorker = 1.8
    case 2:
      secMainTimerWorker = 2.0
    default:
      print("ERROR")
      secMainTimerWorker = 1.6
    }
    self.mainTimer = Timer.scheduledTimer(withTimeInterval: secMainTimerWorker, repeats: true) { timer in
      if self.secSleep != 0 {
        self.secSleep = self.secSleep - 1
        if self.secSleep == 0 {
          self.sleepLoler()
        }
      }
      
      if self.freez == false {
        if self.playWithOutSec == false {
          self.timerSec.invalidate()
          self.secOrb = 3
          self.timerClickOrb += 1
          self.timerOrbClickCheck()
          self.timerSec = Timer.scheduledTimer(withTimeInterval: secMainTimerWorker / 3, repeats: true){timerSec in
            self.secOrb -= 1
            if self.secOrb == -1 {
              self.resetTimer()
            }
          }
          self.orbNewPos()
        }
      }
      if self.doublePoints == true {
        if self.playWithOutSec == false {
          self.timerSec.invalidate()
          self.secOrb = 3
          self.timerClickOrb += 1
          self.timerOrbClickCheck()
          self.timerSec = Timer.scheduledTimer(withTimeInterval: secMainTimerWorker / 3, repeats: true){timerSec in
            self.secOrb -= 1
            if self.secOrb == -1 {
              self.resetTimer()
            }
          }
          self.orbNewPos()
        }
      }
    }
  }
  
  
  // type: 1 UP, 2 DOWN, 3 LEFT, 4 RIGHT
  func move(type: Int) {
    secSleep = 10
    switch (type) {
    case 1:
      // UP
      if posLY == 34.0 {return}
      posLY -= 100.75
    case 2:
      // DOWN
      if posLY == 840.0 {return}
      posLY += 100.75
    case 3:
      // LEFT
      if posLX == 34.0 {return}
      posLX -= 100.75
    case 4:
      // RIGHT
      if posLX == 840.0 {return}
      posLX += 100.75
    default:
      print("Error in switch, WHAT?!?!?")
    }
    if checkEat() == true {
      if self.recordGame == false {
        if playWithOutSec == false {
          switch secMainTimer {
          case 0:
            pointsPlus = 5
          case 1:
            pointsPlus = 3
          case 2:
            pointsPlus = 1
          default:
            print("ERROR")
          }
        } else {
          pointsPlus = 1
        }
        if doublePoints == true {
          pointsPlus *= 2
        }
        UserDefaults.standard.set(points + pointsPlus, forKey: "points")
        for i in 1...pointsPlus {
          let _ = Timer.scheduledTimer(withTimeInterval: Double(i)/1.8, repeats: false) { _ in
            self.points+=1
          }
        }
      } else {
        pointsPlus = 1
        pointsRec += pointsPlus
      }
      UINotificationFeedbackGenerator().notificationOccurred(.warning)
      orbNewPos()
      resetTimer()
      self.timerClickOrb += 1
      self.timerOrbClickCheck()
    }
  }
  func checkEat() -> Bool {
    if posLX == posOX && posLY == posOY {
      return true
    }
    return false
  }
  func orbNewPos() {
    let oldPosOX = posOX
    let oldPosOY = posOY
    var rundomNum = Int.random(in: 0...8)
    if (rundomNum == 0) {
      posOX = 34.0
    } else {
      posOX = 34.0 + 100.75 * Double(rundomNum)
    }
    rundomNum = Int.random(in: 0...8)
    if (rundomNum == 0) {
      posOY = 34.0
    } else {
      posOY = 34.0 + 100.75 * Double(rundomNum)
    }
    if (checkEat() == true) {
      orbNewPos()
    }
    if (posOX == oldPosOX && posOY == oldPosOY) {
      orbNewPos()
    }
    if gameTheme != "default" {
      animateNewPos(oldPosOX: oldPosOX, oldPosOY: oldPosOY)
    }
  }
  
  func resetTimer() {
    mainTimer.invalidate()
    start()
    self.secOrb = 4
  }
  func startRecord() {
    let oldPlayWithOutSec = playWithOutSec
    playWithOutSec = true
    freez = true
    recordGame = true
    recordText = "Time"
    recordP = 15
    let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timerRecord in
      self.recordP -= 1
      if self.recordP == 0 {
        timerRecord.invalidate()
        self.endRecord(oldplayWithOutSec: oldPlayWithOutSec)
      }
    }
  }
  func endRecord(oldplayWithOutSec:Bool) {
    playWithOutSec = oldplayWithOutSec
    freez = false
    recordGame = false
    recordText = "Scored"
    recordP = pointsRec
    self.secOrb = 3
    if pointsRec > UserDefaults.standard.integer(forKey: "recordP") {
      UserDefaults.standard.set(pointsRec, forKey: "recordP")
    }
    pointsRec = 0
    let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timerRecordEnd in
      if self.recordGame {return}
      self.recordText = "Record"
      self.recordP = UserDefaults.standard.integer(forKey: "recordP")
      timerRecordEnd.invalidate()
    }
  }
  func tapOnOrb() {
    if clickOrb {
      plusPointsTap()
    } else if clickOrbWithTimer {
      doublePointsTap()
    }
  }
  func plusPointsTap() {
    if !clickOrb {return}
    clickOrb = false
    self.changeColorScene(type: 1, complite: true)
    self.simpleSuccess()
    pointsPlus = 10
    points += pointsPlus
    UserDefaults.standard.set(points, forKey: "points")
    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){timerSec in
      self.clickOrb = false
      self.changeOrbImage(action: 0)
      if self.doublePoints {
        self.changeColorScene(type: 2, complite: true)
        self.changeOrbImage(action: 2)
      } else {
        self.changeColorScene(type: 0, complite: false)
      }
      self.blinkingEyes()
    }
  }
  func doublePointsTap() {
    if !clickOrbWithTimer {return}
    clickOrbWithTimer = false
    let _ = Timer.scheduledTimer(withTimeInterval:
                                  TimeInterval(Float.random(in: 0.5...8.0)), repeats: false) {_ in
      self.blinkingEyes()
    }
    self.simpleSuccess()
    self.doublePoints = true
    self.freez = true
    self.recordText = "Time"
    self.recordP = 10
    self.changeColorScene(type: 2, complite: true)
    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){timerSec in
      self.changeColorScene(type: 2, complite: false)
    }
    let timerDoublePoints = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){timerSec in
      self.recordP -= 1
    }
    let _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false){timerSec in
      self.clickOrb = false
      self.changeOrbImage(action: 0)
      self.doublePoints = false
      self.freez = false
      self.recordText = "Record"
      self.recordP = UserDefaults.standard.integer(forKey: "recordP")
      self.changeColorScene(type: 0, complite: false)
      timerDoublePoints.invalidate()
    }
  }
  func timerOrbClickCheck() {
    if (self.recordGame == false) {
      if self.timerClickOrb == 5 {
        self.clickOrb = true
        self.changeOrbImage(action: 1)
        self.changeColorScene(type: 1, complite: false)
      } else if self.timerClickOrb == 10 {
        self.clickOrb = true
        self.changeOrbImage(action: 1)
        self.changeColorScene(type: 1, complite: false)
      } else if self.timerClickOrb == 15 {
        self.clickOrb = true
        self.changeOrbImage(action: 1)
        self.changeColorScene(type: 1, complite: false)
      } else if self.timerClickOrb == 20 {
        self.timerClickOrb = 0
        self.clickOrbWithTimer = true
        self.changeOrbImage(action: 2)
        self.changeColorScene(type: 2, complite: false)
      }
    } else {
      self.clickOrb = false
      self.changeOrbImage(action: 0)
      self.changeColorScene(type: 0, complite: false)
    }
    if playWithOutSec {return}
    if self.clickOrb {
      let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false){timerSec in
        if !self.clickOrb {return}
        if self.doublePoints {
          self.changeOrbImage(action: 2)
          self.changeColorScene(type: 2, complite: false)
          return
        }
        self.clickOrb = false
        self.clickOrbWithTimer = false
        self.changeOrbImage(action: 0)
        self.changeColorScene(type: 0, complite: false)
      }
    }
    if self.clickOrbWithTimer {
      let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false){timerSec in
        if !self.clickOrbWithTimer {return}
        if self.clickOrbWithTimer {
          self.clickOrb = false
          self.clickOrbWithTimer = false
          self.changeOrbImage(action: 0)
          self.changeColorScene(type: 0, complite: false)
        }
      }
    }
  }
  func playSound(type: String) {
    if type == "stop" {
      playerSleep.stop()
      return
    }
    if playWithOutSound {
      switch type {
      case "sleep":
        playerSleep.play()
      default:
        print("Error in playSound")
      }
    }
  }
  func saveDataColor(color: Color, forKey: String) {
    let colorString = "\(color)"
    let colorWrite = colorString.dropFirst(22).dropLast(1).components(separatedBy: " ").map{ Double($0)}
    UserDefaults.standard.set([colorWrite[0], colorWrite[1], colorWrite[2]], forKey: forKey)
  }
  // ^ MAIN CLASS
  // EFFECT CLASS
    // UI workers
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  // Main
  @Published var imageView = "backgroundStarGuardian"
  @Published var backgroundView = Color(.white)
  @Published var buttonView = Color(.black)
  // ^ Main
  // Field
  @Published var blurField = UIScreen.main.bounds.width / 50
  @Published var colorField = Color(.white)
  @Published var backgroundField = Color(.black)
  // ^ Field
  // Info panel
  @Published var numberPlusPosition = -UIScreen.main.bounds.height / 10
  @Published var numberPlusOpacity = 0.0
  // ^ Info panel
  // Orb
  @Published var orbImage = "orb"
  @Published var orbColorGradient = Color.yellow
  @Published var orbSize = UIScreen.main.bounds.width * 0.126//0.11
  @Published var orbRotate = 0
  @Published var orbFontSize = UIScreen.main.bounds.width * 0.1
  @Published var orbView = "starOrb"
  @Published var orbClipShape = UIScreen.main.bounds.width * 0.126
  // ^ Orb
  // Loler
  @Published var lolerColor = Color(.white)
  @Published var lolerColorEyes = Color(red: 0.20, green: 0.20, blue: 0.20)
  @Published var lolerWidth = UIScreen.main.bounds.width * 0.13
  @Published var lolerHeight = UIScreen.main.bounds.width * 0.13
  @Published var lolerEyeHeight = UIScreen.main.bounds.width * 0.038
  @Published var lolerEyesHeight = UIScreen.main.bounds.width * 0.028
  // ^ Loler
  // ^ UI workers
  func blinkingEyes() {
    if lolerEyeHeight == screenWidth * 0.038 {
      lolerEyeHeight = screenWidth * 0.005
      let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) {_ in
        self.lolerEyeHeight = self.screenWidth * 0.038
      }
    }
  }
  func changeOrbImage(action: Int) {
    // action 0 - default, 1 - green, 2 - purple
    switch action {
    case 0:
      orbColorGradient = Color.yellow
    case 1:
      orbColorGradient = Color.green
    case 2:
      orbColorGradient = Color.purple
    default:
      print("Error in switch")
      orbColorGradient = Color.yellow
    }
    switch gameTheme {
    case "default":
      switch action {
      case 0:
        orbImage = "orb"
      case 1:
        orbImage = "orbGreen"
      case 2:
        orbImage = "orbPurple"
      default:
        print("Error in switch")
        orbImage = "orb"
      }
    case "starGuardian":
      switch action {
      case 0:
        orbImage = "starOrbYellow"
      case 1:
        orbImage = "starOrbGreen"
      case 2:
        orbImage = "starOrbPurple"
      default:
        print("Error in switch")
        orbImage = "starOrb"
      }
    default:
      switch action {
      case 0:
        orbImage = "orb"
      case 1:
        orbImage = "orbGreen"
      case 2:
        orbImage = "orbPurple"
      default:
        print("Error in switch")
        orbImage = "orb"
      }
    }
  }
  func sleepLoler() {
    playSound(type: "sleep")
    lolerEyeHeight = screenWidth * 0.01
    self.lolerEyesTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) {_ in
      if self.secSleep == 0 {
        if self.lolerEyesHeight == self.screenWidth * 0.05 {
          self.lolerEyesHeight = self.screenWidth * 0.03
        } else {
          self.lolerEyesHeight = self.screenWidth * 0.05
        }
      } else {
        self.stopSleepLoler()
      }
    }
  }
  func stopSleepLoler() {
    lolerEyesTimer.invalidate()
    lolerEyeHeight = screenWidth * 0.038
    lolerEyesHeight = screenWidth * 0.038
    playSound(type: "stop")
  }
  func simpleSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
    
  }
  func animationPlusPoints() {
    if numberPlusPosition != -screenHeight / 10 {return}
    numberPlusOpacity = 1.0
    numberPlusPosition = screenHeight / 40
    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){timerSec in
      self.numberPlusOpacity = 0.0
    }
    let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false){timerSec in
      self.numberPlusPosition = -self.screenHeight / 10
    }
  }
  // 0 - default 1 - green, 1 - pirple
  func changeColorScene(type: Int, complite: Bool) {
    if !complite {
      switch type {
      case 0:
        blurField = UIScreen.main.bounds.width / 50
        colorField = Color(.white)
        backgroundField = Color(.black)
      case 1:
        blurField = UIScreen.main.bounds.width / 20
        colorField = Color(.green)
        backgroundField = Color(.black)
      case 2:
        blurField = UIScreen.main.bounds.width / 20
        colorField = Color(.purple)
        backgroundField = Color(.black)
      default:
        blurField = UIScreen.main.bounds.width / 20
        colorField = Color(.red)
        backgroundField = Color(.darkGray)
      }
    } else {
      switch type {
      case 0:
        blurField = UIScreen.main.bounds.width / 50
        colorField = Color(.white)
        backgroundField = Color(.black)
      case 1:
        blurField = UIScreen.main.bounds.width / 10
        colorField = Color(.green)
        backgroundField = Color(.black)
      case 2:
        blurField = UIScreen.main.bounds.width / 10
        colorField = Color(.purple)
        backgroundField = Color(.black)
      default:
        blurField = UIScreen.main.bounds.width / 20
        colorField = Color(.red)
        backgroundField = Color(.darkGray)
      }
    }
  }
  func changeGameTheme() {
    if doublePoints {
      changeOrbImage(action: 2)
    } else {
      if clickOrb {
        changeOrbImage(action: 1)
      } else {
        changeOrbImage(action: 0)
      }
    }
    if gameTheme == "default" {
      getDefault()
    } else if gameTheme == "starGuardian" {
      getStarGuardian()
    }
  }
  func getDefault() {
    orbFontSize = screenWidth * 0.1
    orbClipShape = UIScreen.main.bounds.width * 0.126
  }
  func getStarGuardian() {
    orbFontSize = screenWidth * 0.07
    imageView = "backgroundStarGuardian"
    orbView = "starOrb"
    backgroundView = Color(red: 173/255, green: 144/255, blue: 224/255)
    buttonView = Color(red: 184/255, green: 159/255, blue: 237/255)
    orbClipShape = (UIScreen.main.bounds.width * 0.126) / 1.3
  }
  
  func animateNewPos(oldPosOX: Double, oldPosOY: Double) {
    var rotate = 0
    switch gameTheme {
    case "starGuardian":
      let maxDifference:Double
      var differenceX = oldPosOX - posOX
      var differenceY = oldPosOY - posOY
      if differenceX < 0.0 {
        differenceX *= -1
      }
      if differenceY < 0.0 {
        differenceY *= -1
      }
      if rotate < 0 {
        rotate *= -1
      }
      if differenceX > differenceY {
        maxDifference = differenceX
      } else {
        maxDifference = differenceY
      }
      switch maxDifference {
      case 0.0:
        rotate = 0
      case 100.75:
        rotate += 45
      case 201.5:
        rotate += 90
      case 302.25:
        rotate += 90
      case 403...806:
        rotate += 135
      default:
        print(differenceX, differenceY)
        print(maxDifference)
        print("ERROR IN SWITCH 593")
      }
      if differenceX > differenceY {
        if posOX - oldPosOX < 0.0 {rotate *= -1}
      } else {
        if posOY - oldPosOY < 0.0 {rotate *= -1}
      }
      orbRotate += rotate
    default:
      print("Error in switch 576")
    }
  }
  
  // ^ EFFECT CLASS
  
}
