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
    @objc public var isHowdyIndexType = false
    @objc public var lineWidth = 3.0
    @objc public var circleRadius = 4.0
    @objc public var enableLeftAxis = false
    @objc public var enableDataZones = true
    @objc public var enableCustomMarker = false
    @objc public var transparentBackground = false
    @objc public var lineColor = WellbeingChartColor.black
    @objc public var benchmark: [Double]? = nil
    @objc public var gradientBackground = false
    @objc public var enableCustomLegend = false
    
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
        circleRadius: Double = 4.0,
        lineColor: UIColor = UIColor.black,
        enableLeftAxis: Bool = false,
        enableDataZones: Bool = true,
        enableCustomMarker: Bool = false,
        transparentBackground: Bool = false,
        benchmark: [Double]? = nil,
        isHowdyIndexType: Bool = false,
        gradientBackground: Bool = false,
        enableCustomLegend: Bool = false
    ) -> LineChartView {
        self.whiteBackground = whiteBackground
        self.hideAxisAndLabels = hideAxisAndLabels
        self.isHowdyScoreType = isHowdyScoreType
        self.lineWidth = lineWidth
        self.circleRadius = circleRadius
        self.lineColor = lineColor
        self.enableLeftAxis = enableLeftAxis
        self.enableDataZones = enableDataZones
        self.enableCustomMarker = enableCustomMarker
        self.transparentBackground = transparentBackground
        self.benchmark = benchmark
        self.isHowdyIndexType = isHowdyIndexType
        self.gradientBackground = gradientBackground
        self.enableCustomLegend = enableCustomLegend

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
        
        if enableCustomMarker {
            lineChartView.highlightPerTapEnabled = true
            lineChartView.highlightPerDragEnabled = true
        }
        
        return lineChartView
    }()
    
    private func setCustomMarker(labels: [String])
    {
        let marker = WellbeingLineChartMarker(labels: labels,
                                              font: UIFont(name: "Poppins-Regular", size: 12.0) ?? .systemFont(ofSize: 12.0),
                                              textColor: UIColor.white.withAlphaComponent(0.6),
                                              insets: UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0))
                        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 40, height: 20)
        chartView.marker = marker
    }
    
    private func setUpChart(data: [Double], labels: [String]) {
        var entries: [ChartDataEntry] = []
        
        for (index, element) in data.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: element))
        }

        if enableCustomMarker {
            setCustomMarker(labels: labels)
        }
        
        self.setData(entries: entries)
        self.setXAxis(labels: labels)
        self.setHorizontalScroll(labels: labels)
    }
    
    private func getDataSet(entries: [ChartDataEntry], isBenchmark: Bool = false) -> LineChartDataSet {
        let color = lineColor
        let dataSet: LineChartDataSet = LineChartDataSet(entries: entries, label: "")
        
        dataSet.lineWidth = self.lineWidth
        dataSet.circleRadius = self.circleRadius
        dataSet.circleHoleRadius = self.circleRadius
        dataSet.setColor(color)
        dataSet.setCircleColor(color)
        dataSet.circleHoleColor = color
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        dataSet.highlightLineWidth = 0
        
        if isBenchmark {
            dataSet.lineWidth = 1.5
            dataSet.lineDashLengths = [5,8]
            dataSet.circleRadius = 0
            dataSet.circleHoleRadius = 0
            dataSet.setColor(UIColor.white)
            dataSet.drawValuesEnabled = false
            dataSet.drawFilledEnabled = false
            dataSet.highlightLineWidth = 0
            
            if whiteBackground {
                dataSet.setColor(WellbeingChartColor.grey)
            }
        }
        
        return dataSet
    }
    
    private func getZoneDataSet(
        entries: [ChartDataEntry],
        threshold: Double,
        color: NSUIColor,
        nextColor: NSUIColor,
        colorLocations: [CGFloat]
    ) -> LineChartDataSet {
        var zoneData: [ChartDataEntry] = []
        
        for entry in entries {
            zoneData.append(ChartDataEntry(x: entry.x, y: threshold))
        }
        
        let zoneDataSet: LineChartDataSet = LineChartDataSet(entries: zoneData, label: "")
        
        zoneDataSet.lineWidth = 0
        zoneDataSet.highlightLineWidth = 0
        zoneDataSet.formLineWidth = 0
        zoneDataSet.drawFilledEnabled = false
        zoneDataSet.drawValuesEnabled = false
        zoneDataSet.drawCirclesEnabled = false
        zoneDataSet.drawCircleHoleEnabled = false
        
        let gradientColors = [color.cgColor, nextColor.cgColor, UIColor.white.cgColor] as CFArray
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        
        if !transparentBackground {
            zoneDataSet.drawFilledEnabled = true
            zoneDataSet.fillColor = color;
            zoneDataSet.setColor(color);
            zoneDataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        }
        
        if !transparentBackground && gradientBackground {
            let color1 = UIColor(red: 13/255.0, green: 48/255.0, blue: 83/255.0, alpha: 0.6).cgColor
            let color2 = UIColor(red: 13/255.0, green: 48/255.0, blue: 83/255.0, alpha: 0.0).cgColor
            let gradientColors2 = [color1, color2] as CFArray
            let locations: [CGFloat] = [0.8623, 1]
            
            let gradient2 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors2, locations: locations)
            
            zoneDataSet.drawFilledEnabled = true
            zoneDataSet.fill = LinearGradientFill(gradient: gradient2!, angle: 90.0)
        }
        
        return zoneDataSet
    }
    
    private func setData(entries: [ChartDataEntry]) {
        var data: ChartData? = nil
        let dataSet: LineChartDataSet = self.getDataSet(entries: entries)
        
        if self.isHowdyIndexType {
            let benchmarkDataSet = getBenchmarkDataSet()
            
            dataSet.mode = .cubicBezier
            benchmarkDataSet.mode = .cubicBezier

            let dataSetZones = getChartDataSetHowdyIndexZone(entries: entries)
            let sets = [dataSetZones, dataSet, benchmarkDataSet]
            
            data = LineChartData(dataSets: sets)
        } else {
            let dataSetZones = self.isHowdyScoreType ? getScoreChartDataSetZones(entries: entries) : getChartDataSetZones(entries: entries)
            let greenZoneDataSet = dataSetZones.green
            let yellowZoneDataSet = dataSetZones.yellow
            let redZoneDataSet = dataSetZones.red
            
            let sets = enableDataZones ? gradientBackground ? [greenZoneDataSet, dataSet] : [greenZoneDataSet, yellowZoneDataSet, redZoneDataSet, dataSet] : [dataSet]
            data = LineChartData(dataSets: sets)
        }
        
        data!.isHighlightEnabled = enableCustomMarker
        
        chartView.data = data
    }
    
    private func setXAxis(labels: [String]) {
        let xAxis = chartView.xAxis
        xAxis.drawLabelsEnabled = self.hideAxisAndLabels ? false : true
        xAxis.granularity = 1
        xAxis.gridLineWidth = 1.5
        xAxis.gridColor = self.lineColor == UIColor.white ? UIColor.white.withAlphaComponent(0.2) : WellbeingChartColor.grey
        xAxis.labelTextColor = self.lineColor
        xAxis.labelFont = self.customFont
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = self.hideAxisAndLabels || isHowdyIndexType ? false : true
        xAxis.drawGridLinesEnabled = self.hideAxisAndLabels ? false : true
        xAxis.drawGridLinesBehindDataEnabled = false
        xAxis.wordWrapEnabled = true
        xAxis.wordWrapWidthPercent = 0.8
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
            leftAxis.axisMaximum = 110
            leftAxis.axisMinimum = 0
            leftAxis.drawLimitLinesBehindDataEnabled = false
        }

        chartView.extraRightOffset = 35
        chartView.extraLeftOffset = 0
        chartView.extraBottomOffset = 20
        chartView.extraTopOffset = 20
        
        if enableCustomLegend {
            let gradientView = WellbeingLineChartLegend(frame: CGRect(x: 0, y: 0, width: 10, height: 100))
            gradientView.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(gradientView)

            NSLayoutConstraint.activate([
                gradientView.leadingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -35),
                gradientView.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 20),
                gradientView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -41),
                gradientView.widthAnchor.constraint(equalToConstant: 10)
            ])
        }
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
            threshold: 110.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.green,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightGreen,
            colorLocations: [1.0, 0.75, 0.5]
        )
        
        let yellowZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            threshold: 50.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.yellow,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightYellow,
            colorLocations: [0.5, 0.4, 0.35]
        )
        
        let redZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            threshold: 35.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.red,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightRed,
            colorLocations: [0.35, 0.2, 0.0]
        )
        
        return (greenZoneDataSet, yellowZoneDataSet, redZoneDataSet)
    }

    private func getChartDataSetHowdyIndexZone(entries: [ChartDataEntry])
        -> LineChartDataSet {
        let blueZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            threshold: 110.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.blue,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightBlue,
            colorLocations: [1, 0.15, 0.05]
        )
            
        return blueZoneDataSet
    }
    
    private func getScoreChartDataSetZones(entries: [ChartDataEntry])
        -> (green: LineChartDataSet, yellow: LineChartDataSet, red: LineChartDataSet) {
        let greenZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            threshold: 5.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.green,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightGreen,
            colorLocations: [1.0, 0.72, 0.52, 0.42]
        )
        
        let yellowZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            threshold: 2.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.yellow,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightYellow,
            colorLocations: [0.4, 0.3, 0.21]
        )
        
        let redZoneDataSet: LineChartDataSet = self.getZoneDataSet(
            entries: entries,
            threshold: 1.0,
            color: whiteBackground ? UIColor.white : WellbeingChartColor.red,
            nextColor: whiteBackground ? UIColor.white : WellbeingChartColor.lightRed,
            colorLocations: [0.2, 0.1, 0.0]
        )
        
        return (greenZoneDataSet, yellowZoneDataSet, redZoneDataSet)
    }
    
    private func getBenchmarkDataSet() -> LineChartDataSet
    {
        var chartDataEntries: [ChartDataEntry] = []
        
        for (index, element) in benchmark!.enumerated() {
            chartDataEntries.append(ChartDataEntry(x: Double(index), y: element))
        }
        
        let dataSet: LineChartDataSet = self.getDataSet(entries: chartDataEntries, isBenchmark: true)
        
        return dataSet
    }
}
