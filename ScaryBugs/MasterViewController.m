//
//  MasterViewController.m
//  ScaryBugs
//
//  Created by chenjs on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"


@interface MasterViewController () {
    
}
@end

@implementation MasterViewController

@synthesize bugs = _bug;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBugDoc:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = @"Scray Bugs";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewBugDoc:(id)sender
{
    ScaryBugDoc *newBugDoc = [[ScaryBugDoc alloc] initWithTitle:@"New Bug" rating:1 thumbImage:nil fullImage:nil];
    [self.bugs addObject:newBugDoc];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(self.bugs.count-1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:YES];
    
    
    [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"showDetail" sender:newIndexPath];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bugs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell"];
    ScaryBugDoc *bugDoc = [self.bugs objectAtIndex:indexPath.row];
    cell.textLabel.text = bugDoc.data.title;
    cell.imageView.image = bugDoc.thumbImage;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ScaryBugDoc *doc = [self.bugs objectAtIndex:indexPath.row];
        [doc deleteDoc];
        
        [self.bugs removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        ScaryBugDoc *bugDoc = self.bugs[indexPath.row];
        [[segue destinationViewController] setBugDocItem:bugDoc];
    }
}

@end
