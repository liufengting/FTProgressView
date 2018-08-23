//
//  FTProgressView.swift
//  FTProgressView
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit

open class FTProgressView: UIView {
    
    public var progress: CGFloat = 0.0 {
        willSet {
            self.currentProgress = self.progress
            self.fromProgress = self.progress
            self.toProgress = newValue
        }
    }

    public var progressWidth: CGFloat = 3.0 {
        willSet {
            self.progressLayer.lineWidth = newValue
        }
    }

    public var trackWidth: CGFloat = 1.0 {
        willSet {
            self.trackLayer.lineWidth = newValue
        }
    }
    
    public var progressFillColor = UIColor.clear {
        willSet {
            self.progressBackgroundLayer.fillColor = newValue.cgColor
            self.progressBackgroundLayer.strokeColor = newValue.cgColor
        }
    }
    
    public var progressStrokeColor = UIColor.white {
        willSet {
            self.progressLayer.strokeColor = newValue.cgColor
        }
    }
    
    public var trackFillColor = UIColor.clear {
        willSet {
            self.trackLayer.fillColor = newValue.cgColor
        }
    }
    
    public var trackStrokeColor = UIColor.white {
        willSet {
            self.trackLayer.strokeColor = newValue.cgColor
        }
    }

    public var isClockwise = true {
        willSet {
            self.initialSetup(isInitial: false)
        }
    }

    public lazy var progressBackgroundLayer: CAShapeLayer = {
       let layer = CAShapeLayer()
        layer.lineWidth = 0.0
        layer.fillColor = self.progressFillColor.cgColor
        layer.strokeColor = self.progressFillColor.cgColor
        return layer
    }()
    
    public lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = kCALineCapButt
        layer.lineJoin = kCALineJoinRound
        layer.lineWidth = self.progressWidth
        layer.strokeColor = self.progressStrokeColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    public lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = self.trackWidth
        layer.fillColor = self.trackFillColor.cgColor
        layer.strokeColor = self.trackStrokeColor.cgColor
        return layer
    }()

    private var displayLink: CADisplayLink?
    private var currentProgress: CGFloat = 0.0
    private var fromProgress: CGFloat = 0.0
    private var toProgress: CGFloat = 0.0
    private var animationStartTime: CFTimeInterval = 0
    private var isDuringAnimation = false
    public var animationDuration: TimeInterval = 0.3

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup(isInitial: true)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup(isInitial: true)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup(isInitial: true)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateTrackLayer()
        self.updateProgreeLayerWithProgress(progress: self.currentProgress)
    }
    
    public func setProgress(progress: CGFloat, animated: Bool) {
        if self.isDuringAnimation {
            self.invalidateDisplayLink()
            self.updateProgreeLayerWithProgress(progress: self.toProgress)
        }
        self.progress = progress
        if animated {
            self.invalidateDisplayLink()
            self.isDuringAnimation = true
            self.animationStartTime = CACurrentMediaTime()
            self.displayLink = CADisplayLink(target: self, selector: #selector(commitDisplayLink(displayLink:)))
            self.displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        } else {
            self.updateProgreeLayerWithProgress(progress: self.progress)
        }
    }

    func initialSetup(isInitial: Bool) {
        self.updateTrackLayer()
        self.updateProgreeLayerWithProgress(progress: self.currentProgress);
        if isInitial && self.progress > 0 {
            self.setProgress(progress: self.currentProgress, animated: false);
        }
    }
    
    func radius() -> CGFloat {
        return (min(self.bounds.size.width, self.bounds.size.height))/2.0  - self.trackWidth/2.0
    }
    
    func centerPoint() -> CGPoint {
        return CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
    }
    
    func startAngle() -> CGFloat {
        return isClockwise ? CGFloat(-Double.pi/2.0) : CGFloat(3.0*Double.pi/2.0)
    }
    
    func endAngle() -> CGFloat {
        return isClockwise ? CGFloat(3.0*Double.pi/2.0): CGFloat(-Double.pi/2.0)
    }
    
    func strokPath() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: self.centerPoint(), radius: self.radius(), startAngle: self.startAngle(), endAngle: self.endAngle(), clockwise: self.isClockwise)
        return path
    }
    
    func progressBackgroundPath(progress: CGFloat) -> UIBezierPath {
        let radius = self.radius() - self.trackWidth/2.0 - self.progressWidth/2.0
        var endAngle = self.startAngle()
        let margin = CGFloat((Double.pi * 2.0 * Double(progress)))
        if isClockwise {
            endAngle += margin
        }else {
            endAngle -= margin
        }
        let path = UIBezierPath()
        path.move(to: self.centerPoint())
        path.addArc(withCenter: self.centerPoint(), radius: radius, startAngle: self.startAngle(), endAngle: endAngle, clockwise: self.isClockwise)
        path.close()
        return path
    }
    
    func progressPath(progress: CGFloat) -> UIBezierPath {
        let radius = self.radius() - self.trackWidth/2.0 - self.progressWidth/2.0
        var endAngle = self.startAngle()
        let margin = CGFloat((Double.pi * 2.0 * Double(progress)))
        if isClockwise {
            endAngle += margin
        }else {
            endAngle -= margin
        }
        let path = UIBezierPath(arcCenter: self.centerPoint(), radius: radius, startAngle: self.startAngle(), endAngle: endAngle, clockwise: self.isClockwise)
        return path
    }
    
    func updateTrackLayer() {
        self.trackLayer.path = self.strokPath().cgPath
        if self.trackLayer.superlayer == nil {
            self.layer.addSublayer(self.trackLayer)
        }
    }
    
    func updateProgreeLayerWithProgress(progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))
        self.progressBackgroundLayer.path = self.progressBackgroundPath(progress: p).cgPath
        self.progressLayer.path = self.progressPath(progress: p).cgPath
        if self.progressBackgroundLayer.superlayer == nil {
            self.layer.addSublayer(self.progressBackgroundLayer)
        }
        if self.progressLayer.superlayer == nil {
            self.layer.addSublayer(self.progressLayer)
        }
    }
    
    func invalidateDisplayLink() {
        if self.displayLink != nil {
            self.displayLink?.invalidate()
            self.isDuringAnimation = false
        }
    }
    
    @objc func commitDisplayLink(displayLink: CADisplayLink) {
        let percent = (displayLink.timestamp - self.animationStartTime)/self.animationDuration
        if (percent >= 1.0) {
            self.invalidateDisplayLink()
            self.currentProgress = self.toProgress
            self.updateProgreeLayerWithProgress(progress: self.toProgress)
            return
        }
        self.currentProgress = (self.fromProgress + CGFloat(percent) * (self.toProgress - self.fromProgress));
        self.updateProgreeLayerWithProgress(progress: self.currentProgress)
    }

}
