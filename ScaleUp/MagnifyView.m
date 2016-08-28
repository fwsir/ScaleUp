//
//  MagnifyView.m
//  ScaleUp
//
//  Created by BOOM on 16/8/28.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "MagnifyView.h"

@implementation MagnifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 60;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
    self.center = CGPointMake(touchPoint.x, touchPoint.y - 10);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.frame.size.width/2.0, self.frame.size.height/2.0);
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context, -_touchPoint.x, -_touchPoint.y);
    [self.viewToMagnify.layer renderInContext:context];
}

@end
