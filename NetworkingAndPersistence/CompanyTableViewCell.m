//
//  CompanyTableViewCell.m
//  NetworkingAndPersistence
//
//  Created by Yankun Jin on 11/20/16.
//  Copyright © 2016 Yankun Jin. All rights reserved.
//

#import "CompanyTableViewCell.h"

@interface CompanyTableViewCell ()

@property (nonatomic) UIButton *fav;
@property (nonatomic) Company *company;

@end

@implementation CompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellFromCompany:(Company *)company {
    if (!self.fav) {
        self.fav = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , 30, 30)];
        self.fav.center = CGPointMake(self.contentView.center.x + 10, self.contentView.center.y);
        [self.fav setBackgroundColor:[UIColor blueColor]];
        [self addSubview:self.fav];
        [self bringSubviewToFront:self.fav];
        [self.fav addTarget:self action:@selector(btnDidTouched:) forControlEvents:UIControlEventTouchDown];
        
        //if (company.isFavorite.boolValue == YES) {
        
        //}
        
    }
     self.fav.hidden = company.isFavorite;
    if ([company.companyName isEqualToString:@"iTutorGroup"]) {
        NSLog(@"iTutorGroup found");
    }
    
    if (company.isFavorite == YES) {
        NSLog(@"Favorite found");
    }
    
    [self.textLabel setText:company.companyName];
    [self.detailTextLabel setText:company.year];
    
    self.company = company;
}

- (void) btnDidTouched:(id) sender {
    _company.isFavorite = !_company.isFavorite;
    self.fav.hidden = _company.isFavorite;
    if (_delegate && [_delegate respondsToSelector:@selector(shouldChangeFavotire:)]) {
        [_delegate shouldChangeFavotire:self.company];
    }
}

@end
