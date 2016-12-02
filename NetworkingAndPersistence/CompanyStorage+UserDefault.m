//
//  CompanyStorage+UserDefault.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "CompanyStorage+UserDefault.h"

static NSString *companyPrefix = @"companies";

@implementation CompanyStorage (UserDefault)

#pragma -mark NSUserDefault

- (void) saveCompaniesUsingUD:(NSArray * _Nullable) companies {
    [companies enumerateObjectsUsingBlock:^(Company * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveCompanyToData:obj];
    }];
}

- (void) saveCompanyToData:(Company *)company {
    NSData *data = [self encodeCompany:company];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[self getKey:company]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getKey:(Company*) company {
    return [NSString stringWithFormat:@"\%@\%@", companyPrefix, company.companyName];
}

- (NSArray *) getListByUserDefault {
    NSArray *allKeys = [self getAllKeys];
    NSMutableArray *result = [NSMutableArray new];
    [allKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[self decodeCompanyByData:[[NSUserDefaults standardUserDefaults] objectForKey:obj]]];
    }];
    return result;
}
//
//- (Company *) getCompanyByData:(NSData*) data {
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    Company *company = [[Company alloc] init];
//    company.companyName = dict[@"companyName"];
//    company.year = dict[@"year"];
//    company.isFavorite = dict[@"isFavorite"];
//    return company;
//}

- (NSArray*) getAllKeys {
    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self CONTAINS[cd] '%@' ", companyPrefix]];
    NSArray * keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    NSArray *result = [keys filteredArrayUsingPredicate:filter];
    return result;
}

- (NSData*) encodeCompany:(Company*) company{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: company];
    return data;
}

- (Company*) decodeCompanyByData:(NSData *) data {
    Company *company = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return company;
}

- (void) updateOneCompanyByUD:(Company *) company {
    //company.companyName = @"iTutorGroup";
    [self saveCompanyToData:company];
}


@end
