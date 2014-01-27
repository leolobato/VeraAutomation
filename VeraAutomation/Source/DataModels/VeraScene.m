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


@interface VeraScene ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

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
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.sceneIdentifier = [[self objectOrNilForKey:kVeraSceneId fromDictionary:dict] doubleValue];
            self.active = [[self objectOrNilForKey:kVeraSceneActive fromDictionary:dict] doubleValue];
            self.state = [[self objectOrNilForKey:kVeraSceneState fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kVeraSceneName fromDictionary:dict];
            self.room = [[self objectOrNilForKey:kVeraSceneRoom fromDictionary:dict] doubleValue];
            self.comment = [self objectOrNilForKey:kVeraSceneComment fromDictionary:dict];

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

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.sceneIdentifier = [aDecoder decodeDoubleForKey:kVeraSceneId];
    self.active = [aDecoder decodeDoubleForKey:kVeraSceneActive];
    self.state = [aDecoder decodeDoubleForKey:kVeraSceneState];
    self.name = [aDecoder decodeObjectForKey:kVeraSceneName];
    self.room = [aDecoder decodeDoubleForKey:kVeraSceneRoom];
    self.comment = [aDecoder decodeObjectForKey:kVeraSceneComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_sceneIdentifier forKey:kVeraSceneId];
    [aCoder encodeDouble:_active forKey:kVeraSceneActive];
    [aCoder encodeDouble:_state forKey:kVeraSceneState];
    [aCoder encodeObject:_name forKey:kVeraSceneName];
    [aCoder encodeDouble:_room forKey:kVeraSceneRoom];
    [aCoder encodeObject:_comment forKey:kVeraSceneComment];
}


@end
