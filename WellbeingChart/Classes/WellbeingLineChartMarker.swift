//
//  WellbeingLineChartMarker.swift
//  WellbeingChart
//
//  Created by Rado Hečko on 15/02/2023.
//


import Charts
#if canImport(UIKit)
    import UIKit
#endif

open class WellbeingLineChartMarker: MarkerImage
{
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    @objc open var labels: [String] = []

    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    fileprivate var _color = UIColor.white

    @objc public init(labels: [String], font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.labels = labels
        self.font = font
        self.textColor = textColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        _paragraphStyle?.lineSpacing = 0.7
        _paragraphStyle?.lineHeightMultiple = 0.7
        
        super.init()
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset

        let height = size.height
        let padding: CGFloat = 8.0
        
        var origin = point
        origin.y -= height

        if origin.y + offset.y < 0 {
            offset.y = height + padding;
        }

        return offset
    }

    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }

        let offset = self.offsetForDrawing(atPoint: point)
        let size = CGSize(width: self.size.width, height: self.size.height)

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)

        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()
        context.setFillColor(UIColor.clear.cgColor)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setLineWidth(1)
        
        let spaceOffsetY = point.y - size.height
        
        if offset.y == 0 {
            drawPointerLine(context: context, rect: rect, spaceOffsetY: spaceOffsetY)
        } else {
            drawPointerLineReverse(context: context, rect: rect, spaceOffsetY: spaceOffsetY, point: point)
        }

        if offset.y > 0 {
            rect.origin.y += self.insets.top + (offset.y / 2) - 3
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        rect.origin.y -= spaceOffsetY

        UIGraphicsPushContext(context)

        label.draw(in: rect, withAttributes: _drawAttributes)
        
        drawPointerCircles(context: context, point: point)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if entry.y >= 0 && entry.y <= 35 {
            _color = WellbeingChartColor.red
        }
        else if entry.y >= 36 && entry.y <= 50 {
            _color = WellbeingChartColor.yellow
        }
        else if entry.y >= 51 && entry.y <= 70 {
            _color = WellbeingChartColor.lightGreen
        }
        else if entry.y >= 71 && entry.y <= 90 {
            _color = WellbeingChartColor.lightGreen
        }
        else {
            _color = WellbeingChartColor.green
        }
        
        setLabel(String(labels[Int(entry.x)]))
    }

    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel

        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor

        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)

        self.size = size
    }
    
    private func drawPointerLine(context: CGContext, rect: CGRect, spaceOffsetY: Double)
    {
        let originY = rect.origin.y - spaceOffsetY
        
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x,
            y: originY))
        
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: originY))

        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: originY + (rect.size.height / 2)))
        
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width / 2,
            y: originY + rect.size.height / 2))
        
        context.drawPath(using: .fillStroke)
        
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x + (rect.size.width / 2),
            y: originY + rect.size.height / 2 + 5))
        
        context.setStrokeColor(textColor.cgColor)
        
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width / 2,
            y: originY + rect.size.height + 2 + spaceOffsetY))
        
        context.drawPath(using: .fillStroke)
    }
    
    private func drawPointerLineReverse(context: CGContext, rect: CGRect, spaceOffsetY: Double, point: CGPoint)
    {
        var originY = rect.origin.y - spaceOffsetY
        let offset = self.offsetForDrawing(atPoint: point)

        if (spaceOffsetY < 0) {
            originY = 5
        }

        originY = point.y

        context.beginPath()
        context.move(to: CGPoint(
            x: point.x,
            y: originY))

        context.addLine(to: CGPoint(
            x: point.x,
            y: originY + offset.y))

        context.setStrokeColor(textColor.cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    private func drawPointerCircles(context: CGContext, point: CGPoint)
    {
        let circleRadius = 7.0
        let holeRadius = 5.0
        
        let circleRect = CGRect(x: point.x - circleRadius, y: point.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
        let holeRect = CGRect(x: point.x - holeRadius, y: point.y - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: circleRect)
        
        context.setFillColor(_color.cgColor)
        context.fillEllipse(in: holeRect)
    }
    
}
