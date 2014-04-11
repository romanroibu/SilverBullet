//
//  ListTabController.m
//  SilverBullet
//
//  Created by Roman on 04.04.14.
//  Copyright (c) 2014 Roman Roibu. All rights reserved.
//

#import "ListTabController.h"
#import "PBAPIClient.h"

@interface ListTabController () {
    NSString *_notificationDescription;
}

@property (weak) IBOutlet NSTextField *titleTextFiled;
@property (weak) IBOutlet NSTableView *tableView;
- (IBAction)addRemoveItemAction:(NSSegmentedControl *)sender;

@property (strong, nonatomic) NSMutableArray *itemList;
@end

@implementation ListTabController

@synthesize itemList = _itemList;
- (NSMutableArray *)itemList
{
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}

- (void)setItemList:(NSMutableArray *)itemList
{
    _itemList = itemList;
    [self.tableView reloadData];
}

#define ADD     0
#define REMOVE  1
- (IBAction)addRemoveItemAction:(NSSegmentedControl *)sender {
    NSInteger action = [sender selectedSegment];
    NSInteger selected = [self.tableView selectedRow];
    NSString *newItem = [NSString stringWithFormat:@"Item %d", (int)[self.itemList count] + 1];
    

    switch (action) {
        case ADD:
            [self.itemList addObject:newItem];
            break;

        case REMOVE:
            [self.tableView abortEditing];
            if (selected >= 0) {
                [self.itemList removeObjectAtIndex:selected];
            }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - TabController Protocol

- (void)pushWithDeviceIDEN:(NSString *)IDEN completionBlock:(void (^)(NSError *))completionBlock
{
    [self.tableView abortEditing];

    NSString *title = [self.titleTextFiled stringValue];

    PBAPIClient *client = [PBAPIClient sharedClient];
    [client pushListWithDeviceIDEN:IDEN
                             title:title
                             items:self.itemList
    success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(nil);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(error);
    }];

    // Build the notification description
    _notificationDescription = [NSString stringWithFormat:@"List titled \"%@\" with %d items", title, (int)[self.itemList count]];
}

- (void)resetController
{
    self.titleTextFiled.stringValue = @"";
    self.itemList = [@[] mutableCopy];
}

- (NSString *)notificationDescription
{
    return _notificationDescription;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.itemList count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.itemList[row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    self.itemList[row] = object;
}


@end
