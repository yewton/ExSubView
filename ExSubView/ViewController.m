//
//  ViewController.m
//  ExSubView
//
//  Created by 佐々木 悠人 on 2012/11/26.
//  Copyright (c) 2012年 yewton. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize scrollView = _scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self registerForKeyboardNotifications];

    self.tableView.transform = CGAffineTransformMakeRotation(M_PI);
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    CGFloat h = r.size.height;
    
    CGRect textFieldFrame = self.textField.frame;
    CGRect tableViewFrame = self.tableView.frame;
    CGRect buttonFrame = self.button.frame;
    
    // set the table frame
    {
        [self.tableView setFrame:CGRectMake(0.0, 0.0, w, h - 80.0)];
        static CGFloat innerOffset = 9.0;
        UIEdgeInsets insets = UIEdgeInsetsMake(0.0, // top
                                               0.0, // left
                                               0.0, // bottom
                                               CGRectGetWidth(_tableView.frame) - innerOffset // right
                                               );
        self.tableView.scrollIndicatorInsets = insets;
    }

    // set frames of the text field and the button
    {
        static CGFloat padding = 7.0;
        CGFloat offsetY = CGRectGetMaxY(tableViewFrame) + padding;
        [self.textField setFrame:CGRectMake(CGRectGetMinX(textFieldFrame),
                                            offsetY,
                                            CGRectGetWidth(textFieldFrame),
                                            CGRectGetHeight(textFieldFrame))];
        [self.button setFrame:CGRectMake(CGRectGetMinX(buttonFrame),
                                         offsetY,
                                         CGRectGetWidth(buttonFrame),
                                         CGRectGetHeight(buttonFrame))];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // UIKeyboardFrameEndUserInfoKeyが使える時と使えない時で処理を分ける
    CGRect keyboardBounds;
    if (&UIKeyboardFrameEndUserInfoKey == NULL) {
        // iOS 3.0 or 3.1
        // bounds
        keyboardBounds = [[aNotification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    } else {
        // それ以外
        // frameだがoriginを使わないのでbounds扱いで良い
        keyboardBounds = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }
    CGFloat keyboardHeight = keyboardBounds.size.height;
    CGPoint scrollPoint = CGPointMake(0.0, keyboardHeight);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
//    [self.scrollView setContentSize:CGSizeMake(0.0, 0.0)];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger index = (self.messages.count - 1) - indexPath.row;
    cell.textLabel.text = [self.messages objectAtIndex: index];
    cell.transform = CGAffineTransformMakeRotation(-M_PI);
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
	CGSize bounds = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
 	CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font
                                  constrainedToSize:bounds
                                      lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

#pragma mark -
#pragma mark UITableViewDelegate


#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)send:(id)sender
{
    NSString *message = [self.messageInput text];
    if (0 == [message length]) {
        return;
    }
    [self.messages addObject:message];
    [self.messageInput setText:@""];
    [self.tableView reloadData];
}

@end
