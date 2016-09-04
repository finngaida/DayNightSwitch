//
//  DayNightSwitch.h
//  DayNightSwitch
//
//  Created by Finn Gaida on 03.09.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayNightSwitch : UIView

/// Called as soon as the value changes (probably because the user tapped it)
@property (nonatomic, copy, nullable) void (^changeAction)(BOOL);

/// Determines the state of the button, animates changes
@property (nonatomic) BOOL on;

/// Dark blue border layer
@property (nonatomic, nonnull, retain) CAShapeLayer *offBorder;

/// Light blue layer below the `offBorder`
@property (nonatomic, nonnull, retain) CAShapeLayer *onBorder;

/// Small white dots on the off state background
@property (nonatomic, nullable, retain) NSArray<UIView *> *stars;

/// Cloud image visible on top of the on state knob
@property (nonatomic, nonnull, assign) UIImageView *cloud;

- (CGFloat)knobMargin;
- (nonnull instancetype)initWithCenter:(CGPoint)center;

@end
