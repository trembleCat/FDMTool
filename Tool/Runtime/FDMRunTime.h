//
//  FDMRunTime.h
//  RunTime
//
//  Created by 发抖喵 on 2020/5/12.
//  Copyright © 2020 发抖喵. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDMRunTime : NSObject

- (void)getAllProperty:(Class )class;
- (void)getAllFunction:(Class )class;

@end

NS_ASSUME_NONNULL_END
