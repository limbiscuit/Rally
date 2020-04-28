//
//  ShareViewController.m
//  Rally
//
//  Created by Brian Lim on 12/5/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import "ShareViewController.h"
#import "RallyPointsModel.h"

@interface ShareViewController ()

@property (strong, nonatomic) RallyPointsModel *model;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set color of navigation bar and text
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(21/255.0) green:(176/255.0) blue:(191/255.0) alpha:(1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    _model = [RallyPointsModel sharedModel];  // Use singleton
}

- (IBAction)shareButtonTapped:(id)sender{
    
    // Create action sheet to confirm emailing rally point
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Share Rally Point"
                                                                             message:@"Are you sure you want to share your rally point?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel tapped");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   if ([MFMailComposeViewController canSendMail]){
                                       
                                       if ([self.model getRallyLatitude] == NULL || [self.model getRallyLongitude] == NULL) {
                                           
                                           // Display error alert if there is no rally point set
                                           UIAlertController *errorAlertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                         message:@"No rally point is set!"
                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                           
                                           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                              style:UIAlertActionStyleCancel
                                                                                            handler:^(UIAlertAction *action)
                                                                                            {
                                                                                                NSLog(@"No rally point set");
                                                                                            }];
                                           
                                           [errorAlertController addAction:cancelAction];
                                           [self presentViewController:errorAlertController animated:YES completion:nil];
                                       }
                                       else {
                                           
                                           // Compose email and set recipients
                                           NSString *emailBody = [NSString stringWithFormat:@"Rally with me at %@, %@!", [self.model getRallyLatitude], [self.model getRallyLongitude]];
                                           NSArray *emailRecipients = [NSArray arrayWithObject: @"brianlim@usc.edu"];
                                           
                                           MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                                           mailVC.mailComposeDelegate = self;
                                           [mailVC setSubject:@"Rally with me!"];
                                           [mailVC setMessageBody:emailBody isHTML:NO];
                                           [mailVC setToRecipients:emailRecipients];
                                           
                                           [self presentViewController:mailVC animated:YES completion:nil];
                                       }
                                       
                                   }
                                   else {
                                       NSLog(@"Email Unavailable");
                                   }
                               }];
    /*
    UIAlertAction *messageAction = [UIAlertAction actionWithTitle:@"Message"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action)
                                 {
                                     if ([MFMessageComposeViewController canSendText]){
                                         
                                         NSString *messageBody = [NSString stringWithFormat:@"Meet me at %@, %@", [self.model getRallyLatitude], [self.model getRallyLongitude]];
                                         
                                         MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
                                         messageVC.messageComposeDelegate = self;
                                         [messageVC setBody:messageBody];
                                         [messageVC setRecipients:@[@"7142964027"]];
                                         
                                         [self presentViewController:messageVC animated:YES completion:nil];
                                     }
                                     else {
                                         NSLog(@"Text Messaging Unavailable");
                                     }
                                 }];
     */
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:okAction];
    //[alertController addAction:messageAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    // Record what user pressed if cancelling email
    if (result == MFMailComposeResultSent) {
        NSLog(@"Email sent!");
    }
    else if (result == MFMailComposeResultFailed) {
        NSLog(@"Email send failed!");
    }
    else if (result == MFMailComposeResultCancelled) {
        NSLog(@"Email cancelled!");
    }
    else if (result == MFMailComposeResultSaved) {
        NSLog(@"Email saved!");
    }
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss email compose view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
