//
//  ViewController.m
//  SeeMoreExample
//
//  Created by Krisjanis Gaidis on 5/25/15.
//  Copyright (c) 2015 Krisjanis Gaidis. All rights reserved.
//

#import "ViewController.h"
#import "ExpandableLabelTableViewCell.h"
#import "ExpandableLabelCellModel.h"
#include <stdlib.h>

static const NSInteger kNumberOfCells = 100;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *tableViewData;
@property (strong, nonatomic) NSMutableDictionary *rowToCellHeightCache;

// IBOutlet's
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark - Lifecycle -

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _tableViewData = [NSMutableArray new];
        _rowToCellHeightCache = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateRandomData];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Helpers - 

- (void)generateRandomData {
    
    static NSString *const string = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    for (NSInteger i = 0; i < kNumberOfCells ; i++) {
        NSString *substring = [string substringToIndex:arc4random_uniform((uint)string.length-1)+1];
        [self.tableViewData addObject:[[ExpandableLabelCellModel alloc] initWithString:substring]];
    }
}

#pragma mark - <UITableViewDelegate> -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpandableLabelCellModel *cellModel = self.tableViewData[indexPath.row];
    
    if (!cellModel.expanded) {
        cellModel.expanded = YES;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }}

#pragma mark - <UITableViewDataSource> -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpandableLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExpandableLabelTableViewCellIdentifier forIndexPath:indexPath];

    ExpandableLabelCellModel *cellModel = self.tableViewData[indexPath.row];
    [cellModel populateCell:cell];
    
    // Update constraints after we set the text so label can be fully expanded
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.rowToCellHeightCache[@(indexPath.row)] = @(cell.frame.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Using the iOS 8 auto-resizing cells
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowToCellHeightCache[@(indexPath.row)] doubleValue] ? : 100;
}

@end
