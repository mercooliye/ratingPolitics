//
//  MySingleton.h
//  RatingbyPolitics
//
//  Created by CooLX on 21/04/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingleton : NSObject
{
    NSIndexPath *index;
    NSMutableArray *images;
    NSString *ID;
    NSString *name;
}
@property NSIndexPath *index;
@property NSMutableArray *images;
@property NSString *ID;
@property NSString *name;
+(MySingleton *)sharedMySingleton;


@end
