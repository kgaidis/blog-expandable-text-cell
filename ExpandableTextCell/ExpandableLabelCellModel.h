//
//  ExpandableLabelCellModel.h
//  SeeMoreExample
//
//  Created by Krisjanis Gaidis on 5/25/15.
//  Copyright (c) 2015 Krisjanis Gaidis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandableLabelTableViewCell.h"

@interface ExpandableLabelCellModel : NSObject

@property (copy, nonatomic) NSString *string;
@property (nonatomic) BOOL expanded;

- (instancetype)initWithString:(NSString *)string;
- (void)populateCell:(ExpandableLabelTableViewCell *)cell;

@end
