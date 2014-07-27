//
//  cellPolitics.h
//  RatingbyPolitics
//
//  Created by CooLX on 19/04/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonIndex.h"

@interface cellPolitics : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *post;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet ButtonIndex *up;
@property (weak, nonatomic) IBOutlet ButtonIndex *down;

@end
