//
//  NetworkOperation.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "NetworkOperation.h"
#import "Company.h"
#import <CoreData/CoreData.h>


@interface NetworkOperation ()

@property (nonatomic, copy) NSString *urlString;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (nonatomic) CompanyStorage *storage;


@end

@implementation NetworkOperation

- (instancetype) initWithHandler:(void(^)(NSArray * list)) handler
                    andURLString:(NSString*) urlString
                      andStorage:(CompanyStorage *) storage{
    
    if (self = [super init]) {
        self.completionHander = handler;
        self.urlString = urlString;
        self.storage = storage;
        self.context = [self.storage getPrivateContext];
    }
    return self;
}

- (void) saveCompanies:(NSArray *) companies {
    //__block NSUInteger index = 0;
    [self.context performBlockAndWait:^{
        for (NSUInteger i = 0; i < companies.count; i ++) {
            Company *company = [companies objectAtIndex:i];
            if (self.isCancelled) {
                
                return;
            }
            [self.storage encodeCompany:company andContext:self.context];
            
            
            //            if (i % 100 == 0) {
            //                NSError *error = nil;
            //                if (![self.context save:&error]) {
            //                    NSLog(@"save compnies failed");
            //                }
            //            }
            
        }
        NSError *error = nil;
        if (![self.context save:&error]) {
            NSLog(@"save compnies failed");
        }
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:koneBlockFinishNotif object:nil userInfo:@{@"currentIndex" : @(self.currentPersistenceindex + 100)}];
        //        if (self.completion) {
        //            self.completion (self.currentPersistenceindex + 100);
        //        }
    }];
    
    //[self.storage saveCompanies:self.companies];
    
}


- (void) main {
    
    // just for synchronization
    //dispatch_semaphore_t semo = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError *jsonError = nil;
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
            NSMutableString *temp = [NSMutableString stringWithString:jsonString];
            [temp deleteCharactersInRange:NSMakeRange(0, 1)];
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 1, 1)];
            
            NSDictionary *response = [NSJSONSerialization
                                      JSONObjectWithData: [temp dataUsingEncoding:kCFStringEncodingUTF8]
                                      options: NSJSONReadingMutableContainers
                                      error: &jsonError];
            NSArray *responseResult = response[@"result"];
            
            if (jsonError == nil) {
                NSMutableArray *result = [NSMutableArray new];
                for (int i = 0 ; i < 1000; i ++) {
                    NSDictionary *obj = responseResult[i];
                    Company *com = [[Company alloc] init];
                    com.year = obj[@"Year"];
                    com.companyName = obj[@"Company"];
                    [result addObject:com];
                }
                //                [responseResult enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //                    Company *com = [[Company alloc] init];
                //                    com.year = obj[@"Year"];
                //                    com.companyName = obj[@"Company"];
                //                    com.isFavorite = @(NO);
                //                    [result addObject:com];
                //                }];
                [self saveCompanies:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.completionHander) {
                        self.completionHander(result);
                    }
                });
                //dispatch_semaphore_signal(semo);
                
            }
        }
    }];
    [dataTask resume];
    //dispatch_semaphore_wait(semo, DISPATCH_TIME_FOREVER);
    
}


@end
