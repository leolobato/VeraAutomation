//
//  ForwardServers.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraForwardServer : NSObject

@property (nonatomic, assign) BOOL primary;
@property (nonatomic, strong) NSString *hostName;

+ (VeraForwardServer *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
