//
//  CompanyStorage+UserDefault.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/21/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "CompanyStorage.h"

@interface CompanyStorage (UserDefault)

// NSUserDefault
- (void) saveCompaniesUsingUD:(NSArray * _Nullable) companies;
- ( NSArray * _Nullable  ) getListByUserDefault;
- (void) updateOneCompanyByUD:(Company *) company;

@end
