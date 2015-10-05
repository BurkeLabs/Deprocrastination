//
//  ViewController.m
//  Deprocrastination
//
//  Created by Michelle Burke on 10/5/15.
//  Copyright © 2015 BurkeMedia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;

@property NSMutableArray *toDoList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [NSMutableArray new];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    [self.toDoList addObject:self.textField.text];
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    [self.tableView reloadData];
}

- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"yo it's ben: %i", indexPath.row);

    if (cell.textLabel.textColor == [UIColor greenColor]){
        cell.textLabel.textColor = [UIColor yellowColor];
    } else if (cell.textLabel.textColor == [UIColor yellowColor]){
        cell.textLabel.textColor = [UIColor redColor];
    } else if (cell.textLabel.textColor == [UIColor redColor]){
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        cell.textLabel.textColor = [UIColor greenColor];
    }
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender
{
        if (self.editing)
        {
            self.editing = false;
            [self.tableView setEditing:false animated:true];
            sender.style = UIBarButtonItemStylePlain;
            sender.title = @"Edit";
        }
        else
        {
            self.editing = true;
            [self.tableView setEditing:true animated:true];
            sender.style = UIBarButtonItemStyleDone;
            sender.title = @"Done";
        }
        [self.tableView reloadData];
    }

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Deletion" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:path];
            cell.textLabel.textColor = cell2.textLabel.textColor;
            [self.toDoList removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:delete];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self toDoList];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *titleItem = [self.toDoList objectAtIndex:sourceIndexPath.row];
    [self.toDoList removeObject:titleItem];
    [self.toDoList insertObject:titleItem atIndex:destinationIndexPath.row];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.toDoList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%li",self.toDoList.count);
    if (self.toDoList.count > 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoItem"];
        cell.textLabel.text = [self.toDoList objectAtIndex:indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
}

@end