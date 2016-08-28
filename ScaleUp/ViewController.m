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
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        
        [self showLoop];
    });
}

- (MagnifyView *)loop
{
    if (!_loop)
    {
        _loop = [[MagnifyView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _loop.viewToMagnify = self.view;
    }
    
    return _loop;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.loop.touchPoint = [[touches anyObject] locationInView:self.view];
    [self.loop setNeedsDisplay];
    
    dispatch_resume(self.timer);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.loop.touchPoint = [[touches anyObject] locationInView:self.view];
    [self.loop setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_suspend(self.timer);
    self.loop = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_suspend(self.timer);
    self.loop = nil;
}

- (void)showLoop
{
    [self.loop makeKeyAndVisible];
}

@end
