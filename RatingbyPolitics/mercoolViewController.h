//
//  mercoolViewController.h
//  RatingbyPolitics
//
//  Created by CooLX on 19/04/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cellPolitics.h"
#import "ButtonIndex.h"
#import <iAd/iAd.h>

@interface mercoolViewController : UIViewController <ADBannerViewDelegate>
{
    ADBannerView    *adView;
    BOOL bannerVisible;
}
@property (nonatomic,assign) BOOL bannerIsVisible;
@property (weak, nonatomic) IBOutlet ADBannerView *banner;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic)  NSMutableArray *images;
//@property (strong)  NSMutableArray *rating;
@property (strong, nonatomic)  NSMutableArray *images2;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic)  NSDictionary *responce;
//@property (strong, nonatomic)  NSMutableArray *jsondata;
@end
