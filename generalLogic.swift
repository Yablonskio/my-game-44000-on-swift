//
//  generalLogic.swift
//  loler-ios-3
//
//  Created by Rostik Yablonski on 16.01.2023.
//

import Foundation
import SwiftUI

class GeneralLogic: ObservableObject {
  @Published var freez = false
  @Published var playWithOutSec = UserDefaults.standard.bool(forKey: "playWithOutSec")
  var timerClickOrb = 0
  @Published var clickOrb = false
  @Published var secMainTimer = 0
  @Published var clickOrbWithTimer = false
  
  @Published var points = UserDefaults.standard.integer(forKey: "points")
  @Published var recordP = UserDefaults.standard.integer(forKey: "recordP")
  @Published var recordText = "Record"
  
  @Published var recordGame = false
  @Published var pointsRec = 0
  
  @Published var secOrb = 3
  
  // position | 437 - this is center
  // 34 - this is start | 840 - this is end
  @Published var posLX = 840.0
  @Published var posLY = 840.0
  @Published var posOX = 34.0
  @Published var posOY = 34.0
  var doublePoints = false
  var mainTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false){ timer in}
  var timerSec = Timer.scheduledTimer(withTimeInterval: 0, repeats: false){ timerSec in}
  
  func start() {
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
    }
  }
  
  
  // type: 1 UP, 2 DOWN, 3 LEFT, 4 RIGHT
  func move(type: Int) {
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
      var pointsPlus = 0
      if self.recordGame == false {
        if playWithOutSec == false {
          switch secMainTimer {
          case 0:
            pointsPlus += 5
          case 1:
            pointsPlus += 3
          case 2:
            pointsPlus += 1
          default:
            print("ERROR")
          }
        } else {
          pointsPlus += 1
        }
      } else {
        pointsRec+=1
      }
      if (doublePoints == true) {
        points += pointsPlus * 2
      } else {
        points += pointsPlus
      }
      UINotificationFeedbackGenerator().notificationOccurred(.warning)
      UserDefaults.standard.set(points, forKey: "points")
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
    let oldposOX = posOX
    let oldposOY = posOY
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
    if (posOX == oldposOX && posOY == oldposOY) {
      orbNewPos()
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
      self.recordText = "Record"
      self.recordP = UserDefaults.standard.integer(forKey: "recordP")
      timerRecordEnd.invalidate()
    }
  }
  func plusPointsTap() {
    simpleSuccess()
    points += 10
    UserDefaults.standard.set(points, forKey: "points")
  }
  func doublePointsTap() {
    simpleSuccess()
    self.doublePoints = true
    self.freez = true
    self.recordText = "Time"
    self.recordP = 10
    let timerDoublePoints = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){timerSec in
      self.recordP -= 1
    }
    let _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false){timerSec in
      self.doublePoints = false
      self.freez = false
      self.recordText = "Record"
      self.recordP = UserDefaults.standard.integer(forKey: "recordP")
      timerDoublePoints.invalidate()
    }
  }
  func simpleSuccess() {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
  }
  func timerOrbClickCheck() {
    if self.timerClickOrb == 20 {
      self.timerClickOrb = 0
      self.clickOrbWithTimer = true
      let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false){timerSec in
        self.clickOrbWithTimer = false
      }
    } else if self.timerClickOrb == 5 {
      self.clickOrb = true
      let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false){timerSec in
        self.clickOrb = false
      }
    }
  }
 }
