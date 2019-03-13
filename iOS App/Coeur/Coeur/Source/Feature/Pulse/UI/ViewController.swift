////
////  ViewController.swift
////  Pulse_iOS
////
////  Created by Mike on 2018-10-19.
////  Copyright © 2018 Mike. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController, ppgOrganDelegate {
//
//  private let captureOrgan: PulseCaptureOrgan = PulseCaptureOrgan()
//  private var ppgCSV: [String:Double] = [:]
//  private var ppg: [Double] = []
//  private var frames: Double = 0
//
//  private lazy var ppgOrgan: PulsePPGOrgan = {
//    return PulsePPGOrgan(captureOrgan: self.captureOrgan)
//  }()
//
//  private var frameRates: [Double] = [] {
//    didSet {
//      if frameRates.count == 50 {
//        print(frameRates.reduce(0, +) / Double(frameRates.count))
//        frameRates = []
//      }
//    }
//  }
//  override func viewWillAppear(_ animated: Bool) {
//    ppgOrgan.delegate = self
//    ppgOrgan.beat()
//    captureOrgan.configureTorch()
//  }
//
//  func ppgOrgan(_ ppgOrgan: PulsePPGOrgan, didCapture ppgValue: Double) {
//    ppg.append(ppgValue)
//
//    // Update chart data
//    frames += 1
//    update(currentTime: Date().timeIntervalSince1970)
//  }
//
//  var lastUpdateTime: TimeInterval = 0
//
//  func update(currentTime: TimeInterval) {
//    let deltaTime = currentTime - lastUpdateTime
//    let currentFPS = 1 / deltaTime
//    frameRates.append(currentFPS)
//
//    lastUpdateTime = currentTime
//  }
//
//  @IBAction func endCapture(_ sender: UIButton) {
//    let trimmedPPG = ppg[300...(ppg.count - 1)]
//    createCSV(from: Array(trimmedPPG))
//  }
//
//  func createCSV(from ppg:[Double]) {
//    var csvString = "\("ppg")\n\n"
//    for value in ppg {
//      csvString = csvString.appending("\(value)\n")
//    }
//
//    let fileManager = FileManager.default
//    do {
//      let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//      let fileURL = path.appendingPathComponent("CSVRec-\(getTodayString()).csv")
//      try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
//    } catch {
//      print("error creating file")
//    }
//  }
//
//  func getTodayString() -> String{
//
//    let date = Date()
//    let calender = Calendar.current
//    let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
//
//    let year = components.year
//    let month = components.month
//    let day = components.day
//    let hour = components.hour
//    let minute = components.minute
//    let second = components.second
//
//    let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
//
//    return today_string
//  }
//}
