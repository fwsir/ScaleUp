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
