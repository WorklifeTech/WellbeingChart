//
//  ViewController.swift
//  WellbeingChart
//
//  Created by radohecko on 12/03/2020.
//  Copyright (c) 2020 radohecko. All rights reserved.
//

import UIKit
import WellbeingChart
import TinyConstraints

class ViewController: UIViewController {

    @IBOutlet weak var chartViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let data: [Double] = [
            40.0,
            50.0,
            80.0,
            25.0,
            32.0,
            54.0,
            18.0,
            75.0
        ]
        
        let labels: [String] = [
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep"
        ]
        
        let chartView = WellbeingLineChart().getChart(data: data, labels: labels)
        
        chartViewContainer.addSubview(chartView)
        chartView.width(to: chartViewContainer)
        chartView.height(245)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

