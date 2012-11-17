//
//  ScaryBugDoc.m
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "ScaryBugDatabase.h"

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"
#define kThumbImageFile @"thumbImage.jpg"
#define kFullImageFile  @"fullImage.jpg"


@implementation ScaryBugDoc

@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize fullImage = _fullImage;
@synthesize docPath = _docPath;


- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage
{
    self = [super init];
    if (self) {
        _data = [[ScaryBugData alloc] initWithTitle:title rating:rating];
        _thumbImage = thumbImage;
        _fullImage = fullImage;
    }
    return self;
}

- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [ScaryBugDatabase nextScaryBugDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
    
}

- (ScaryBugData *)data {
    
    if (_data != nil) return _data;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return _data;
    
}

// Add new functions
- (UIImage *)thumbImage {
    
    if (_thumbImage != nil) return _thumbImage;
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    return [UIImage imageWithContentsOfFile:thumbImagePath];
    
}

- (UIImage *)fullImage {
    
    if (_fullImage != nil) return _fullImage;
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    //return [UIImage imageWithContentsOfFile:fullImagePath];
    
    UIImage *theImage = [UIImage imageWithContentsOfFile:fullImagePath];
    //NSLog(@"orientation: %d", theImage.imageOrientation);
    return theImage;
}

- (void)saveData {
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

- (void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}

- (void)saveImages {
    
    if (_thumbImage == nil || _fullImage == nil) return;
    
    [self createDataPath];
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    NSData *thumbImageData = UIImagePNGRepresentation(_thumbImage);
    [thumbImageData writeToFile:thumbImagePath atomically:YES];
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    //NSData *fullImageData = UIImagePNGRepresentation(_fullImage);
    NSData *fullImageData = UIImageJPEGRepresentation(_fullImage, 1);
    [fullImageData writeToFile:fullImagePath atomically:YES];
    
    self.thumbImage = nil;
    self.fullImage = nil;
    
}




@end
