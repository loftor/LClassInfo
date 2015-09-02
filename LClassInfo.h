//
//  LClassInfo.h
//  Example
//
//  Created by zhanglei on 19/08/2015.
//  Copyright © 2015 loftor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LClassInfo : NSObject

+ (NSDictionary *)getAllIvars:(Class)cls;

+ (NSDictionary *)getAllPropertys:(Class)cls;

+ (NSDictionary *)getAllInstanceMethods:(Class)cls;

+ (NSDictionary *)getAllClassMethods:(Class)cls;

@end
