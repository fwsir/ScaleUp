//
//  DrawView.m
//  ScaleUp
//
//  Created by BOOM on 16/9/14.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


- (void)drawRect:(CGRect)rect
{
//    [self drawFuncOne];
//    [self drawFuncTwo];
    
    [self drawFuncThree];
}


/**
 *  多种粗糙的图形绘制
 */

- (void)drawFuncOne
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 绘图
    // 第一条线
    CGContextMoveToPoint(ctx, 20, 100);
    CGContextAddLineToPoint(ctx, 100, 320);
    
    // 设置第一条线的状态
    // 设置线条的宽度
    CGContextSetLineWidth(ctx, 12);
    // 设置线条的颜色
    [[UIColor brownColor] set];
    // 设置线条两端的样式为圆角
    CGContextSetLineCap(ctx, kCGLineCapRound);
    // 对线条进行渲染
    CGContextStrokePath(ctx);
    
    // 第二条线
    // 第二条线的状态取自直线之前上下文ctx的设置
    CGContextMoveToPoint(ctx, 40, 200);
    CGContextAddLineToPoint(ctx, 80, 100);
    
    /*
    // 如果在对上下文ctx进行设置会清空之前的设置
    CGContextSetLineWidth(ctx, 1);
    [[UIColor blackColor] set];
    CGContextSetLineCap(ctx, kCGLineCapButt);
    */
    
    // 渲染
    CGContextStrokePath(ctx);
}

- (void)drawFuncTwo
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 保存一份最初的图形上下文
    CGContextSaveGState(ctx);
    
    // 绘图
    // 第一条线
    CGContextMoveToPoint(ctx, 20, 100);
    CGContextAddLineToPoint(ctx, 100, 320);
    
    // 设置状态
    CGContextSetLineWidth(ctx, 12);
    [[UIColor brownColor] set];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // 渲染
    CGContextStrokePath(ctx);

    // 还原开始保存的那份图形上下文
    CGContextRestoreGState(ctx);
    
    // 第二条线
    CGContextMoveToPoint(ctx, 40, 200);
    CGContextAddLineToPoint(ctx, 80, 100);
    
    // 渲染
    CGContextStrokePath(ctx);
}

- (void)drawFuncThree
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor brownColor] set];
    
    CGContextMoveToPoint(ctx, 10, 10);
    CGPoint points[] = {
        {20, 20},
        {30, 30},
        {40, 40},
        {50, 50},
        {60, 70},
        {80, 80}
    };
    
    // 连续绘制路径
    CGContextAddLines(ctx, points, 6);
    //填充渲染
    CGContextStrokePath(ctx);
    CGPoint point1[] = {
        {120, 20},
        {130, 30},
        {140, 40},
        {150, 50},
        {160, 70},
        {180, 80}
    };
    
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // 分段绘制路径
    CGContextStrokeLineSegments(ctx, point1, 6);
    CGContextStrokePath(ctx);
}

@end
