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

    @IBOutlet weak var containerView: UIView!
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
            18.0, // split point custom marker
            75.0,
            40.0,
            60.0,
            80.0,
            25.0,
            90.0
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
            "1 Feb \n2020",
            "12 Mar \n2020",
            "10 Apr \n2020",
            "2 May \n2020",
            "18 Jun \n2020",
            "21 Jul \n2020",
            "30 Aug \n2020", // split point custom marker
            "22 Sep \n2020",
            "7 Oct \n2020",
            "9 Nov \n2020",
            "24 Dec \n2020",
            "5 Jan \n2021",
            "19 Feb \n2021"
        ]
        
        let isHowdyScoreType = false
        let isInterventionType = false
        let dataset = isHowdyScoreType ? scores : data
        
        var chartView = WellbeingLineChart()
            .getChart(
                data: dataset,
                labels: labels,
                whiteBackground: false,
                hideAxisAndLabels: false,
                isHowdyScoreType: isHowdyScoreType,
                lineWidth: 1,
                circleRadius: 1,
                lineColor: UIColor.black,
                enableLeftAxis: false,
                enableDataZones: true,
                enableCustomMarker: false,
                transparentBackground: false
            )
        
        if isInterventionType {
            chartView = WellbeingLineChart()
                .getChart(
                    data: dataset,
                    labels: labels,
                    whiteBackground: false,
                    hideAxisAndLabels: true,
                    isHowdyScoreType: isHowdyScoreType,
                    lineWidth: 2, // intervention style 2
                    circleRadius: 4, // intervention styke 4
                    lineColor: UIColor.white,
                    enableLeftAxis: true,
                    enableDataZones: false,
                    enableCustomMarker: true,
                    transparentBackground: true
                )
        }
        
        if #available(iOS 15.0, *), isInterventionType {
            containerView.backgroundColor = UIColor.systemCyan
            chartViewContainer.backgroundColor = UIColor.systemCyan
        }
        
        chartViewContainer.addSubview(chartView)
        chartView.width(to: chartViewContainer)
        chartView.height(245)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

