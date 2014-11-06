//
//  RequestVC.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "RequestVC.h"
#import "SearchAddressVC.h"
#import "SearchPlaceVC.h"
#import "UITextViewModified.h"
#import "OrderVC.h"

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
@property (weak, nonatomic) IBOutlet UITextField *houseTextField;
@property (weak, nonatomic) IBOutlet UITextField *stairTextField;
@property (weak, nonatomic) IBOutlet UITextViewModified *commentTextView;
@property UIToolbar *numberToolbar;
@property UITextField *textField;
@property NSMutableDictionary *addressParameters;
@property Place *place;
@property MBProgressHUD *progress;

@end

@implementation RequestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Toolbar for textField.
    self.numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    self.numberToolbar.items = [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Применить" style:UIBarButtonItemStyleDone target:self action:@selector(cancelNumberPad)],
                                nil];
    self.numberToolbar.tintColor = [UIColor whiteColor];
    self.numberToolbar.barTintColor = [UIColor grayColor];
    [self.numberToolbar sizeToFit];
    
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phone"])
    {
        _phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    }
    self.phoneTextField.inputAccessoryView = self.numberToolbar;
    self.houseTextField.inputAccessoryView = self.numberToolbar;
    self.stairTextField.inputAccessoryView = self.numberToolbar;
    
    self.commentTextView.delegate = self;
    self.commentTextView.placeholder = @"Комментарий";
    self.houseTextField.delegate = self;
    self.stairTextField.delegate = self;
    
    self.addressParameters = [NSMutableDictionary new];
    
    self.tableView.tableFooterView = [UIView new];
    
    //To make the border look very close to a UITextField
    [_commentTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_commentTextView.layer setBorderWidth:1.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    _commentTextView.layer.cornerRadius = 5;
    _commentTextView.clipsToBounds = YES;
}

#pragma mark - Table view delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    
//    return 50;
//
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
//    label.backgroundColor = [UIColor greenColor];
//    if (section == 0)
//    {
//        label.text = @"Информация о заказчике";
//    }
//    if (section == 1)
//    {
//        label.text = @"Где вы находитесь?";
//    }
//    return label;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == RequestVCSectionTypeClientInfo) {
        if (indexPath.row == 0) {
            self.textField = self.nameTextField;
        } else if (indexPath.row == 1) {
            self.textField = self.phoneTextField;
        }
    } else if (indexPath.section == RequestVCSectionTypeAddress) {
        if (indexPath.row == 0) {
            SearchPlaceVC *destinationVC = [SearchPlaceVC storyboardVC];
            destinationVC.delegate = self;
            [self.navigationController pushViewController:destinationVC animated:YES];
        }
    } else if (indexPath.section == RequestVCSectionTypeAction) {
        if (indexPath.row == 0){
            [self sendOrderRequest];
        }
        if (indexPath.row == 1){
            NSString *phoneNumber = [@"tel://" stringByAppendingString:@"7500"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
}

- (void)searchAddressVC:(SearchAddressVC *)controller didChooseAddress:(NSDictionary *)address
{
    self.addressParameters = [address mutableCopy];
    self.streetLabel.text = self.addressParameters[@"street"];
    self.houseTextField.text = self.addressParameters[@"building"];
    self.stairTextField.text = self.addressParameters[@"staircase"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelNumberPad
{
    [self.phoneTextField resignFirstResponder];
    [self.houseTextField resignFirstResponder];
    [self.stairTextField resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneTextField)
    {
        if (textField.text.length + string.length > 17)
        {
            return NO;
        }
        else
        {
            if (range.location == 4 && string.length)
            {
                textField.text = [textField.text stringByAppendingString:@"("];
            }
            if (range.location == 7 && string.length)
            {
                textField.text = [textField.text stringByAppendingString:@")"];
            }
            if ((range.location ==11 || range.location == 14) && string.length)
            {
                textField.text = [textField.text stringByAppendingString:@"-"];
            }
        }
        
        if (textField.text.length == 4 && [string isEqualToString:@""])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0 && textField == _phoneTextField)
    {
        textField.text = @"+375";
    }
    return YES;
}

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
    NSNumber *addressID = @(_place.addressID);
    NSString *street = _place.street;
    NSString *city = @"Минск"/*self.addressParameters[@"city"]*/;
    NSString *code = _place.code;
    NSString *building = _houseTextField.text;
    NSString *name = self.nameTextField.text;
    NSString *phone = self.phoneTextField.text;
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    if (![name length]) {
        errorAlert.message = @"Введите имя";
        [errorAlert show];
        return;
    }
    if (![phone length])
    {
        errorAlert.message = @"Введите телефон";
        [errorAlert show];
        return;
    }
    if ([phone length] < 17)
    {
        errorAlert.message = @"Телефон слишком короткий";
        [errorAlert show];
        return;
    }
    if (![street length]) {
        errorAlert.message = @"Выберете адрес";
        [errorAlert show];
        return;
    }
    if (![building length])
    {
        errorAlert.message = @"Введите номер дома";
        [errorAlert show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    
    NSDictionary *parameters = @{@"addressID" : addressID, @"street" : street, @"city" : city, @"code" : code, @"building" : building, @"name" : name, @"phone" : phone};
    
    _progress = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    _progress.labelText = @"Загрузка";
    [[Server sharedServer]sendOrderRequestWithParameters:parameters success:^(id response)
    {
        [_progress hide:YES];
        UINavigationController *navController = [UINavigationController storyboardVC];
        OrderVC *controller = [OrderVC storyboardVC];
        controller.idOrder = response[@"id"];
        navController.viewControllers = @[controller];
        [self presentViewController:navController animated:YES completion:nil];
    }
    failure:^(NSError *error)
    {
        [_progress hide:YES];
        ALERT(@"Извините, произошла ошибка! Попробуйте еще раз.");
//       NSLog(@"Error - %@", [error localizedDescription]);
    }];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == RESPONSE_ALERT_TAG){
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

#pragma mark - RequestVCDelegate

- (void)updateWithPlace:(Place *)place
{
    _streetLabel.text = place.street;
    if (place.building)
    {
        _houseTextField.text = place.building;
    }
    _place = place;
}

@end
