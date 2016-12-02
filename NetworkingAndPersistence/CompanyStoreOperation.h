//
//  CompanyStoreOperation.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyStorage.h"

static NSString *koneBlockFinishNotif = @"oneBlockDatapersisted";

@interface CompanyStoreOperation : NSOperation
@property (nonatomic, assign) NSUInteger currentPersistenceindex;
@property (nonatomic, strong) void(^completion)(NSUInteger n);

- (instancetype) initWithStorage:(CompanyStorage *) storage
                    andCompanies:(NSArray *) companies;
- (void) setCompanies:(NSArray *) company;

@end
