////
////  ViewController.swift
////  Pulse_iOS
////
////  Created by Mike on 2018-10-19.
////  Copyright © 2018 Mike. All rights reserved.
////
//
//import UIKit
//import Charts
//
//class ViewController: UIViewController, ppgOrganDelegate {
//
//  @IBOutlet weak var lineChartView: LineChartView!
//  @IBOutlet weak var endCaptureButton: UIButton!
//  
//  private let captureOrgan: PulseCaptureOrgan = PulseCaptureOrgan()
//  private var ppgCSV: [String:Double] = [:]
//  private var ppg: [Double] = []
//  private var ppgChartData: [ChartDataEntry] = []
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
//  func ppgOrganDidBeat() {
//    // Keep the viewing window at 100 samples
//    if self.ppgChartData.count > 100 {
//      self.ppgChartData.removeFirst()
//    }
//    
//    let line1 = LineChartDataSet(values: self.ppgChartData, label: "PPG")
//    line1.colors = [UIColor.red]
//    line1.drawCirclesEnabled = false
//    line1.mode = .cubicBezier
//    line1.cubicIntensity = 0.2
//
//    let data = LineChartData()
//    data.addDataSet(line1)
//    data.setValueTextColor(NSUIColor.clear)
//
//    self.lineChartView.data = data
//    self.lineChartView.setScaleEnabled(false)
//    self.lineChartView.leftAxis.minWidth = 1.0
//    self.lineChartView.chartDescription?.text = "My Awesome Chart"
//  }
//  
//  func ppgOrgan(_ ppgOrgan: PulsePPGOrgan, didCapture ppgValue: Double) {
//    ppg.append(ppgValue)
//    
//    // Update chart data
//    let chartData = ChartDataEntry(x: frames, y: ppgValue)
//    frames += 1
//    ppgChartData.append(chartData)
//
//    DispatchQueue.main.async {
//      self.ppgOrganDidBeat()
//    }
//    
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
//    
//  }
//}
