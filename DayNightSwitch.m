//
//  DayNightSwitch.m
//  DayNightSwitch
//
//  Created by Finn Gaida on 03.09.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

#import "DayNightSwitch.h"

/// some color constants
#define onKnobColor [UIColor colorWithRed: 0.882 green: 0.765 blue: 0.325 alpha: 1];
#define onSubviewColor [UIColor colorWithRed: 0.992 green: 0.875 blue: 0.459 alpha: 1];
#define offKnobColor [UIColor colorWithRed: 0.894 green: 0.902 blue: 0.788 alpha: 1];
#define offSubviewColor [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
#define offColor [UIColor colorWithRed: 0.235 green: 0.255 blue: 0.271 alpha: 1];
#define offBorderColor [UIColor colorWithRed: 0.11 green: 0.11 blue: 0.11 alpha: 1];
#define onColor [UIColor colorWithRed: 0.627 green: 0.894 blue: 0.98 alpha: 1];
#define onBorderColor [UIColor colorWithRed: 0.533 green: 0.769 blue: 0.843 alpha: 1];


@interface Knob : UIView

/// Visual state of the knob, animates changes
@property (nonatomic) BOOL on;

/// Horizontally expanded state of the knob, animates changes
@property (nonatomic) BOOL expanded;

/// Round subview of the knob
@property (nonatomic) UIView *subview;

/// Circular subviews on the off state `subview`
@property (nonatomic) NSArray<UIView *> *craters;

@end

@implementation Knob

/// Distance from knob to subview circle
- (CGFloat)subviewMargin {
    return self.frame.size.height / 12;
}

/**
 Sets up the `subview` with the craters as well
 
 - returns: the view
 */
- (UIView *)setupSubview {
    
    UIView *v = [[UIView alloc] initWithFrame: CGRectMake([self subviewMargin], [self subviewMargin], self.frame.size.width - [self subviewMargin] * 2, self.frame.size.height - [self subviewMargin] * 2)];
    v.layer.masksToBounds = true;
    v.layer.cornerRadius = v.frame.size.height / 2;
    v.backgroundColor = offSubviewColor;
    
    for (UIView *c in [self setupCraters]) {
        [v addSubview:c];
    }
    
    self.subview = v;
    return v;
}

/**
 Sets up three craters
 
 - returns: array of set up views
 */
- (NSArray *)setupCraters {
    
    // shortcuts
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    UIView *topLeft = [[UIView alloc] initWithFrame: CGRectMake(0, h * 0.1, w * 0.2, w * 0.2)];
    UIView *topRight = [[UIView alloc] initWithFrame: CGRectMake(w * 0.5, 0, w * 0.3, w * 0.3)];
    UIView *bottom = [[UIView alloc] initWithFrame: CGRectMake(w * 0.4, h * 0.5, w * 0.25, w * 0.25)];
    
    NSArray<UIView *> *all = @[topLeft, topRight, bottom];
    
    for (UIView *v in all) {
        v.backgroundColor = offSubviewColor;
        v.layer.masksToBounds = YES;
        v.layer.cornerRadius = v.frame.size.height / 2;
        
        UIColor *offC = offKnobColor;
        v.layer.borderColor = offC.CGColor;
        v.layer.borderWidth = [self subviewMargin];
    }
    
    self.craters = all;
    return all;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self.on = NO;
    self.expanded = NO;
    self = [super initWithFrame:frame];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.backgroundColor = offKnobColor;
    
    [self addSubview:[self setupSubview]];
    
    [self addObserver:self forKeyPath:@"on" options:0 context:nil];
    [self addObserver:self forKeyPath:@"expanded" options:0 context:nil];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"on"]) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            if (self.on) {
                self.backgroundColor = onKnobColor;
                self.subview.backgroundColor = onSubviewColor;
            } else {
                self.backgroundColor = offKnobColor;
                self.subview.backgroundColor = offSubviewColor;
            }
            
            BOOL cache = self.expanded;
            self.expanded = cache;
            
        } completion:nil];
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.subview.transform = CGAffineTransformMakeRotation(M_PI * ((self.on) ? 0.2 : -0.2));
            
        } completion: nil];
    } else if ([keyPath isEqualToString:@"expanded"]) {
        CGFloat newWidth = self.frame.size.height * (self.expanded ? 1.25 : 1);
        CGFloat x = (self.on) ? self.superview.frame.size.width - newWidth - [(DayNightSwitch *)self.superview knobMargin] : self.frame.origin.x;
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(x, self.frame.origin.y, newWidth, self.frame.size.height);
            self.subview.center = CGPointMake((self.on) ? self.frame.size.width - self.frame.size.height / 2 : self.frame.size.height / 2, self.subview.center.y);
            
            for (UIView *v in self.craters) {
                v.alpha = (self.on) ? 0 : 1;
            }
            
        } completion: nil];
    }
}

@end

@interface DayNightSwitch ()

/// Round white knob
@property (nonatomic) Knob *knob;

@property (nonatomic) BOOL moved;

/// This prevents the tap gesture recognizer from interfering the drag movement
@property (nonatomic) BOOL dragging;

@end

/// A switch inspired by [Dribbble](https://dribbble.com/shots/1909289-Day-Night-Toggle-Button-GIF)a
@implementation DayNightSwitch

/// Width of the darker border of the background
- (CGFloat)borderWidth {
    return self.frame.size.height / 7;
}

/// Distance between border and knob
- (CGFloat)knobMargin {
    return self.frame.size.height / 10;
}

/**
 Sets up the `knob`
 
 - returns: the knob view
 */
