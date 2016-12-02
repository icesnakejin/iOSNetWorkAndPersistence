//
//  MasterViewDataSource.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CompanyStoreOperation.h"
#import "NetworkOperation.h"
#import "CompanyTableViewCell.h"

@interface MasterViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate, CompanyTableViewCellDelegate>

@property (nonatomic) void (^configureCellBlock) (id cell, id item);

- (instancetype) initWithTableView:(UITableView*) tableView;

- (void) fetchData;

- (void) updateCompany:(Company *)company;

- (void) insertNewRow;

- (void) didiEnterBG;

- (void) willEnterFG;

@end
