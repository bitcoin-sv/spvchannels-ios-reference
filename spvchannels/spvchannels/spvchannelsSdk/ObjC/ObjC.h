#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catch:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
