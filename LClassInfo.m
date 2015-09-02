//
//  LClassInfo.m
//  Example
//
//  Created by zhanglei on 19/08/2015.
//  Copyright © 2015 loftor. All rights reserved.
//

#import "LClassInfo.h"

#import <objc/runtime.h>

@implementation LClassInfo

+ (NSDictionary *)getAllIvars:(Class)cls{
    NSMutableDictionary *ivarDic = [[NSMutableDictionary alloc]init];
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        for (unsigned int i = 0; i < ivarCount; i++) {
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
//            NSLog(@"%s",name);
            const char *typeEncoding = ivar_getTypeEncoding(ivar);
//            NSLog(@"%s",typeEncoding);
            [ivarDic setValue:[[NSString alloc]initWithUTF8String:typeEncoding] forKey:[[NSString alloc]initWithUTF8String:name]];
        }
        free(ivars);
    }
    return ivarDic;
}

+ (NSDictionary *)getAllPropertys:(Class)cls{
    NSMutableDictionary *propertyDic = [[NSMutableDictionary alloc]init];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            const char * name = property_getName(property);
//            NSLog(@"%s",name);
            NSString * typeEncoding = [self getPropertyTypeEncoding:property];
//            NSLog(@"%@",type);
            [propertyDic setValue:typeEncoding forKey:[[NSString alloc]initWithUTF8String:name]];
        }
        free(properties);
    }
    return propertyDic;
}

+ (NSDictionary *)getAllInstanceMethods:(Class)cls{
    NSMutableDictionary *methodDic = [[NSMutableDictionary alloc]init];
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        for (unsigned int i = 0; i < methodCount; i++) {
            Method method = methods[i];
            SEL sel = method_getName(method);
            const char *name = sel_getName(sel);
//            NSLog(@"%s", name);
            const char *typeEncoding = method_getTypeEncoding(method);
//            NSLog(@"%s", typeEncoding);
            [methodDic setValue:[[NSString alloc]initWithUTF8String:typeEncoding] forKey:[[NSString alloc]initWithUTF8String:name]];
        }
        free(methods);
    }
    return methodDic;
}

+ (NSDictionary *)getAllClassMethods:(Class)cls{
    NSMutableDictionary *methodDic = [[NSMutableDictionary alloc]init];
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(object_getClass(cls), &methodCount);
    if (methods) {
        for(int i = 0; i < methodCount; i++) {
            Method method = methods[i];
            SEL sel = method_getName(method);
            const char *name = sel_getName(sel);
//            NSLog(@"%s", name);
            const char *typeEncoding = method_getTypeEncoding(method);
//            NSLog(@"%s", typeEncoding);
            [methodDic setValue:[[NSString alloc]initWithUTF8String:typeEncoding] forKey:[[NSString alloc]initWithUTF8String:name]];
        }
        free(methods);
    }
    return methodDic;
}

+ (NSString *)getPropertyTypeEncoding:(objc_property_t)property{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return name;
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return name;
        }
    }
    return @"";
}

@end
