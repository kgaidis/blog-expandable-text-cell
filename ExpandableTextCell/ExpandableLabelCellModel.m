//
//  ExpandableLabelCellModel.m
//  SeeMoreExample
//
//  Created by Krisjanis Gaidis on 5/25/15.
//  Copyright (c) 2015 Krisjanis Gaidis. All rights reserved.
//

#import "ExpandableLabelCellModel.h"

static const NSInteger kMaxNumberOfLines = 5;

@implementation ExpandableLabelCellModel

- (instancetype)initWithString:(NSString *)string {
    if (self = [super init]) {
        _string = [string copy];
        _expanded = NO;
    }
    return self;
}

- (void)populateCell:(ExpandableLabelTableViewCell *)cell {
    cell.label.text = self.string;
    cell.label.numberOfLines = (self.expanded) ? 0 : kMaxNumberOfLines;
}

@end