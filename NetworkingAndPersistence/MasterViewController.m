//
//  MasterViewController.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CompanyStorage.h"
#import "CompanyStorage+UserDefault.h"
#import "Company.h"
#import "CompanyManagedObject.h"
#import "NetworkAdaptor.h"
#import "CompanyTableViewCell.h"
#import "CompanyStoreOperation.h"
#import "NetworkOperation.h"
#import "MasterViewDataSource.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property (nonatomic, strong, nonnull) CompanyStorage *companyStorage;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) MasterViewDataSource *dataSource;
@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.companyStorage = [[CompanyStorage alloc] init];
    if (!self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    
    self.dataSource = [[MasterViewDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.configureCellBlock = ^(CompanyTableViewCell *cell , Company *company) {
        [cell setCellFromCompany:company];
    };
    
    self.tableView.dataSource = self.dataSource;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForegound)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
    // core data
    
    [self.dataSource fetchData];
    
//    if ([self.companyStorage checkIfThereIsObject]) {
//        [self.companyStorage fetchCompanyListWithCompletionHander:^(NSArray * _Nonnull list) {
//            self.objects = [NSMutableArray arrayWithArray:list];
//            [self.tableView reloadData];
//        }];
//    } else {
//        __block CompanyStoreOperation *operation = [[CompanyStoreOperation alloc] initWithStorage:self.companyStorage andCompanies:self.objects];
//        NetworkOperation *netWorkOperation = [[NetworkOperation alloc] initWithHandler:^(NSArray * list) {
//            self.objects = [NSMutableArray arrayWithArray:list];
//            [operation setCompanies:list];
//            //[self.tableView reloadData];
//        } andURLString:@"http://gomashup.com/json.php?fds=finance/fortune500/year/2008"];
//        
//        
//        [operation addDependency:netWorkOperation];
//        
//        [self.operationQueue addOperation:netWorkOperation];
//        [self.operationQueue addOperation:operation];
    
//        [[NetworkAdaptor sharedInstance] remotelyFetchDataWithURLString:@"http://gomashup.com/json.php?fds=finance/fortune500/year/2008" andComplationHandler:^(NSArray * _Nonnull list) {
//            
//            // core Data
//            CompanyStoreOperation *operation = [[CompanyStoreOperation alloc] initWithStorage:self.companyStorage andCompanies:list];
//            [self.operationQueue addOperation:operation];
//            //[self.companyStorage saveCompanies:list];
//            self.objects = [NSMutableArray arrayWithArray:list];
//            [self.tableView reloadData];
//        }];
//    }
    
    // NSUser default
//    NSArray *cache = [self.companyStorage getListByUserDefault];
//    if (cache != nil && [cache count] > 0) {
//        self.objects = [NSMutableArray arrayWithArray:cache];
//    } else {
//        [[NetworkAdaptor sharedInstance] remotelyFetchDataWithURLString:@"http://gomashup.com/json.php?fds=finance/fortune500/year/2008" andComplationHandler:^(NSArray * _Nonnull list) {
//
//            [self.companyStorage saveCompaniesUsingUD:list];
//            self.objects = [NSMutableArray arrayWithArray:list];
//            [self.tableView reloadData];
//        }];
//
//    }
    
    [self.tableView registerClass:[CompanyTableViewCell class] forCellReuseIdentifier:@"companyCell"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSArray *result = [self.companyStorage fetchCompanyList];
//    CompanyManagedObject *company = [result firstObject];
//    NSLog(@"year : %@", company.year);
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    [self.dataSource insertNewRow];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma -mark Background

- (void) didEnterBackground {
    [self.dataSource didiEnterBG];
}

- (void) willEnterForegound {
    [self.dataSource willEnterFG];
}


@end
