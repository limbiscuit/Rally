//
//  ShareViewController.h
//  Rally
//
//  Created by Brian Lim on 12/5/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate> //, MFMessageComposeViewControllerDelegate>

- (IBAction)shareButtonTapped:(id)sender;

@end
