//
//  CompanyTableViewCell.h
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/20/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@protocol CompanyTableViewCellDelegate <NSObject>

- (void) shouldChangeFavotire:(Company *) company;

@end

@interface CompanyTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id<CompanyTableViewCellDelegate> delegate;

- (void) setCellFromCompany:(Company *) company;

@end
