//
//  Company.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic) BOOL isFavorite;

- (instancetype) initWithName:(NSString*)name
                      andYear:(NSString*)year;

@end
