//
//  NCompany+CoreDataProperties.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 12/1/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCompany.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCompany (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nonatomic, assign)BOOL isFavorite;


@end

NS_ASSUME_NONNULL_END
