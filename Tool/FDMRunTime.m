//
//  FDMRunTime.m
//  RunTime
//
//  Created by 发抖喵 on 2020/5/12.
//  Copyright © 2020 发抖喵. All rights reserved.
//

#import "FDMRunTime.h"
#import <objc/runtime.h>

@implementation FDMRunTime

- (void)getAllProperty:(Class )class {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"Property Name : %@",name);
    }
}

- (void)getAllFunction:(Class )class {
    unsigned int count;
    Method *methods = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++){
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        const char *type =  method_getTypeEncoding(method);
        NSLog(@"Function Name: %@ Type: %s",name,type);
    }
}

@end
