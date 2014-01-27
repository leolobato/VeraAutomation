//
//  VeraScenes.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraScenes : NSObject <NSCoding>

@property (nonatomic, assign) double scenesIdentifier;
@property (nonatomic, assign) double active;
@property (nonatomic, assign) double state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double room;
@property (nonatomic, strong) NSString *comment;

+ (VeraScenes *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
