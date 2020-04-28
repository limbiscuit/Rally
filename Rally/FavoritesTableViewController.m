//
//  FavoritesTableViewController.m
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "RallyPointsModel.h"
#import "AddFavoriteViewController.h"


@interface FavoritesTableViewController ()

@property (strong, nonatomic) RallyPointsModel *model;

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set color of navigation bar and text
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(21/255.0) green:(176/255.0) blue:(191/255.0) alpha:(1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    _model = [RallyPointsModel sharedModel]; // Use singleton
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData]; // Reload data each time user switches back to the favorites tab
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model numberOfFavorites];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"
                                                            forIndexPath:indexPath];
    
    // Set data for table cell
    NSDictionary *favorite = [self.model favoriteAtIndex:indexPath.row];
    cell.textLabel.text = favorite[kName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f\u00B0, %f\u00B0", [favorite[kLatitude] doubleValue], [favorite[kLongitude] doubleValue]];
    
    // Set colors of table cell
    cell.textLabel.textColor = [UIColor colorWithRed:(21/255.0) green:(176/255.0) blue:(191/255.0) alpha:(1)];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:(225/255.0) green:(175/255.0) blue:(19/255.0) alpha:(1)];

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.model removeFavoriteAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navigationController = [segue destinationViewController];
    AddFavoriteViewController *addFavoriteVC = [[navigationController viewControllers] lastObject];
    addFavoriteVC.uponCompletion = ^(NSString *name, NSString *latitude, NSString *longitude){
        
        if(name != nil){ // If entry is valid, add to favorites array
            
            // Create dictionary for new added favorite
            NSDictionary *favorite = [[NSDictionary alloc] initWithObjectsAndKeys:name, kName, latitude, kLatitude, longitude, kLongitude, nil];
            
            [self.model insertFavorite: favorite]; // Add new favorite to favorites array
            [self.tableView reloadData];  // Reload table of favorites
        }
        [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss add favorite view
    };
}


@end
