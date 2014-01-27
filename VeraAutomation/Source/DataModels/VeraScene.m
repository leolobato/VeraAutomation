//
//  VeraScene.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraScene.h"


NSString *const kVeraSceneId = @"id";
NSString *const kVeraSceneActive = @"active";
NSString *const kVeraSceneState = @"state";
NSString *const kVeraSceneName = @"name";
NSString *const kVeraSceneRoom = @"room";
NSString *const kVeraSceneComment = @"comment";


@implementation VeraScene

@synthesize sceneIdentifier = _sceneIdentifier;
@synthesize active = _active;
@synthesize state = _state;
@synthesize name = _name;
@synthesize room = _room;
@synthesize comment = _comment;


+ (VeraScene *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraScene *instance = [[VeraScene alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_sceneIdentifier = [dict[kVeraSceneId] integerValue];
		_active = [dict[kVeraSceneActive] boolValue];
		_state = [dict[kVeraSceneState] integerValue];
		_name = dict[kVeraSceneName];
		_room = [dict[kVeraSceneRoom] integerValue];
		_comment = dict[kVeraSceneComment];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sceneIdentifier] forKey:kVeraSceneId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.active] forKey:kVeraSceneActive];
    [mutableDict setValue:[NSNumber numberWithDouble:self.state] forKey:kVeraSceneState];
    [mutableDict setValue:self.name forKey:kVeraSceneName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.room] forKey:kVeraSceneRoom];
    [mutableDict setValue:self.comment forKey:kVeraSceneComment];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

@end
