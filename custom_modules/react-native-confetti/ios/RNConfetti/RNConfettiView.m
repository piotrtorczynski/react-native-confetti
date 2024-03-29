//
//  ConfettiView.m
//  RNConfetti
//
//  Created by Piotr Torczynski on 14/06/2017.
//  Copyright © 2017 Netguru. All rights reserved.
//

#import "RNConfettiView.h"
#import <QuartzCore/QuartzCore.h>
#import <React/RCTUIManager.h>


@interface RNConfettiView()

@property (strong, nonatomic, readwrite) CAEmitterLayer *emitterLayer;
@property (strong, nonatomic) NSArray<UIColor *> *colors;
@property (strong, nonatomic) NSNumber *intensity;
@property (nonatomic) ConfettiType confettiType;

@property (nonatomic) BOOL isActive;

@end

@implementation RNConfettiView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setTypeValue:(ConfettiType)type {
    self.confettiType = type;
}

- (void)start {
    [self startConfetti];
}

- (void)stop {
    [self.emitterLayer setBirthRate:0.0];
    self.isActive = NO;
}

- (BOOL)isConfettiActive {
    return [self isActive];
}

- (void)setIntensityValue:(float)intensity {
    self.intensity = [NSNumber numberWithFloat:intensity];
}

#pragma mark Private

- (void)setup {
    self.colors = @[
        [UIColor colorWithRed:0.95 green:0.40 blue:0.27 alpha:1.0],
        [UIColor colorWithRed:1.00 green:0.78 blue:0.36 alpha:1.0],
        [UIColor colorWithRed:0.48 green:0.78 blue:0.64 alpha:1.0],
        [UIColor colorWithRed:0.30 green:0.76 blue:0.85 alpha:1.0],
        [UIColor colorWithRed:0.58 green:0.39 blue:0.55 alpha:1.0]
    ];

    [self setIntensity:[NSNumber numberWithFloat:0.8]];
    [self setIsActive:NO];
}

- (void)startConfetti {
    if (![self isConfettiActive]) {
        self.emitterLayer = [CAEmitterLayer layer];
        [self.emitterLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
        [self.emitterLayer setEmitterPosition:CGPointMake(self.frame.size.width / 2.0, 0)];
        [self.emitterLayer setEmitterShape: kCAEmitterLayerLine];
        [self.emitterLayer setEmitterSize:CGSizeMake(self.frame.size.width, 1)];
        [self.emitterLayer setFrame:self.frame];
        [self.emitterLayer setEmitterCells:[self prepareCellsWithColors:self.colors]];
        [self.emitterLayer setBackgroundColor:[UIColor clearColor].CGColor];

        [self.layer setBackgroundColor: [UIColor clearColor].CGColor];
        [self.layer addSublayer:self.emitterLayer];
        [self setIsActive:YES];
    }
}

- (NSArray<CAEmitterCell *> *)prepareCellsWithColors:(NSArray<UIColor *> *)colors {
    NSArray<CAEmitterCell *> *cells = [[NSArray alloc] init];
    for (UIColor *color in colors) {
        cells = [cells arrayByAddingObject:[self confettiWithColor:color]];
    }
    return  cells;
}

- (CAEmitterCell *)confettiWithColor:(UIColor *)color {
    float intesityValue = [self.intensity floatValue];
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    [emitterCell setBirthRate:10.0 * intesityValue];
    [emitterCell setLifetime:20.0 * intesityValue];
    [emitterCell setColor:[color CGColor]];
    [emitterCell setVelocity:60.0 * intesityValue];
    [emitterCell setVelocityRange:200.0 * intesityValue];
    [emitterCell setEmissionLongitude: M_PI];
    [emitterCell setSpin:3.5 * intesityValue];
    [emitterCell setSpinRange:4.0 * intesityValue];
    [emitterCell setScaleRange:intesityValue];
    [emitterCell setScaleSpeed:-0.1 * intesityValue];
    [emitterCell setContents:(id)[self imageForType:self.confettiType]];
    return  emitterCell;
}

- (CGImageRef)imageForType:(ConfettiType)type {
    UIImage *confettiImage = [UIImage imageNamed:[self getFilenameWithType:type]];
    CGImageRef imageRef = [confettiImage CGImage];
    return imageRef;
}

- (NSString *)getFilenameWithType:(ConfettiType)type {
    switch (type) {
        case ConfettiTypeConfetti:
            return @"confetti";
            break;
        case ConfettiTypeStar:
            return @"star";
            break;
        case ConfettiTypeDiamond:
            return @"diamond";
            break;
        case ConfettiTypeTriangle:
            return @"triangle";
            break;
    }
}

@end
