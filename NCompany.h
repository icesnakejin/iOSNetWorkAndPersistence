//
//  NCompany.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 12/1/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCompany : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (NCompany*)compantManagedObjectWithYear:(NSString*) year
                                    andId:(NSString *)name
                             andIsFavorte:(BOOL)isFavorite
                                  context:(NSManagedObjectContext*) context;

@end

NS_ASSUME_NONNULL_END

#import "NCompany+CoreDataProperties.h"
