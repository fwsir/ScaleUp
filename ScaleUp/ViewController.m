//
//  ViewController.m
//  ScaleUp
//
//  Created by BOOM on 16/8/28.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "ViewController.h"
#import "MagnifyView.h"
#import "BlockTmp.h"
#import "ObjcPerson.h"
#import "NSObject+Extension.h"
#import "DrawView.h"

#define DLog(str) NSLog(@#str);
#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(type) strong##type = weak##type;

#define DLLog(...) NSLog(@"%s 第%d行 \n %@\n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);

#define printk(fmt, ...) printf(fmt, ##__VA_ARGS__);

@interface ViewController ()

@property (nonatomic, strong) MagnifyView *loop;
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50, 50, 100, 100);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    self.layerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.layerView];
    
    BlockTmp *tmp = [[BlockTmp alloc] init];
    
    printk("Hello");
    printk("hello %s", "Hello");
    
    DLLog(@"Hello");
    
    NSDictionary *dict = @{@"name": @"李雷", @"age": @18};
    
    ObjcPerson *person = [ObjcPerson dictToModel:dict];
    
    NSLog(@"===== %@, %ld", person.name, person.age);
    
    DrawView *view = [[DrawView alloc] initWithFrame:CGRectMake(50, 400, 300, 300)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
}


- (IBAction)snapShot:(id)sender
{
//    [self animateOne];
//    [self viewTwoImage:50];
    
//    [self lockToTest];
//    [self conditionLockToTest];
    [self recursiveLockToTest];
}

#pragma mark - 时间相关处理

- (NSDate *)getCurrentLocaleDate:(NSDate *)aDate
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval interVal = [timeZone secondsFromGMTForDate:aDate];
    NSDate *nowDate = [aDate dateByAddingTimeInterval:interVal];
    
    return nowDate;
}


#pragma mark - 测试加解锁

- (void)lockToTest
{
    NSLock *lock = [[NSLock alloc] init];
    
    // 线程1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [lock lock];
        NSLog(@"线程1");
        sleep(10);
        [lock unlock];
        NSLog(@"线程1解锁成功");
    });
    
    // 线程2
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(1);
        if ([lock tryLock])
        {
            NSLog(@"线程2");
            [lock unlock];
        }
        else
        {
            NSLog(@"tryLock失败");
        }
    });
}

- (void)conditionLockToTest
{
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
    
    // 线程1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [lock lockWhenCondition:1];
        NSLog(@"线程1");
        sleep(2);
        [lock unlock];
    });
    
    // 线程2
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(1);
        if ([lock tryLockWhenCondition:0]) {
            NSLog(@"线程2");
            [lock unlockWithCondition:2];
            NSLog(@"线程2解锁成功");
        }
        else
        {
            NSLog(@"线程2尝试枷锁失败");
        }
    });
    
    // 线程3
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(2);
        if ([lock tryLockWhenCondition:2]) {
            NSLog(@"线程3");
            [lock unlock];
            NSLog(@"线程3解锁成功");
        }
        else
        {
            NSLog(@"线程3尝试加锁失败");
        }
    });
    
    // 线程4
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(3);
        if ([lock tryLockWhenCondition:2]) {
            NSLog(@"线程4");
            [lock unlockWithCondition:1];
            NSLog(@"线程4解锁成功");
        }
        else
        {
            NSLog(@"线程4尝试加锁失败");
        }
    });
}

- (void)recursiveLockToTest
{
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    
    static void (^RecursiveBlock)(int);
    RecursiveBlock = ^(int value){
        [lock lock];
        if (value > 0) {
            NSLog(@"Value is %d", value);
            RecursiveBlock(value-1);
        }
        [lock unlock];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        RecursiveBlock(2);
    });
}

// 截屏操作
- (void)viewTwoImage:(CGFloat)radius
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIGraphicsBeginImageContextWithOptions(imageV.frame.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // 添加圆角操作
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:imageV.frame  cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [image drawInRect:imageV.frame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

#pragma mark - 动画操作系列

// 随机改变图层颜色，Layer层中Core Animation默认都会加上动画效果
// 而在UIView中，把它关联的图层的这个特性关闭了，也就是UIkit没有动画
- (void)animateOne
{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

// 自定义动画效果
- (void)animateTwo
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    
    [self animateOne];
    
    [CATransaction commit];
}

// 在颜色动画完成后添加一个回调
- (void)animateThree
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
    // 这里的旋转也是有动画效果的，默认的时间为0.25秒
    [CATransaction setCompletionBlock:^{
        self.colorLayer.affineTransform = CGAffineTransformRotate(self.colorLayer.affineTransform, M_PI_2);
    }];
    
    [self animateOne];
    [CATransaction commit];
}


#pragma mark - 放大镜系列

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
