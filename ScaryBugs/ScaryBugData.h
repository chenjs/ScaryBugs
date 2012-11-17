//
//  ScaryBugData.h
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) float rating;

- (id)initWithTitle:(NSString *)title rating:(float)rating;

@end
