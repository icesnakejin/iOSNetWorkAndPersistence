//
//  NetworkAdaptor.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/20/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "NetworkAdaptor.h"
#import "Company.h"

static NetworkAdaptor *adaptor;

@interface NetworkAdaptor ()
@end

@implementation NetworkAdaptor

+(NetworkAdaptor*) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (adaptor == nil) {
            adaptor = [[NetworkAdaptor alloc] init];
        }
    });
    return adaptor;
}

- (void) remotelyFetchDataWithURLString:(NSString*) urlString
                   andComplationHandler:(void (^ _Nonnull) (NSArray * _Nonnull list)) completionHander{
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                for (int i = 0 ; i < 100; i ++) {
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHander(result);
                });

                
            }
        }
    }];
    [dataTask resume];
}

@end