- (Knob *)setupKnob {
    
    CGFloat w = self.frame.size.height - [self knobMargin] * 2;
    Knob *v = [[Knob alloc] initWithFrame: CGRectMake([self knobMargin], [self knobMargin], w, w)];
    
    self.knob = v;
    return v;
}


/**
 Sets up the border layers
 
 - returns: array containing both layers
 */
- (NSArray *)setupBorders {
    
    CAShapeLayer *b1 = [CAShapeLayer layer];
    CAShapeLayer *b2 = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius: self.frame.size.height / 2];
    
    b1.path = path.CGPath;
    b1.fillColor = [UIColor clearColor].CGColor;
    
    UIColor *onC = onBorderColor;
    b1.strokeColor = onC.CGColor;
    b1.lineWidth = [self borderWidth];
    self.onBorder = b1;
    
    b2.path = path.CGPath;
    b2.fillColor = [UIColor clearColor].CGColor;
    
    UIColor *offC = offBorderColor;
    b2.strokeColor = offC.CGColor;
    b2.lineWidth = [self borderWidth];
    self.offBorder = b2;
    
    return @[b1, b2];
}


/**
 Creates 7 stars with different location and size
 
 - returns: an array of set up views
 */
- (NSArray *)setupStars {
    
    // shortcuts
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat x = h * 0.05;
    UIView *s1 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.5, h * 0.16, x, x)];
    UIView *s2 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.62, h * 0.33, x * 0.6, x * 0.6)];
    UIView *s3 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.7, h * 0.15, x, x)];
    UIView *s4 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.83, h * 0.39, x * 1.4, x * 1.4)];
    UIView *s5 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.7, h * 0.54, x * 0.8, x * 0.8)];
    UIView *s6 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.52, h * 0.73, x * 1.3, x * 1.3)];
    UIView *s7 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.82, h * 0.66, x * 1.1, x * 1.1)];
    
    NSArray *all = @[s1, s2, s3, s4, s5, s6, s7];
    
    for (UIView *s in all) {
        s.layer.masksToBounds = YES;
        s.layer.cornerRadius = s.frame.size.height / 2;
        s.backgroundColor = [UIColor whiteColor];
    }
    
    self.stars = all;
    return all;
}


/**
 Sets up the `cloud`
 
 - returns: the image view
 */
- (UIImageView *)setupCloud {
    
    UIImageView *v = [[UIImageView alloc] initWithFrame: CGRectMake(self.frame.size.width / 3, self.frame.size.height * 0.4, self.frame.size.width / 3, self.frame.size.width * 0.23)];
    v.image = [UIImage imageNamed:@"cloud"];
    v.transform = CGAffineTransformMakeScale(0, 0);
    
    // this should be done with UIBezierPaths...
    
    self.cloud = v;
    return v;
}

// MARK: handling touch events
- (void)proccessTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.moved) { self.on = !self.on; return; }
    CGFloat x = [(UITouch *)touches.allObjects.lastObject locationInView:self].x;
    
    if (x > self.frame.size.width / 2 && !self.on) {
        self.on = YES;
    } else if (x < self.frame.size.width / 2 && self.on) {
        self.on = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.dragging = YES;
    self.knob.expanded = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.moved = YES;
    [self proccessTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self proccessTouches:touches withEvent:event];
    self.knob.expanded = NO;
    self.dragging = NO;
    self.moved = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


// MARK: Initializers
- (instancetype)initWithCenter:(CGPoint)center {
    CGFloat height = 30;
    CGFloat width = height * 1.75;
    
    self = [super initWithFrame: CGRectMake(center.x - width / 2, center.y - height / 2, width, height)];
    [self commonInit];
    
    return self;
}

/**
 Init method called by all initializers. The switch is initialized off by default
 */
- (void)commonInit {
    self.moved = NO;
    self.dragging = NO;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.backgroundColor = [UIColor colorWithRed: 0.235 green: 0.255 blue: 0.271 alpha: 1];
    
    NSArray *borders = [self setupBorders];
    [self.layer addSublayer:borders[0]];
    [self.layer addSublayer:borders[1]];
    
    for (UIView *v in [self setupStars]) {
        [self addSubview:v];
    }
    
    [self addSubview:[self setupKnob]];
    [self addSubview:[self setupCloud]];
    
    [self addObserver:self forKeyPath:@"on" options:0 context:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"on"]) {
        // call the action closure
        if (self.changeAction) { self.changeAction(self.on); }
        
        self.knob.on = self.on;
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            CGFloat knobRadius = self.knob.frame.size.width / 2;
            
            if (self.on) {
                self.knob.center = CGPointMake(self.frame.size.width - knobRadius - [self knobMargin], self.knob.center.y);
                
                self.backgroundColor = onColor;
                self.offBorder.strokeStart = 1.0;
                self.cloud.transform = CGAffineTransformIdentity;
            } else {
                self.knob.center = CGPointMake(knobRadius + [self knobMargin], self.knob.center.y);
                
                self.backgroundColor = offColor;
                self.offBorder.strokeEnd = 1.0;
                self.cloud.transform = CGAffineTransformMakeScale(0, 0);
            }
            
            for (int i = 0; i < self.stars.count; i++) {
                UIView *star = self.stars[i];
                star.alpha = (self.on) ? 0 : 1;
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    star.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        star.transform = CGAffineTransformIdentity;
                    });
                });
            }
            
        } completion:^(BOOL finished) {
            
            // reset the values
            if (self.on) {
                self.offBorder.strokeStart = 0.0;
                self.offBorder.strokeEnd = 0.0;
            } else {
                self.offBorder.strokeStart = 0.0;
                self.offBorder.strokeEnd = 1.0;
            }
        }];
    }
}

@end
