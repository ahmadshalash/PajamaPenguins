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
@end

@implementation TwoDimensionalArray

- (instancetype)initWithRows:(NSUInteger)rowsCount columns:(NSUInteger)columnsCount {
    self = [super init];
    if (self) {
        _sections = [NSMutableArray arrayWithCapacity:columnsCount];
        for (int i = 0; i < columnsCount; i++) {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:rowsCount];
            [_sections addObject:row];
        }
    }
    return self;
}

- (void)insertObject:(id)object atRow:(NSUInteger)row atColumn:(NSUInteger)column {
    [[_sections objectAtIndex:column] replaceObjectAtIndex:row withObject:object];
}

- (id)getObjectAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
    return [[_sections objectAtIndex:column] objectAtIndex:row];
}

@end
