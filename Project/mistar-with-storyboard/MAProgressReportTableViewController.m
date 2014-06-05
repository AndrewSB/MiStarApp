//
//  MAProgressReportTableViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 5/29/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAProgressReportTableViewController.h"

@interface MAProgressReportTableViewController ()

@end

@implementation MAProgressReportTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom init
    }
    return self;
}

- (id)initWithRow:(NSInteger *)row
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.row = row;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.row = (int)self.row - 1;
    MAClass *class = [[[self readFromDict] objectForKey:@"classes"] objectAtIndex:(int)self.row];
    self.sourceArray = [class assignments];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Opened progress report, %@", [class name]]];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    
    if ([self.sourceArray count] == 1) {
        UIImageView *sadFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 45, 160, 160)];
        [sadFaceImageView setImage:[UIImage imageNamed:@"page-not-found"]];
        
        self.tableView.tableHeaderView.frame = CGRectMake(0, 200, 200, 100);
        
        UILabel *sadFaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 200, 250, 44)];
        sadFaceLabel.text = @"No Recent Assignments";
        
        [self.tableView addSubview:sadFaceImageView];
        [self.tableView addSubview:sadFaceLabel];
    }
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 5)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.sourceArray count] == 0) return 0;
    else return [self.sourceArray count] - 1;
    //NSLog(@"array is set to %@", self.array);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MAAssignment *assignment = [self.sourceArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [assignment assignmentName]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@", [assignment recievedPoints], [assignment totalPoints]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.selectedRowIndex = indexPath;
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row) {
        [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return 100;
    }
    return 44;
}



#pragma mark - I/O

- (NSDictionary *)readFromDict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/userdata.txt"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


                            
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
