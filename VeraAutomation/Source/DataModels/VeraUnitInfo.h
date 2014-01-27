//
//  VeraUnitInfo.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VeraUnitInfo : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *scenes;
@property (nonatomic, strong) NSString *temperatureUnits;
@property (nonatomic, strong) NSString *irtx;
@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) double ir;
@property (nonatomic, strong) NSString *fwd2;
@property (nonatomic, assign) BOOL full;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, assign) NSUInteger loadtime;
@property (nonatomic, assign) double zwaveHeal;
@property (nonatomic, strong) NSString *fwd1;
@property (nonatomic, assign) NSUInteger dataversion;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSArray *rooms;

+ (VeraUnitInfo *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
- (void) updateDeviceInfo:(VeraUnitInfo *) newInfo;

@end
