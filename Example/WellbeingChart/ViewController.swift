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
            75.0,
            40.0,
            50.0,
            80.0,
            25.0,
            32.0
        ]
        
        let scores: [Double] = [
            4.0,
            5.0,
            3.8,
            2.5,
            3.2,
            4.0,
            1.8,
            3.4,
            4.0,
            5.0,
            2.8,
            2.5,
            3.2
        ]
        
        let labels: [String] = [
            "1 Feb 2020",
            "12 Mar 2020",
            "10 Apr 2020",
            "2 May 2020",
            "18 Jun 2020",
            "21 Jul 2020",
            "30 Aug 2020",
            "22 Sep 2020",
            "7 Oct 2020",
            "9 Nov 2020",
            "24 Dec 2020",
            "5 Jan 2021",
            "19 Feb 2021"
        ]
        
        let isHowdyScoreType = false
        let dataset = isHowdyScoreType ? scores : data
        
        let chartView = WellbeingLineChart()
            .getChart(
                data: dataset,
                labels: labels,
                whiteBackground: false,
                hideAxisAndLabels: false,
                isHowdyScoreType: isHowdyScoreType,
                lineWidth: 1,
                circleRadius: 1
            )
        
        chartViewContainer.addSubview(chartView)
        chartView.width(to: chartViewContainer)
        chartView.height(245)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

