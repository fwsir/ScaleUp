//
//  ViewController.m
//  ScaleUp
//
//  Created by BOOM on 16/8/28.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "ViewController.h"
#import "MagnifyView.h"

@interface ViewController ()

@property (nonatomic, strong) MagnifyView *loop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 截屏操作
- (IBAction)snapShot:(id)sender
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIGraphicsBeginImageContextWithOptions(imageV.frame.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    imageV.image = image;
    UIGraphicsEndImageContext();
}

- (MagnifyView *)loop
{
    if (!_loop)
    {
        _loop = [[MagnifyView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _loop.viewToMagnify = self.view;
        [_loop makeKeyAndVisible];
    }
    
    return _loop;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.loop.touchPoint = [[touches anyObject] locationInView:self.view];
    [self.loop setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.loop.touchPoint = [[touches anyObject] locationInView:self.view];
    [self.loop setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.loop = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.loop = nil;
}

- (void)showLoop
{
//    [self.loop makeKeyAndVisible];
}

@end
