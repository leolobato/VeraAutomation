//
//  VeraScenes.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraScenes.h"


NSString *const kVeraScenesId = @"id";
NSString *const kVeraScenesActive = @"active";
NSString *const kVeraScenesState = @"state";
NSString *const kVeraScenesName = @"name";
NSString *const kVeraScenesRoom = @"room";
NSString *const kVeraScenesComment = @"comment";


@interface VeraScenes ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VeraScenes

@synthesize scenesIdentifier = _scenesIdentifier;
@synthesize active = _active;
@synthesize state = _state;
@synthesize name = _name;
@synthesize room = _room;
@synthesize comment = _comment;


+ (VeraScenes *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraScenes *instance = [[VeraScenes alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.scenesIdentifier = [[self objectOrNilForKey:kVeraScenesId fromDictionary:dict] doubleValue];
            self.active = [[self objectOrNilForKey:kVeraScenesActive fromDictionary:dict] doubleValue];
            self.state = [[self objectOrNilForKey:kVeraScenesState fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kVeraScenesName fromDictionary:dict];
            self.room = [[self objectOrNilForKey:kVeraScenesRoom fromDictionary:dict] doubleValue];
            self.comment = [self objectOrNilForKey:kVeraScenesComment fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.scenesIdentifier] forKey:kVeraScenesId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.active] forKey:kVeraScenesActive];
    [mutableDict setValue:[NSNumber numberWithDouble:self.state] forKey:kVeraScenesState];
    [mutableDict setValue:self.name forKey:kVeraScenesName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.room] forKey:kVeraScenesRoom];
    [mutableDict setValue:self.comment forKey:kVeraScenesComment];

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

    self.scenesIdentifier = [aDecoder decodeDoubleForKey:kVeraScenesId];
    self.active = [aDecoder decodeDoubleForKey:kVeraScenesActive];
    self.state = [aDecoder decodeDoubleForKey:kVeraScenesState];
    self.name = [aDecoder decodeObjectForKey:kVeraScenesName];
    self.room = [aDecoder decodeDoubleForKey:kVeraScenesRoom];
    self.comment = [aDecoder decodeObjectForKey:kVeraScenesComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_scenesIdentifier forKey:kVeraScenesId];
    [aCoder encodeDouble:_active forKey:kVeraScenesActive];
    [aCoder encodeDouble:_state forKey:kVeraScenesState];
    [aCoder encodeObject:_name forKey:kVeraScenesName];
    [aCoder encodeDouble:_room forKey:kVeraScenesRoom];
    [aCoder encodeObject:_comment forKey:kVeraScenesComment];
}


@end
