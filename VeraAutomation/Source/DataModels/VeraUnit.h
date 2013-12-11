//
//  VeraUnit.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraUnit : NSObject <NSCoding>

@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *activeServer;
@property (nonatomic, strong) NSArray *forwardServers;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *firmwareVersion;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *name;

+ (VeraUnit *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
