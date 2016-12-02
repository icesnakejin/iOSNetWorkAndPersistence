//
//  NetworkAdaptor.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/20/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface NetworkAdaptor : NSObject

+ (NetworkAdaptor*) sharedInstance;

- (void) remotelyFetchDataWithURLString:(NSString*) urlString
                   andComplationHandler:(void (^ _Nonnull) (NSArray * _Nonnull list)) completionHander;
                    

@end
