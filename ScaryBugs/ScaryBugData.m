//
//  ScaryBugData.m
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import "ScaryBugData.h"

@implementation ScaryBugData

@synthesize title = _title;
@synthesize rating = _rating;

- (id)initWithTitle:(NSString *)title rating:(float)rating
{
    self = [super init];
    if (self) {
        _title = title;
        _rating = rating;
    }
    return self;
}

#pragma mark NSCoding

#define kTitleKey       @"Title"
#define kRatingKey      @"Rating"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeFloat:_rating forKey:kRatingKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    float rating = [decoder decodeFloatForKey:kRatingKey];
    
    return [self initWithTitle:title rating:rating];
}

@end
