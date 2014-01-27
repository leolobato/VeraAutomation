//
//  VeraScene.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraScene : NSObject

@property (nonatomic, assign) NSInteger sceneIdentifier;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger room;
@property (nonatomic, strong) NSString *comment;

+ (VeraScene *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
