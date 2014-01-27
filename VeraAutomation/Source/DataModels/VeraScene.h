//
//  VeraScene.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraScene : NSObject <NSCoding>

@property (nonatomic, assign) double sceneIdentifier;
@property (nonatomic, assign) double active;
@property (nonatomic, assign) double state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double room;
@property (nonatomic, strong) NSString *comment;

+ (VeraScene *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
