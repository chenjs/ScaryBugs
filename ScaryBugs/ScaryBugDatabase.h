//
//  ScaryBugDatabase.h
//  ScaryBugs
//
//  Created by chenjs on 12-11-2.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugDatabase : NSObject


+ (NSMutableArray *)loadScaryBugDocs;
+ (NSString *)nextScaryBugDocPath;


@end
