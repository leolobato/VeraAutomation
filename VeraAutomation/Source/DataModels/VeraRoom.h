//
//  VeraRooms.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VeraDevice;

@interface VeraRoom : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger roomIdentifier;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray *devices; // Array of VeraDevice

+ (VeraRoom *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
- (void) addDevice:(VeraDevice *) device;
@end
