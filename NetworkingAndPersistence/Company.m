//
//  Company.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/19/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "Company.h"

@interface Company () <NSCoding>

@end

@implementation Company

- (instancetype) initWithName:(NSString *)name andYear:(NSString *)year {
    if (self = [super init]) {
        self.companyName = name;
        self.year = year;
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.year = [aDecoder decodeObjectForKey:@"year"];
        self.isFavorite = [aDecoder decodeBoolForKey:@"isFavorite"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeBool:self.isFavorite forKey:@"isFavorite"];
}



@end
