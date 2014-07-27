//
//  ButtonIndex.h
//  RatingbyPolitics
//
//  Created by CooLX on 20/04/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonIndex : UIButton
@property (nonatomic) NSIndexPath *button_indexPath;

@property ( nonatomic)  UIImageView *logo;
@property ( nonatomic)  UILabel *name;
@property ( nonatomic)  UILabel *post;
@property ( nonatomic)  UILabel *age;
@property ( nonatomic)  UILabel *rating;
@property ( nonatomic)  ButtonIndex *up;
@property ( nonatomic)  ButtonIndex *down;

@end
