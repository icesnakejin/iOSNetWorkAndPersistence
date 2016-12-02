//
//  CompanyStorage.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "CompanyStorage.h"
//
#import "CompanyManagedObject.h"

#import "NCompany.h"

#import "AppDelegate.h"



@interface CompanyStorage ()
// core data
@property(nonatomic, strong, readwrite) NSManagedObjectContext *managedContext;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistenceCoordinator;

@end

@implementation CompanyStorage
- (instancetype) init {
   
    if (self = [super init]) {
        
        return self;
    }
    return nil;
}

- (BOOL) checkIfThereIsObject {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NCompany"];
    __block NSUInteger count = -1;
    [self.managedContext performBlockAndWait:^{
        NSError *error = nil;
        count = [self.managedContext countForFetchRequest:request error:&error];
        if (count == NSNotFound) {
            NSAssert(count != NSNotFound, @"Enitity Named \" Company\" not found");
        }
    }];
    return count > 0;
}

- (void) fetchCompanyListWithCompletionHander:(void (^_Nullable)(NSArray * list)) complationHandler {
    NSFetchRequest *fRequest = [self batchFetchingRequest];
    NSSortDescriptor *sD = [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES];
    fRequest.sortDescriptors = @[sD];
    [self executeFetchRequest:fRequest
          withComplationBlock:complationHandler];
    
}

- (void) executeFetchRequest:(NSFetchRequest*) request
         withComplationBlock:(void  (^_Nullable)(NSArray *list)) completionHander{
    NSManagedObjectContext *privateContext = [self getPrivateContext];
    [privateContext performBlock:^{
        NSError *error = nil;
        NSArray *result = nil;
        result = [self.managedContext executeFetchRequest:request error:&error];
        if (error == nil && result != nil) {
            NSArray *converted = [self convertToPlainDataModel:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHander) {
                    completionHander(converted);
                }
            });
        }
    }];
}

- (NSArray *) convertToPlainDataModel:(NSArray *) managedObjects {
    NSMutableArray *result = [NSMutableArray array];
    [managedObjects enumerateObjectsUsingBlock:^(NCompany *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Company *company = [[Company alloc] init];
        company.year = obj.year;
        company.companyName = obj.companyName;
        company.isFavorite = obj.isFavorite;
        [result addObject:company];
    }];
    return result;
}

- (void) saveCompanies:(NSArray *) companies {
    NSManagedObjectContext *privateContext = [self getPrivateContext];
    [privateContext performBlock:^{
        __weak NSManagedObjectContext *weakManager = self.managedContext;
        [companies enumerateObjectsUsingBlock:^(Company *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self encodeCompany:obj andContext:privateContext];
        }];
       
        // child context update first
        NSError *error = nil;
        if (![privateContext save:&error]) {
            NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        
        [weakManager performBlockAndWait:^{
            NSError *error = nil;
            if (![weakManager save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                abort();
            }
        }];
        
    }];
}

- (void) saveCompany:(Company *) company {
    __weak NSManagedObjectContext *weakManager = self.managedContext;
    NSManagedObjectContext *privateContext = [self getPrivateContext];
    [privateContext performBlock:^{
        [self encodeCompany:company andContext:privateContext];
        // child context update first
        NSError *error = nil;
        if (![privateContext save:&error]) {
            NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        
        [weakManager performBlockAndWait:^{
            NSError *error = nil;
            if (![weakManager save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                abort();
            }
        }];
        
    }];
    
}

- (void) encodeCompany:(Company *) company
            andContext:(NSManagedObjectContext *) context{
    [NCompany compantManagedObjectWithYear:company.year
                                                 andId:company.companyName
                                                 andIsFavorte:company.isFavorite
                                               context:context];
}

- (Company*) decodeCompany:(NCompany *) managedObject {
    Company *company = [[Company alloc] init];
    company.year = managedObject.year;
    return company;
}

- (void) saveDataToDataBaseWithContext:(NSManagedObjectContext*) context {
    NSError *error = nil;
    if ([context hasChanges]) {
        if (![context save:&error]) {
            NSLog(@"save object failed");
            abort();
        }
    }
}

- (void) deleteOneCompany:(Company *) company {
    NCompany *mcom = [self getOneCompanyManagedobject:company];
    @try {
        [self.managedContext deleteObject:mcom];
        NSError *error = nil;
        if (![self.managedContext save:&error]) {
            NSLog(@"delete object failed");
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    } @finally {
        return;
    }
}


- (void) updateOneCompany:(Company *) company {
    NCompany *mcom = [self getOneCompanyManagedobject:company];
    if (mcom != nil) {
        mcom.isFavorite = company.isFavorite;
        mcom.companyName = company.companyName;
        mcom.year = company.year;
        NSError *error = nil;
        if ([self.managedContext hasChanges]) {
            [self.managedContext save:&error];
        }
    }
}

- (NCompany*) getOneCompanyManagedobject:(Company *) company {
    NSFetchRequest *request = [self batchFetchingRequest];
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"companyName = \'%@\'", company.companyName]];
    NSError *error = nil;
    NSArray *result = [self.managedContext executeFetchRequest:request error:&error];
    NCompany *com = nil;
    if (error == nil && result != nil) {
        com = [result lastObject];
    }
    return com;
}

- (NSFetchRequest*) batchFetchingRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NCompany"];
    return request;
}

#pragma -mark accessors

- (NSManagedObjectModel*) initializeMOM {
    // initilize entity
    NSEntityDescription *companyEntity = [[NSEntityDescription alloc] init];
    [companyEntity setName:@"NCompany"];
    [companyEntity setManagedObjectClassName:NSStringFromClass([CompanyManagedObject class])];
    
//    NSAttributeDescription *yearDes = [NSAttributeDescription new];
//    [yearDes setName:@"year"];
//    yearDes.attributeType = NSStringAttributeType;
//    yearDes.optional = NO;
//    yearDes.indexed = NO;
//    
//    NSAttributeDescription *idDes = [NSAttributeDescription new];
//    [idDes setName:@"companyName"];
//    idDes.attributeType = NSStringAttributeType;
//    idDes.optional = NO;
//    idDes.indexed = YES;
//    
//    NSAttributeDescription *isFavorite = [NSAttributeDescription new];
//    [isFavorite setName:@"isFavorite"];
//    isFavorite.attributeType = NSBooleanAttributeType;
//    isFavorite.optional = YES;
//    isFavorite.indexed = NO;
//    
//    
//    companyEntity.properties = @[yearDes, idDes, isFavorite];
    
    // initialize NSManagedobjectModel;
//    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
//    [model setEntities:@[companyEntity]];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
     NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return model;
}

- (NSPersistentStoreCoordinator *) initializeCoordinator {
    // initialize pc
    NSPersistentStoreCoordinator * persistenceCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self initializeMOM]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"NCompanyDataModel.sqlite"];
    
    NSError *error = nil;
    [persistenceCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    return  persistenceCoordinator;
}

- (NSManagedObjectContext*) managedContext {
    if (!_managedContext) {
        // initialized contect
        _managedContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedContext setPersistentStoreCoordinator:[self initializeCoordinator]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            if (note.object != _managedContext) {
                [_managedContext mergeChangesFromContextDidSaveNotification:note];
            }
        }];
    }
    return _managedContext;
}

- (NSManagedObjectContext*) getPrivateContext {
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateContext.persistentStoreCoordinator = self.managedContext.persistentStoreCoordinator;
    return privateContext;
}

@end
