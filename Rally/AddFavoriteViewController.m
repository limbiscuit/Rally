//
//  AddFavoriteViewController.m
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import "AddFavoriteViewController.h"

@interface AddFavoriteViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set color of navigation bar and text
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(21/255.0) green:(176/255.0) blue:(191/255.0) alpha:(1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}


- (void) enableSaveButton: (NSString *) nameText
                 latitude: (NSString *) latitudeText
                longitude: (NSString *) longitudeText {
    
    // Enable save button if all fields have entries
    self.saveButton.enabled = (nameText.length > 0 && latitudeText.length > 0 && longitudeText.length > 0);
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *changedString = [textField.text
                               stringByReplacingCharactersInRange:range
                               withString:string];
    
    [self enableSaveButton: changedString
                  latitude: self.latitudeTextField.text
                 longitude: self.longitudeTextField.text];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    // If user touches outside of text fields, dismiss the keyboard
    
    if ([self.nameTextField isFirstResponder] && [touch view] != self.nameTextField){
        [self.nameTextField resignFirstResponder];
    }
    
    if ([self.latitudeTextField isFirstResponder] && [touch view] != self.latitudeTextField){
        [self.latitudeTextField resignFirstResponder];
    }
    
    if ([self.longitudeTextField isFirstResponder] && [touch view] != self.longitudeTextField){
        [self.longitudeTextField resignFirstResponder];
    }
    
    [super touchesBegan: touches withEvent: event];
}

- (IBAction)cancelButtonTapped:(id)sender {
    self.nameTextField.text = nil;
    self.latitudeTextField.text = nil;
    self.longitudeTextField.text = nil;
    self.saveButton.enabled = NO;
    
    if (self.uponCompletion) {
        self.uponCompletion(nil,nil,nil);
    }
}


- (IBAction)saveButtonTapped:(id)sender {
    if (self.uponCompletion) {
        self.uponCompletion(self.nameTextField.text, self.latitudeTextField.text, self.longitudeTextField.text);
    }
    
    self.nameTextField.text = nil;
    self.latitudeTextField.text = nil;
    self.longitudeTextField.text = nil;
    self.saveButton.enabled = NO;
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
