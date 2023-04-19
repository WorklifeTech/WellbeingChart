//
//  WellbeingLineChart.swift
//  WellbeingChart
//
//  Created by Rado Hečko on 02/12/2020.
//

import Foundation
import Charts

@objc public class WellbeingLineChart: NSObject {
    
    @objc public var whiteBackground = false
    @objc public var hideAxisAndLabels = false
    @objc public var isHowdyScoreType = false
    @objc public var lineWidth = 3.0
    @objc public var circleRadius = 4.0
    @objc public var enableLeftAxis = false
    @objc public var enableDataZones = true
    
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
    
    @objc public func getChart(
        data: [Double],
        labels: [String],
        whiteBackground: Bool = false,
        hideAxisAndLabels: Bool = false,
        isHowdyScoreType: Bool = false,
        lineWidth: Double = 3.0,
        circleRadius: Double = 4.0
        enableLeftAxis: Bool = false,
        enableDataZones: Bool = true,
    ) -> LineChartView {
        self.whiteBackground = whiteBackground
        self.hideAxisAndLabels = hideAxisAndLabels
        self.isHowdyScoreType = isHowdyScoreType
        self.lineWidth = lineWidth
        self.circleRadius = circleRadius
        self.enableLeftAxis = enableLeftAxis
        self.enableDataZones = enableDataZones

        if data.count > 1 && data.count == labels.count {
            self.setUpChart(data: data, labels: labels)
        }

        return chartView
    }
    
    private lazy var chartView: LineChartView = {
        let lineChartView = LineChartView()
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = enableLeftAxis
        
        if enableLeftAxis {
            lineChartView.leftAxis.drawLabelsEnabled = false
            lineChartView.leftAxis.gridColor = UIColor.white.withAlphaComponent(0)
            lineChartView.leftAxis.axisLineColor = UIColor.white.withAlphaComponent(0)
        }
        
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaximum = self.isHowdyScoreType ? 5 : 100
        lineChartView.doubleTapToZoomEnabled = false
        
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
        let dataSet: LineChartDataSet = LineChartDataSet(entries: entries, label: "")
        
        dataSet.lineWidth = self.lineWidth
        dataSet.circleRadius = self.circleRadius
        dataSet.circleHoleRadius = self.circleRadius
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
        
        let zoneDataSet: LineChartDataSet = LineChartDataSet(entries: zoneData, label: "")
        
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
        
        zoneDataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        
        return zoneDataSet
    }
    
    private func setData(entries: [ChartDataEntry]) {
        let dataSet: LineChartDataSet = self.getDataSet(entries: entries)
        
        let dataSetZones = self.isHowdyScoreType ? getScoreChartDataSetZones(entries: entries) : getChartDataSetZones(entries: entries)
        let greenZoneDataSet = dataSetZones.green
        let yellowZoneDataSet = dataSetZones.yellow
        let redZoneDataSet = dataSetZones.red
        
        let sets = enableDataZones ? [greenZoneDataSet, yellowZoneDataSet, redZoneDataSet, dataSet] : [dataSet]
        let data = LineChartData(dataSets: sets)
        
        data.isHighlightEnabled = false
        
        chartView.data = data
    }
    
    private func setXAxis(labels: [String]) {
        let xAxis = chartView.xAxis
        xAxis.drawLabelsEnabled = self.hideAxisAndLabels ? false : true
        xAxis.granularity = 1
        xAxis.gridLineWidth = 1.5
        xAxis.gridColor = WellbeingChartColor.grey
        xAxis.labelTextColor = WellbeingChartColor.black
        xAxis.labelFont = self.customFont
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = self.hideAxisAndLabels ? false : true
        xAxis.drawGridLinesEnabled = self.hideAxisAndLabels ? false : true
        xAxis.drawGridLinesBehindDataEnabled = false
        xAxis.wordWrapEnabled = true
        xAxis.wordWrapWidthPercent = 0.7
        xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return labels[Int(index)]
        })
        
        if enableLeftAxis {
            let ll1 = ChartLimitLine(limit: 50, label: "")
            ll1.lineWidth = 4
            ll1.lineColor = UIColor.white.withAlphaComponent(0.2)
            ll1.labelPosition = .rightTop
            ll1.valueFont = customFont
            ll1.lineDashLengths = [5,5]
            
            let leftAxis = chartView.leftAxis
            leftAxis.removeAllLimitLines()
            leftAxis.addLimitLine(ll1)
            leftAxis.axisMaximum = 100
            leftAxis.axisMinimum = 0
            leftAxis.drawLimitLinesBehindDataEnabled = false
        }
        
        chartView.extraRightOffset = 25
        chartView.extraLeftOffset = 25
        chartView.extraBottomOffset = 20
    }
    
    private func setHorizontalScroll(labels: [String]) {
        let numberOfItemsIn6Months = 5.0;
        let numberOfItemsToShow = min(Double(labels.count - 1), numberOfItemsIn6Months);
        
        chartView.setVisibleXRangeMaximum(numberOfItemsToShow);
        
        let handler = chartView.viewPortHandler;
        let labelCount = Double(labels.count - 1)
        
        handler.setMaximumScaleX( CGFloat(labelCount / numberOfItemsToShow));
        
        chartView.moveViewToX(labelCount)
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = true
    }
    
    private func getChartDataSetZones(entries: [ChartDataEntry])
        -> (green: LineChartDataSet, yellow: LineChartDataSet, red: LineChartDataSet) {
        let greenZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 100.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.green,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightGreen,
            colorLocations: [1.0, 0.75, 0.5]
        )
        
        let yellowZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 50.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.yellow,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightYellow,
            colorLocations: [0.5, 0.4, 0.35]
        )
        
        let redZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 35.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.red,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightRed,
            colorLocations: [0.35, 0.2, 0.0]
        )
        
        return (greenZoneDataSet, yellowZoneDataSet, redZoneDataSet)
    }
    
    private func getScoreChartDataSetZones(entries: [ChartDataEntry])
        -> (green: LineChartDataSet, yellow: LineChartDataSet, red: LineChartDataSet) {
        let greenZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 5.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.green,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightGreen,
            colorLocations: [1.0, 0.72, 0.52, 0.42]
        )
        
        let yellowZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 2.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.yellow,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightYellow,
            colorLocations: [0.4, 0.3, 0.21]
        )
        
        let redZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            treshold: 1.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.red,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightRed,
            colorLocations: [0.2, 0.1, 0.0]
        )
        
        return (greenZoneDataSet, yellowZoneDataSet, redZoneDataSet)
    }
}
