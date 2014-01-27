//
//  VeraCategories.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraCategories : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger categoriesIdentifier;

+ (VeraCategories *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
