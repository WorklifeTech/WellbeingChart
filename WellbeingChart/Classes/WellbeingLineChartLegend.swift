//
//  WellbeingLineChartLegend.swift
//  WellbeingChart
//
//  Created by Rado Hečko on 20/06/2025.
//


import UIKit

class WellbeingLineChartLegend: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
            UIColor(hex: "#58D289").cgColor,  // Green
            UIColor(hex: "#FFC700").cgColor,  // Yellow
            UIColor(hex: "#FFC700").cgColor,  // Yellow again
            UIColor(hex: "#D82001").cgColor,  // Red
            UIColor(hex: "#D82001").cgColor   // Red again
        ]

        gradientLayer.locations = [
            0.4063,
            0.5,
            0.6927,
            0.8177,
            1.0
        ] as [NSNumber]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true

        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 7
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the gradient resizes with the view
        layer.sublayers?.first?.frame = bounds
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1.0
        )
    }
}
