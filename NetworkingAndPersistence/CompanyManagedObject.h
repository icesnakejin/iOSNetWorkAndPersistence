//
//  CompanyManagedObject.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface CompanyManagedObject : NSManagedObject
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, assign) BOOL isFavorite;
+ (CompanyManagedObject*)compantManagedObjectWithYear:(NSString*) year
                                                andId:(NSString *)name
                                         andIsFavorte:(BOOL)isFavorite
                                              context:(NSManagedObjectContext*) context;
@end
