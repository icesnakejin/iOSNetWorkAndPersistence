//
//  CompanyManagedObject.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "CompanyManagedObject.h"

@implementation CompanyManagedObject
@dynamic year;
@dynamic companyName;
@dynamic isFavorite;
+ (CompanyManagedObject*)compantManagedObjectWithYear:(NSString*) year
                                                andId:(NSString *)name
                                         andIsFavorte:(BOOL)isFavorite
                                              context:(NSManagedObjectContext*) context {
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:context];
    CompanyManagedObject *companyObject = [[CompanyManagedObject alloc] initWithEntity:companyEntity insertIntoManagedObjectContext:context];
    companyObject.year = year;
    companyObject.companyName = name;
    companyObject.isFavorite = isFavorite;
    return companyObject;
}



@end
