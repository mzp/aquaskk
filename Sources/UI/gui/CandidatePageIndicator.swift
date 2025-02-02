//
//  CandidatePageIndicator.swift
//  AquaSKKUI
//
//  Created by mzp on 1/30/25.
//

import AppKit

@objc(CandidatePageIndicator) public class CandidatePageIndicator: NSObject {
    private var attribuets: [NSAttributedString.Key: Any]
    private var indicator: NSAttributedString
    private var plate: NSBezierPath

    override public init() {
        let attribuets: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize),
            .foregroundColor: NSColor.white,
        ]
        let indicator = NSAttributedString(string: "888 / 888", attributes: attribuets)

        let size = indicator.size()
        let radius = 0.5 * size.height
        let rc = NSRect(origin: .init(x: radius, y: 0), size: size)
        let topLeft = NSPoint(x: rc.minX, y: rc.maxY)
        let bottomRight = NSPoint(x: rc.maxX, y: rc.minY)
        let plate = NSBezierPath(rect: rc)
        plate.move(to: bottomRight)
        plate.appendArc(
            withCenter: .init(x: bottomRight.x, y: bottomRight.y + radius),
            radius: radius,
            startAngle: 270,
            endAngle: 90
        )
        plate.move(to: topLeft)
        plate.appendArc(
            withCenter: .init(x: topLeft.x, y: topLeft.y - radius),
            radius: radius,
            startAngle: 90,
            endAngle: 270
        )

        self.indicator = indicator
        self.attribuets = attribuets
        self.plate = plate
        super.init()
    }

    @objc public func setPage(_ page: NSRange) {
        indicator = .init(
            string: String(format: "%3ld / %-3ld", page.location, page.length),
            attributes: attribuets
        )
    }

    @objc public func size() -> CGSize {
        return plate.bounds.size
    }

    @objc(drawAtPoint:)
    public func draw(at point: NSPoint) {
        let xform = NSAffineTransform()
        xform.translateX(by: point.x, yBy: point.y)
        xform.concat()

        NSColor.systemGray.setFill()
        plate.fill()

        let plateSize = plate.bounds.size
        let indicatorSize = indicator.size()
        indicator.draw(
            at: .init(
                x: (plateSize.width - indicatorSize.width) / 2,
                y: (plateSize.height - indicatorSize.height) / 2
            )
        )
        xform.invert()
        xform.concat()
    }
}
