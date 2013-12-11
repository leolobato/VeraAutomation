//
//  ForwardServers.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraForwardServer : NSObject <NSCoding>

@property (nonatomic, assign) BOOL primary;
@property (nonatomic, strong) NSString *hostName;

+ (VeraForwardServer *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
