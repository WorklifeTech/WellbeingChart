//
//  WellbeingLineChart.swift
//  WellbeingChart
//
//  Created by Rado Hečko on 02/12/2020.
//

import Foundation
import Charts

@objc public class WellbeingLineChart: NSObject {
    
    var customFont: UIFont = .systemFont(ofSize: 12.0)
    
    @objc public override init() {
        let bundle = Bundle(for: WellbeingLineChart.self)
        let path = bundle.path(forResource: "Fonts", ofType: "bundle")
        let fontsBundle = Bundle(url: URL(fileURLWithPath: path!))
        
        let registered = UIFont.registerFont(
            bundle: fontsBundle!,
            fontName: "Poppins-Regular",
            fontExtension: "ttf"
        )
        
        if registered {
            self.customFont = UIFont(name: "Poppins-Regular", size: 12.0) ?? .systemFont(ofSize: 12.0)
        }
    }
    
    @objc public func getChart(data: [Double], labels: [String]) -> LineChartView {
        if data.count > 1 && data.count == labels.count {
            self.setUpChart(data: data, labels: labels)
        }

        return chartView
    }
    
    private lazy var chartView: LineChartView = {
        let lineChartView = LineChartView()
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaximum = 100
        
        return lineChartView
    }()
    
    private func setUpChart(data: [Double], labels: [String]) {
        var entries: [ChartDataEntry] = []
        
        for (index, element) in data.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: element))
        }
        
        self.setData(entries: entries)
        self.setXAxis(labels: labels)
        self.setHorizontalScroll(labels: labels)
    }
    
    private func getDataSet(entries: [ChartDataEntry]) -> LineChartDataSet {
        let color = WellbeingChartColor.black
        let dataSet: LineChartDataSet = LineChartDataSet(entries: entries, label: nil)
        
        dataSet.lineWidth = 3.0
        dataSet.circleRadius = 4.0
        dataSet.circleHoleRadius = 4.0
        dataSet.setColor(color)
        dataSet.setCircleColor(color)
        dataSet.circleHoleColor = color
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        
        return dataSet
    }
    
    private func getZoneDataSet(
        entries: [ChartDataEntry],
        treshold: Double,
        color: NSUIColor,
        nextColor: NSUIColor,
        colorLocations: [CGFloat]
    ) -> LineChartDataSet {
        var zoneData: [ChartDataEntry] = []
        
        for entry in entries {
            zoneData.append(ChartDataEntry(x: entry.x, y: treshold))
        }
        
        let zoneDataSet: LineChartDataSet = LineChartDataSet(entries: zoneData, label: nil)
        
        zoneDataSet.lineWidth = 0
        zoneDataSet.formLineWidth = 0
        zoneDataSet.drawFilledEnabled = false
        zoneDataSet.drawValuesEnabled = false
        zoneDataSet.drawCirclesEnabled = false
        zoneDataSet.drawCircleHoleEnabled = false
        zoneDataSet.drawFilledEnabled = true
        zoneDataSet.fillColor = color;
        zoneDataSet.setColor(color);
        
        let gradientColors = [color.cgColor, nextColor.cgColor, UIColor.white.cgColor] as CFArray
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        
        zoneDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        
        return zoneDataSet
    }
    
    private func setData(entries: [ChartDataEntry]) {
        let dataSet: LineChartDataSet = self.getDataSet(entries: entries)
        
        let greenZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 100.0,
            color: WellbeingChartColor.green,
            nextColor: WellbeingChartColor.lightGreen,
            colorLocations: [1.0, 0.75, 0.5]
        )
        
        let yellowZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 50.0,
            color: WellbeingChartColor.yellow,
            nextColor: WellbeingChartColor.lightYellow,
            colorLocations: [0.5, 0.4, 0.35]
        )
        
        let redZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 35.0,
            color: WellbeingChartColor.red,
            nextColor: WellbeingChartColor.lightRed,
            colorLocations: [0.35, 0.2, 0.0]
        )
        
        let data = LineChartData(dataSets: [greenZoneDataSet, yellowZoneDataSet, redZoneDataSet, dataSet])
        
        data.highlightEnabled = false
        
        chartView.data = data
    }
    
    private func setXAxis(labels: [String]) {
        let xAxis = chartView.xAxis
        
        xAxis.granularity = 1
        xAxis.gridLineWidth = 1.5
        xAxis.gridColor = WellbeingChartColor.grey
        xAxis.labelTextColor = WellbeingChartColor.black
        xAxis.labelFont = self.customFont
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.drawGridLinesBehindDataEnabled = false
        xAxis.wordWrapEnabled = true
        xAxis.wordWrapWidthPercent = 0.7
        xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return labels[Int(index)]
        })
        
        chartView.extraRightOffset = 20
        chartView.extraLeftOffset = 20
        chartView.extraBottomOffset = 20
    }
    
    private func setHorizontalScroll(labels: [String]) {
        let numberOfItemsIn6Months = 5.0;
        let numberOfItemsToShow = min(Double(labels.count - 1), numberOfItemsIn6Months);
        
        chartView.setVisibleXRangeMaximum(numberOfItemsToShow);
        
        let handler = chartView.viewPortHandler;
        let labelCount = Double(labels.count - 1)
        
        handler!.setMaximumScaleX( CGFloat(labelCount / numberOfItemsToShow));
        
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = true
    }
    
    private struct WellbeingChartColor {
        static let green = UIColor(red: 0.1686, green: 1, blue: 0.502, alpha: 1.0)
        static let lightGreen = UIColor(red: 0.1686, green: 1, blue: 0.502, alpha: 1.0)
        static let yellow = UIColor(red: 0.949, green: 1, blue: 0.2471, alpha: 1.0)
        static let lightYellow = UIColor(red: 1, green: 0.9333, blue: 0.6667, alpha: 1.0)
        static let red = UIColor(red: 1, green: 0.4353, blue: 0.3098, alpha: 1.0)
        static let lightRed = UIColor(red: 1, green: 0.5882, blue: 0.498, alpha: 1.0)
        static let black = UIColor(red: 0.1882, green: 0.1882, blue: 0.1882, alpha: 1.0)
        static let grey = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0)
    }
}
