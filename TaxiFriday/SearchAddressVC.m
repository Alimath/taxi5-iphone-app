//
//  SearchAddressVC.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "SearchAddressVC.h"
#import "AddressCell.h"

@interface SearchAddressVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property NSMutableArray *searchResults;
@property UITextField *textField;
@property UITableView *tableView;
@property NSDictionary *address;

- (IBAction)doneButtonPressed:(id)sender;

@end

@implementation SearchAddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [NSMutableArray new];
    
    // Table view.
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= 44;
    tableViewFrame.origin.y = 50.0;
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddressCell class] forCellReuseIdentifier:NSStringFromClass([AddressCell class])];
    [self.view addSubview:self.tableView];
    
    // Text field view.
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_BOUNDS.size.width, 50)];
    textFieldView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    textFieldView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textFieldView];
    
    // Text field.
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, textFieldView.width - 20.0, 30)];
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.textField.font = [UIFont fontWithName:@"HelveticaNeueCyr-Roman" size:17];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.textColor = [UIColor colorWithColorCode:@"000000"];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor whiteColor];
    [textFieldView addSubview:self.textField];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressCell class])];
    cell.streetLabel.text = @"";
    cell.infoLabel.text = @"";
    cell.textLabel.text = @"";
    if ([self.searchResults count]) {
        NSDictionary *location = self.searchResults[indexPath.row];
        if ([location[@"name"] length]) {
            cell.streetLabel.text = location[@"name"];
            cell.infoLabel.text = location[@"street"];
        } else {
            cell.textLabel.text = location[@"street"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AddressCell height];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.address = self.searchResults[indexPath.row];
    [self chooseAddress];
    [tableView reloadData];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.textField resignFirstResponder];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString *searchString = [self.textField.text stringByTrimmingCharactersInSet:characterSet];
    if ([searchString length]) {
        [[Server sharedServer] getAddressesWithText:searchString success:^(id response) {
            [self.searchResults removeAllObjects];
            if ([response count]) {
                for (id address in response) {
                    NSMutableDictionary *location = [NSMutableDictionary new];;
                    NSString *street = address[@"street"];
                    NSString *building = address[@"building"];
                    NSString *name = address[@"name"];
                    NSString *city = address[@"city"];
                    NSNumber *addressID = address[@"id"];
                    NSString *code = address[@"code"];
                    if ([street length]) {
                        [location setObject:street forKey:@"street"];
                    } else {
                        [location setObject:@"" forKey:@"street"];
                    }
                    if ([building length]) {
                        [location setObject:building forKey:@"building"];
                    } else {
                        [location setObject:@"" forKey:@"building"];
                    }
                    if ([name length]) {
                        [location setObject:name forKey:@"name"];
                    } else {
                        [location setObject:@"" forKey:@"name"];
                    }
                    if ([city length]) {
                        [location setObject:city forKey:@"city"];
                    } else {
                        [location setObject:@"" forKey:@"city"];
                    }
                    if (addressID) {
                        [location setObject:addressID forKey:@"addressID"];
                    }
                    if ([code length]) {
                        [location setObject:code forKey:@"code"];
                    } else {
                        [location setObject:@"" forKey:@"code"];
                    }
                    [self.searchResults addObject:location];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            NSLog(@"Error - %@", [error localizedDescription]);
        }];
    } else {
        [self.searchResults removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)chooseAddress
{
    if (self.delegate) {
        [self.delegate searchAddressVC:self didChooseAddress:self.address];
    }
}

@end
