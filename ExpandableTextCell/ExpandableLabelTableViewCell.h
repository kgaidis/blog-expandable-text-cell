//
//  ExpandableLabelTableViewCell.h
//  SeeMoreExample
//
//  Created by Krisjanis Gaidis on 5/25/15.
//  Copyright (c) 2015 Krisjanis Gaidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableLabel.h"

static NSString *const kExpandableLabelTableViewCellIdentifier = @"ExpandableLabelTableViewCell";

@interface ExpandableLabelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ExpandableLabel *label;

@end
