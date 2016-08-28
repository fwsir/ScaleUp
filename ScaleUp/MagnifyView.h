//
//  MagnifyView.h
//  ScaleUp
//
//  Created by BOOM on 16/8/28.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagnifyView : UIWindow

@property (nonatomic, strong) UIView *viewToMagnify;
@property (nonatomic, assign) CGPoint touchPoint;

@end
