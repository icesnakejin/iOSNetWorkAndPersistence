//
//  NCompany.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 12/1/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "NCompany.h"

@implementation NCompany

// Insert code here to add functionality to your managed object subclass

+ (NCompany*)compantManagedObjectWithYear:(NSString*) year
                                                andId:(NSString *)name
                                         andIsFavorte:(BOOL)isFavorite
                                              context:(NSManagedObjectContext*) context {
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"NCompany" inManagedObjectContext:context];
    NCompany *companyObject = [[NCompany alloc] initWithEntity:companyEntity insertIntoManagedObjectContext:context];
    companyObject.year = year;
    companyObject.companyName = name;
    companyObject.isFavorite = isFavorite;
    return companyObject;
}

@end
