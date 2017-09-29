//
//  StatisticsViewController.m
//  PennyStocks
//
//  Created by Markus Bröker on 26.09.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import "StatisticsViewController.h"
#import "OrderData.h"
#import "Helper.h"

@implementation StatisticsViewController

/**
 *
 */
- (void)awakeFromNib {

    self.openOrdersLabel.stringValue = NSLocalizedString(@"open_orders", "Open Orders");

    self.ordersTableView.delegate = self;
    self.ordersTableView.dataSource = self;

    [self.ordersTableView setDoubleAction:@selector(doubleClick:)];
    [self updateTableData:false];
}

/**
 *
 * @param sender
 */
- (void)doubleClick:(id)sender {
    NSInteger row = self.ordersTableView.selectedRow;

    if (row == -1) return;

    OrderData *data = self.dataRows[row];

    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"cancel_order_param", @"Auftrag löschen?"), data.pair];
    NSString *info = NSLocalizedString(@"cancel_order_long", @"Auftrag löschen?");

    if ([Helper messageText:message info:info] == NSAlertFirstButtonReturn) {
        if ([data cancelOrder]) {
            [self.dataRows removeAllObjects];
            [self.ordersTableView reloadData];
        }
    }

    [self updateTableData:true];
}

/**
 *
 */
- (void)updateTableData:(BOOL)withDelay {

    if (withDelay) {
        // Warte einfach eine halbe Sekunde
        [NSThread sleepForTimeInterval:0.5];
    }

    NSArray *data = [OrderData fetchOrderData];

    if (self.dataRows == nil) {
        self.dataRows = [[NSMutableArray alloc] initWithArray:data];
    } else {
        [self.dataRows setArray:data];
    }

    [self.ordersTableView beginUpdates];
    for (long i = 0; i < data.count; i++) {
        [self.ordersTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withAnimation:NSTableViewAnimationEffectFade];
    }
    [self.ordersTableView endUpdates];

    [self.ordersTableView reloadData];
}

/**
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *
 * @param tableView
 * @return
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.dataRows.count;
}

/**
 *
 * @param tableView
 * @param tableColumn
 * @param row
 * @return
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    if (row == -1) { return nil; }

    OrderData *data = (OrderData *) self.dataRows[row];

    if ([tableColumn.title isEqualToString:@"DATE"]) {
        NSDateFormatter *from = [[NSDateFormatter alloc] init];
        [from setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'zz"];

        NSDate *fromDate = [from dateFromString:data.date];

        NSDateFormatter *to = [[NSDateFormatter alloc] init];
        [to setDateFormat:@"yyyy-MM-dd"];

        return [to stringFromDate:fromDate];
    }

    if ([tableColumn.title isEqualToString:@"PAIR"]) {
        return data.pair;
    }

    if ([tableColumn.title isEqualToString:@"AMOUNT"]) {
        return [Helper double2German:data.amount.doubleValue min:8 max:8];
    }

    if ([tableColumn.title isEqualToString:@"RATE"]) {
        return [Helper double2German:data.rate.doubleValue min:8 max:8];
    }

    return nil;
}

/**
 * close the dialog
 *
 * @param sender
 */
- (IBAction)dismissActionClicked:(id)sender {
    NSWindow *window = self.view.window;
    [window.sheetParent endSheet:window returnCode:NSModalResponseOK];
}

@end
