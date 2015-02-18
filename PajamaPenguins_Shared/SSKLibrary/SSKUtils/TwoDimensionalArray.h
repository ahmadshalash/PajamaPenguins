//
//  TwoDimensionalArray.h
//  PajamaPenguins
//
//  Created by Skye on 2/17/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoDimensionalArray : NSObject

@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSUInteger columnCount;

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns;

- (void)insertObject:(id)object atRow:(NSUInteger)row atColumn:(NSUInteger)column;
- (void)removeObjectAtRow:(NSUInteger)row atColumn:(NSUInteger)column;
- (id)getObjectAtRow:(NSUInteger)row atColumn:(NSUInteger)column;

@end
