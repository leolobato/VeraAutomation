//
//  VeraSections.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VeraSections : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger sectionsIdentifier;

+ (VeraSections *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
