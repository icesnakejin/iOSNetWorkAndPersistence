//
//  NetworkOperation.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyStorage.h"

@interface NetworkOperation : NSOperation

@property (nonatomic) void(^completionHander)(NSArray*);

- (instancetype) initWithHandler:(void(^)(NSArray * list)) handler
                    andURLString:(NSString*) urlString
                      andStorage:(CompanyStorage *) storage;

@end
