//
//  CompanyStoreOperation.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "CompanyStoreOperation.h"

@interface CompanyStoreOperation ()

@property (nonatomic) CompanyStorage *storage;
@property (nonatomic) NSArray *companies;
@property (nonatomic) NSManagedObjectContext *context;



@end

@implementation CompanyStoreOperation

- (instancetype) initWithStorage:(CompanyStorage *)storage
                    andCompanies:(NSArray *)companies{
    if (self = [super init]) {
        self.storage = storage;
        self.companies = companies;
    }
    return self;
}

//- (void) start {
//    NSLog(@"start");
//}

- (void) main {
    self.context = [self.storage getPrivateContext];
    [self saveCompanies];
    //self.storage saveCompanies:;
}

- (void) saveCompanies {
    //__block NSUInteger index = 0;
    [self.context performBlockAndWait:^{
        for (NSUInteger i = self.currentPersistenceindex; i < self.currentPersistenceindex + 100 && i < self.companies.count; i ++) {
            Company *company = [self.companies objectAtIndex:i];
            if (self.isCancelled) {
                
                return;
            }
            [self.storage encodeCompany:company andContext:self.context];
            
            
//            if (i % 100 == 0) {
//                NSError *error = nil;
//                if (![self.context save:&error]) {
//                    NSLog(@"save compnies failed");
//                }
//            }

        }
        NSError *error = nil;
        if (![self.context save:&error]) {
            NSLog(@"save compnies failed");
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:koneBlockFinishNotif object:nil userInfo:@{@"currentIndex" : @(self.currentPersistenceindex + 100)}];
//        if (self.completion) {
//            self.completion (self.currentPersistenceindex + 100);
//        }
    }];
    
    //[self.storage saveCompanies:self.companies];
    
}

- (void) setCompanies:(NSArray *)company {
    _companies = company;
}



@end
