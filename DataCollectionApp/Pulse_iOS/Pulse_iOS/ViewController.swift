//
//  ViewController.swift
//  Pulse_iOS
//
//  Created by Mike on 2018-10-19.
//  Copyright © 2018 Mike. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, ppgOrganDelegate {

  @IBOutlet weak var lineChartView: LineChartView!
  
  private let captureOrgan: PulseCaptureOrgan = PulseCaptureOrgan()
  private lazy var ppgOrgan: PulsePPGOrgan = {
    return PulsePPGOrgan(captureOrgan: self.captureOrgan)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(_ animated: Bool) {
    ppgOrgan.delegate = self
    ppgOrgan.beat()
  }
  
  func ppgOrganDidBeat(with values: [ChartDataEntry]) {
    
    let line1 = LineChartDataSet(values: values, label: "PPG")
    line1.colors = [UIColor.red]
    line1.drawCirclesEnabled = false
    line1.mode = .cubicBezier
    line1.cubicIntensity = 0.2
    
    let data = LineChartData()
    data.addDataSet(line1)
    data.setValueTextColor(NSUIColor.clear)
    
    lineChartView.data = data
    lineChartView.setScaleEnabled(false)
    lineChartView.leftAxis.minWidth = 1.0
    
    
    lineChartView.chartDescription?.text = "My Awesome Chart"
  }
}

