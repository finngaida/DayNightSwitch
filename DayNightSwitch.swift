//
//  DayNightSwitch
//  DayNightSwitch
//
//  Created by Finn Gaida on 02.09.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

import UIKit

/// View holding the managing of the knob and its subviews
@IBDesignable internal class Knob: UIView {
    
    /// some color constants
    let onKnobColor = UIColor(red: 0.882, green: 0.765, blue: 0.325, alpha: 1)
    let onSubviewColor = UIColor(red: 0.992, green: 0.875, blue: 0.459, alpha: 1)
    let offKnobColor = UIColor(red: 0.894, green: 0.902, blue: 0.788, alpha: 1)
    let offSubviewColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    /// Visual state of the knob, animates changes
    @IBInspectable var on: Bool {
        didSet {
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { 
                
                self.backgroundColor = self.on ? self.onKnobColor : self.offKnobColor
                
                if let v = self.subview {
                    v.backgroundColor = self.on ? self.onSubviewColor : self.offSubviewColor
                }
                
                }, completion: nil)
            
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { 
                
                if let v = self.subview {
                    v.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * (self.on ? 0.2 : -0.2))
                }
                
                }, completion: nil)
            
            let cache = self.expanded
            self.expanded = cache
        }
    }
    
    /// Horizontally expanded state of the knob, animates changes
    var expanded: Bool {
        didSet {
            
            guard let sup = self.superview as? DayNightSwitch, sub = self.subview, dots = self.craters else { return }
            let newWidth = self.frame.height * (self.expanded ? 1.25 : 1)
            let x = self.on ? sup.frame.width - newWidth - sup.knobMargin : self.frame.origin.x
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.frame = CGRectMake(x, self.frame.origin.y, newWidth, self.frame.height)
                sub.center = CGPointMake(self.on ? self.frame.width - self.frame.height / 2 : self.frame.height / 2, sub.center.y)
                
                dots.forEach({ $0.alpha = self.on ? 0 : 1 })
                
                }, completion: nil)
        }
    }
    
    /// Distance from knob to subview circle
    var subviewMargin: CGFloat {
        get {
            return self.frame.height / 12
        }
    }
    
    /// Round subview of the knob
    var subview: UIView?
    
    /**
     Sets up the `subview` with the craters as well
     
     - returns: the view
     */
    func setupSubview() -> UIView {
    
        let v = UIView(frame: CGRectMake(subviewMargin, subviewMargin, self.frame.width - subviewMargin * 2, self.frame.height - subviewMargin * 2))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = v.frame.height / 2
        v.backgroundColor = offSubviewColor
        
        setupCraters().forEach { v.addSubview($0) }
        
        subview = v
        return v
    }
    
    /// Circular subviews on the off state `subview`
    var craters: [UIView]?
    
    /**
     Sets up three craters
     
     - returns: array of set up views
     */
    func setupCraters() -> [UIView] {
        
        // shortcuts
        let w = self.frame.width
        let h = self.frame.height
        
        let topLeft = UIView(frame: CGRectMake(0, h * 0.1, w * 0.2, w * 0.2))
        let topRight = UIView(frame: CGRectMake(w * 0.5, 0, w * 0.3, w * 0.3))
        let bottom = UIView(frame: CGRectMake(w * 0.4, h * 0.5, w * 0.25, w * 0.25))
        
        let all = [topLeft, topRight, bottom]
        all.forEach { (v) in
            v.backgroundColor = offSubviewColor
            v.layer.masksToBounds = true
            v.layer.cornerRadius = v.frame.height / 2
            v.layer.borderColor = offKnobColor.CGColor
            v.layer.borderWidth = subviewMargin
        }
        
        craters = all
        return all
    }
    
    override init(frame: CGRect) {
        self.on = false
        self.expanded = false
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = offKnobColor
        
        self.addSubview(setupSubview())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// A switch inspired by [Dribbble](https://dribbble.com/shots/1909289-Day-Night-Toggle-Button-GIF)
@IBDesignable public class DayNightSwitch: UIView {
    
    // some constant colors
    let offColor = UIColor(red: 0.235, green: 0.255, blue: 0.271, alpha: 1)
    let offBorderColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1)
    let onColor = UIColor(red: 0.627, green: 0.894, blue: 0.98, alpha: 1)
    let onBorderColor = UIColor(red: 0.533, green: 0.769, blue: 0.843, alpha: 1)

    /// Width of the darker border of the background
    public var borderWidth: CGFloat {
        get {
            return self.frame.height / 7
        }
    }
    
    /// Distance between border and knob
    public var knobMargin: CGFloat {
        get {
            return self.frame.height / 10
        }
    }
    
    /// Called as soon as the value changes (probably because the user tapped it)
    public var changeAction: ((Bool) -> ())?
    
    /// Determines the state of the button, animates changes
    @IBInspectable public var on: Bool = true {
        didSet {
            
            // call the action closure
            if let c = self.changeAction { c(self.on) }
            
            if let k = self.knob {
                k.on = on
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    
                    let knobRadius = k.frame.width / 2
                    k.center = CGPointMake((self.on ? self.frame.width - knobRadius - self.knobMargin : knobRadius + self.knobMargin), k.center.y)
                    
                    self.backgroundColor = self.on ? self.onColor : self.offColor
                    
                    if let b = self.offBorder {
                        if self.on {
                            b.strokeStart = 1.0
                        } else {
                            b.strokeEnd = 1.0
                        }
                    }
                    
                    if let all = self.stars {
                        all.enumerate().forEach({ (i, star) in
                            star.alpha = self.on ? 0 : 1
                            
                            // let them shine
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(i) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                                star.transform = CGAffineTransformMakeScale(1.5, 1.5)
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                                    star.transform = CGAffineTransformIdentity
                                })
                            })
                        })
                    }
                    
                    if let c = self.cloud {
                        c.transform = self.on ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0, 0)
                    }
                    
                    }, completion: { _ in
                
                        // reset the values
                        if let b = self.offBorder {
                            if self.on {
                                b.strokeStart = 0.0
                                b.strokeEnd = 0.0
                            } else {
                                b.strokeStart = 0.0
                                b.strokeEnd = 1.0
                            }
                        }
                })
            }
        }
    }
    
    /// Round white knob
    var knob: Knob?
    
    /**
     Sets up the `knob`
     
     - returns: the knob view
     */
    func setupKnob() -> Knob {
        
        let w = self.frame.height - knobMargin * 2
        let v = Knob(frame: CGRectMake(knobMargin, knobMargin, w, w))
        knob = v
        return v
    }
    
    /// Dark blue border layer
    public var offBorder: CAShapeLayer?
    
    /// Light blue layer below the `offBorder`
    public var onBorder: CAShapeLayer?
    
    /**
     Sets up the border layers
     
     - returns: tuple containing both layers
     */
    func setupBorders() -> (CAShapeLayer, CAShapeLayer) {
        
        let b1 = CAShapeLayer()
        let b2 = CAShapeLayer()
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, self.frame.width, self.frame.height), cornerRadius: self.frame.height / 2)

        b1.path = path.CGPath
        b1.fillColor = UIColor.clearColor().CGColor
        b1.strokeColor = onBorderColor.CGColor
        b1.lineWidth = borderWidth
        onBorder = b1
        
        b2.path = path.CGPath
        b2.fillColor = UIColor.clearColor().CGColor
        b2.strokeColor = offBorderColor.CGColor
        b2.lineWidth = borderWidth
        offBorder = b2
        
        return (b1, b2)
    }
    
    /// Small white dots on the off state background
    public var stars: [UIView]?
    
    /**
     Creates 7 stars with different location and size
     
     - returns: an array of set up views
     */
    func setupStars() -> [UIView] {
        
        // shortcuts
        let w = self.frame.width
        let h = self.frame.height
        
        let x = h * 0.05
        let s1 = UIView(frame: CGRectMake(w * 0.5, h * 0.16, x, x))
        let s2 = UIView(frame: CGRectMake(w * 0.62, h * 0.33, x * 0.6, x * 0.6))
        let s3 = UIView(frame: CGRectMake(w * 0.7, h * 0.15, x, x))
        let s4 = UIView(frame: CGRectMake(w * 0.83, h * 0.39, x * 1.4, x * 1.4))
        let s5 = UIView(frame: CGRectMake(w * 0.7, h * 0.54, x * 0.8, x * 0.8))
        let s6 = UIView(frame: CGRectMake(w * 0.52, h * 0.73, x * 1.3, x * 1.3))
        let s7 = UIView(frame: CGRectMake(w * 0.82, h * 0.66, x * 1.1, x * 1.1))
        
        let all = [s1, s2, s3, s4, s5, s6, s7]
        all.forEach { (s) in
            s.layer.masksToBounds = true
            s.layer.cornerRadius = s.frame.height / 2
            s.backgroundColor = UIColor.whiteColor()
        }
        
        stars = all
        return all
    }
    
    /// Cloud image visible on top of the on state knob
    public var cloud: UIImageView?
    
    /**
     Sets up the `cloud`
     
     - returns: the image view
     */
    func setupCloud() -> UIImageView {
        
        let v = UIImageView(frame: CGRectMake(self.frame.width / 3, self.frame.height * 0.4, self.frame.width / 3, self.frame.width * 0.23))
        v.image = UIImage(named: "cloud")
        
        v.transform = CGAffineTransformMakeScale(0, 0)

        // this should be done with UIBezierPaths...
        
        cloud = v
        return v
    }
    
    // MARK: handling touch events
    func proccess(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !moved { return self.on = !self.on }
        guard let x = touches.first?.locationInView(self).x else { return }
        
        if x > self.frame.width / 2 && !self.on {
            self.on = true
        } else if x < self.frame.width / 2 && self.on {
            self.on = false
        }
    }

    /// This prevents the tap gesture recognizer from interfering the drag movement
    var dragging: Bool = false
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dragging = true
        if let k = self.knob { k.expanded = true }
    }
    
    var moved: Bool = false
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        moved = true
        proccess(touches, withEvent: event)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.proccess(touches, withEvent: event)
        if let k = self.knob { k.expanded = false }
        dragging = false
        moved = false
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.touchesEnded(touches ?? Set<UITouch>(), withEvent: event)
    }
    
    
    // MARK: Initializers
    public init(center: CGPoint) {
        let height: CGFloat = 30
        let width: CGFloat = height * 1.75
        super.init(frame: CGRectMake(center.x - width / 2, center.y - height / 2, width, height))
        commonInit()
    }
    
    /**
     Init method called by all initializers. The switch is initialized off by default
     */
    func commonInit() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = UIColor(red: 0.235, green: 0.255, blue: 0.271, alpha: 1)

        self.layer.addSublayer(setupBorders().0)
        self.layer.addSublayer(setupBorders().1)
        setupStars().forEach { self.addSubview($0) }
        self.addSubview(setupKnob())
        self.addSubview(setupCloud())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
}
