//
//  BlockTmp.h
//  ScaleUp
//
//  Created by BOOM on 16/9/1.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlockTmp;
typedef void(^VoidBlock)();

@interface BlockTmp : NSObject

@property (nonatomic, copy) VoidBlock block;

@end
