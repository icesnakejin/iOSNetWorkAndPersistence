//
//  CompanyStorage.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import <CoreData/CoreData.h>
#import "CompanyStorage.h"

#import "CompanyManagedObject.h"

@interface CompanyStorage : NSObject

@property (nonatomic, strong, readonly, nonnull) NSManagedObjectContext *managedContext;

// core data
- (void) saveCompany:( Company * _Nullable ) company;
- (void) saveCompanies:(NSArray * _Nullable) companies;
- (void) updateOneCompany:(Company * _Nonnull) company;
- (void) deleteOneCompany:(Company *) company;
- (void) fetchCompanyListWithCompletionHander:(void (^_Nullable)(  NSArray * _Nonnull list)) complationHandler;
- (BOOL) checkIfThereIsObject;
- (NSManagedObjectContext* _Nonnull) getPrivateContext;

- (void) encodeCompany:(Company *) company
            andContext:(NSManagedObjectContext *) context;

- (Company*) decodeCompany:(CompanyManagedObject *) managedObject;





@end
