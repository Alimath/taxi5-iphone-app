//
//  RequestVC.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "RequestVC.h"
#import "SearchAddressVC.h"

#define RESPONSE_ALERT_TAG 1

typedef NS_ENUM(NSUInteger, RequestVCSectionType) {
    RequestVCSectionTypeClientInfo,
    RequestVCSectionTypeAddress,
    RequestVCSectionTypeComment,
    RequestVCSectionTypeAction,
    RequestVCSectionTypesCount
};

@interface RequestVC () <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SearchAddressVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UILabel *stairCaseLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property UIToolbar *numberToolbar;
@property UITextField *textField;
@property NSMutableDictionary *addressParameters;

@end

@implementation RequestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Toolbar for textField.
    self.numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    self.numberToolbar.items = [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(cancelNumberPad)],
                                nil];
    self.numberToolbar.tintColor = [UIColor whiteColor];
    self.numberToolbar.barTintColor = [UIColor grayColor];
    [self.numberToolbar sizeToFit];
    
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.phoneTextField.inputAccessoryView = self.numberToolbar;
    self.commentTextView.delegate = self;
    
    self.addressParameters = [NSMutableDictionary new];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == RequestVCSectionTypeClientInfo) {
        if (indexPath.row == 0) {
            self.textField = self.nameTextField;
        } else if (indexPath.row == 1) {
            self.textField = self.phoneTextField;
        }
    } else if (indexPath.section == RequestVCSectionTypeAddress) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            SearchAddressVC *destinationVC = [SearchAddressVC storyboardVC];
            destinationVC.delegate = self;
            [self.navigationController pushViewController:destinationVC animated:YES];
        }
    } else if (indexPath.section == RequestVCSectionTypeAction) {
        if (indexPath.row == 0) {
            [self sendOrderRequest];
        }
    }
}

- (void)searchAddressVC:(SearchAddressVC *)controller didChooseAddress:(NSDictionary *)address
{
    self.addressParameters = [address mutableCopy];
    self.streetLabel.text = self.addressParameters[@"street"];
    self.houseLabel.text = self.addressParameters[@"building"];
    self.stairCaseLabel.text = self.addressParameters[@"staircase"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelNumberPad
{
    [self.phoneTextField resignFirstResponder];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableViewCell *cell;
    if (SYSTEM_VERSION_IS_LESS_THAN(@"8.0")) {
        cell = (UITableViewCell *)[[textField superview] superview];
    } else {
        cell = (UITableViewCell *)[textField superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == RequestVCSectionTypeClientInfo) {
        [self.view becomeFirstResponder];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)sendOrderRequest
{
    NSNumber *addressID = self.addressParameters[@"addressID"];
    NSString *street = self.addressParameters[@"street"];
    NSString *city = self.addressParameters[@"city"];
    NSString *code = self.addressParameters[@"code"];
    NSString *building = self.addressParameters[@"building"];
    NSString *name = self.nameTextField.text;
    NSString *phone = self.phoneTextField.text;
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    if (![name length]) {
        errorAlert.message = @"Введите имя";
        [errorAlert show];
        return;
    }
    if (![phone length]) {
        errorAlert.message = @"Введите телефон";
        [errorAlert show];
        return;
    }
    if (![street length]) {
        errorAlert.message = @"Выберете адрес";
        [errorAlert show];
        return;
    }
    NSDictionary *parameters = @{@"addressID" : addressID, @"street" : street, @"city" : city, @"code" : code, @"building" : building, @"name" : name, @"phone" : phone};
    [[Server sharedServer]sendOrderRequestWithParameters:parameters success:^(id response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Ваш заказ принят!" delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
        alert.tag = RESPONSE_ALERT_TAG;
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"Error - %@", [error localizedDescription]);
    }];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == RESPONSE_ALERT_TAG) {
        if (buttonIndex == 0) {
            NSLog(@"OK");
        }
    }
}


- (void)clearInputFields
{
    self.nameTextField.text = @"";
    self.phoneTextField.text = @"";
    self.commentTextView.text = @"Комментарий";
    [self.addressParameters removeAllObjects];
    [self.tableView reloadData];
}
@end
