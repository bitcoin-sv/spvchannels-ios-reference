//
//  ObjC.h
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

#import <Foundation/Foundation.h>

@interface ObjC: NSObject

+ (BOOL)catch:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
