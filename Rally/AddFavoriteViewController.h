//
//  AddFavoriteViewController.h
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddFavoriteCompletionHandler)(NSString *name,
                                            NSString *latitude,
                                            NSString *longitude);

@interface AddFavoriteViewController : UIViewController

@property (copy, nonatomic) AddFavoriteCompletionHandler uponCompletion;

@end
