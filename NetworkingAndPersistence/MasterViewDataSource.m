//
//  MasterViewDataSource.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "MasterViewDataSource.h"



@interface MasterViewDataSource ()

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong, nonnull) CompanyStorage *companyStorage;
@property (nonatomic, assign) NSUInteger totalItemNum;
@property (nonatomic, strong) NSArray *list;


@end

@implementation MasterViewDataSource

- (instancetype) initWithTableView:(UITableView*) tableView {
    self = [super init];
    if(self) {
        self.tableView = tableView;
        
        [self setup];
    }
    return self;

}

- (void) fetchData {
    [self.fetchedResultsController performFetch:NULL];
    if ([self.fetchedResultsController fetchedObjects] == nil || [self.fetchedResultsController fetchedObjects].count == 0) {
    
        NetworkOperation *netWorkOperation = [[NetworkOperation alloc] initWithHandler:^(NSArray * list) {
            [self.tableView reloadData];
        } andURLString:@"http://gomashup.com/json.php?fds=finance/fortune500/year/2008" andStorage:self.companyStorage];
         [self.operationQueue addOperation:netWorkOperation];
      }
}

- (void)setup {
    self.tableView.dataSource = self;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.companyStorage = [[CompanyStorage alloc] init];
    self.fetchedResultsController = [self getFetchingController];
    self.fetchedResultsController.delegate = self;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneBlockDataFinished:) name:koneBlockFinishNotif object:nil];
    //[self.fetchedResultsController performFetch:NULL];
}

- (void) oneBlockDataFinished:(NSNotification*) notif {
    if ([notif.name isEqualToString:koneBlockFinishNotif]) {
        NSUInteger n = [notif.userInfo[@"currentIndex"] unsignedIntegerValue];
        if (n < self.list.count) {
            CompanyStoreOperation *operation = [[CompanyStoreOperation alloc] initWithStorage:self.companyStorage
                                                                                 andCompanies:self.list];
            operation.currentPersistenceindex = n;
            [self.operationQueue addOperation:operation];
        }
    }
}

- (void)changePredicate:(NSPredicate*)predicate {
    NSAssert(self.fetchedResultsController.cacheName == NULL, @"Can't change predicate when you have a caching fetched results controller");
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    fetchRequest.predicate = predicate;
    NSInteger numberOfSections = self.tableView.numberOfSections;
    [self.fetchedResultsController performFetch:NULL];
    NSInteger newNumberOfSections = self.fetchedResultsController.sections.count;
    [self.tableView reloadData];
}

- (id)itemAtIndexPath:(NSIndexPath*)path {
    return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:path.row inSection:path.section]];
}

- (id)selectedItem {
    return [self itemAtIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (void)configureCell:(CompanyTableViewCell*)cell atIndexPath:(NSIndexPath*)path {
    id item = [self itemAtIndexPath:path];
    cell.delegate = self;
    if(self.configureCellBlock) {
        self.configureCellBlock(cell, item);
    }
}

#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView*)aTableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger i = [self.fetchedResultsController.sections[(NSUInteger) section] numberOfObjects];
    return i;
}

- (NSString*)tableView:(UITableView*)aTableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> info = [self.fetchedResultsController sections][(NSUInteger) section];
    return info.name;
}

- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    CompanyTableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"companyCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.companyStorage deleteOneCompany:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        [self insertNewRow];
    }
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if([self.tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
                [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

#pragma -mark action Hander
- (void) updateCompany:(id)company {
    [self.companyStorage updateOneCompany:company];
}

- (void) insertNewRow {
    Company *newComany = [[Company alloc] init];
    newComany.companyName = @"aaaaaaaaaaaa";
    newComany.year = @"2008";
    [self.companyStorage saveCompany:newComany];
}


- (void) didiEnterBG {
    [self.operationQueue setSuspended:YES];
}

- (void) willEnterFG {
    //[self.operationQueue setSuspended:NO];
}
#pragma -mark private

- (NSFetchedResultsController *) getFetchingController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NCompany"];
    NSSortDescriptor * sDes = [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES];
    [request setSortDescriptors:@[sDes]];
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self.companyStorage managedContext] sectionNameKeyPath:nil cacheName:nil];
    return fetchController;
}

#pragma -mark CompanyTableViewDelegate

- (void) shouldChangeFavotire:(Company *)company {
    [self updateCompany:company];
    //[self.companyStorage updateOneCompanyByUD:company];
}

@end
