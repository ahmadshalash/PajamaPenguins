//
//  TwoDimensionalArray.m
//  PajamaPenguins
//
//  Created by Skye on 2/17/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "TwoDimensionalArray.h"

@interface TwoDimensionalArray()
@property (nonatomic, readwrite) NSMutableArray *sections;
@property (nonatomic, readwrite) NSUInteger rowCount;
@property (nonatomic, readwrite) NSUInteger columnCount;
@end

@implementation TwoDimensionalArray

- (instancetype)initWithRows:(NSUInteger)rowsCount columns:(NSUInteger)columnsCount {
    self = [super init];
    if (self) {
        _rowCount = rowsCount;
        _columnCount = columnsCount;

        _sections = [NSMutableArray arrayWithCapacity:columnsCount];
        for (int i = 0; i < columnsCount; i++) {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:rowsCount];
            [_sections addObject:row];
            for (int j = 0; j < rowsCount; j++) {
                [row addObject:[NSNull null]];
            }
        }
    }
    return self;
}

- (void)insertObject:(id)object atRow:(NSUInteger)row atColumn:(NSUInteger)column {
    [[_sections objectAtIndex:column] replaceObjectAtIndex:row withObject:object];
}

- (void)removeObjectAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
    [[_sections objectAtIndex:column] replaceObjectAtIndex:row withObject:[NSNull null]];
}

- (id)getObjectAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
    id object = [[_sections objectAtIndex:column] objectAtIndex:row];
    if (!object) {
        NSLog(@"Error: Null object at [%lu][%lu]",(unsigned long)column,(unsigned long)row);
    }
    return object;
}

@end
