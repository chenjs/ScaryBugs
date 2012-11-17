//
//  ScaryBugDoc.h
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScaryBugData;


@interface ScaryBugDoc : NSObject

@property (nonatomic, strong) ScaryBugData *data;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *fullImage;

@property (copy) NSString *docPath;


- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithTitle:(NSString *)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage;

- (void)saveData;
- (void)deleteDoc;

- (void)saveImages;



@end
