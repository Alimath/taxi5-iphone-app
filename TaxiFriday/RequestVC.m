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
#import "ScrollViewCustom.h"
#import "UIViewRounded.h"
#import "InfoVC.h"
#import "StatusBaseVC.h"

#define RESPONSE_ALERT_TAG 1

typedef NS_ENUM(NSUInteger, RequestVCSectionType) {
    RequestVCSectionTypeClientInfo,
    RequestVCSectionTypeAddress,
    RequestVCSectionTypeAction,
    RequestVCSectionTypesCount
};

@interface RequestVC () <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate, SearchAddressVCDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UIViewRounded *streetView;
@property (weak, nonatomic) IBOutlet UITextField *houseTextField;
@property (weak, nonatomic) IBOutlet UITextField *stairTextField;
@property (weak, nonatomic) IBOutlet UITextField *housingTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet ScrollViewCustom *scrollView;


@property UIToolbar *numberToolbar;
@property UITextField *activeTextField;
@property NSMutableDictionary *addressParameters;
@property Place *place;
@property MBProgressHUD *progress;
@property CGFloat keyboardHeight;

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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"])
    {
        _nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }
    self.phoneTextField.delegate = self;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phone"])
    {
        _phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    }
    self.phoneTextField.inputAccessoryView = self.numberToolbar;
//    self.houseTextField.inputAccessoryView = self.numberToolbar;
    self.stairTextField.inputAccessoryView = self.numberToolbar;
    self.housingTextField.inputAccessoryView = self.numberToolbar;
    
    self.commentTextField.delegate = self;
    self.commentTextField.placeholder = @"Комментарий";
    self.houseTextField.delegate = self;
    self.stairTextField.delegate = self;
    self.housingTextField.delegate = self;
    
    self.addressParameters = [NSMutableDictionary new];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchStreet)];
    tapGesture.numberOfTapsRequired = 1;
    [_streetView addGestureRecognizer:tapGesture];
    
//  //To make the border look very close to a UITextField
//  [_commentTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//  [_commentTextView.layer setBorderWidth:1.0];
    
//  //The rounded corner part, where you specify your view's corner radius:
//  _commentTextView.layer.cornerRadius = 5;
//  _commentTextView.clipsToBounds = YES;
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taxi5logo"]];
    self.navigationItem.titleView = titleView;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //регистрируемся на прием событий клавиатуры
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)setActiveHouseTextfield
{
//    [_houseTextField becomeFirstResponder];
}


- (void)searchAddressVC:(SearchAddressVC *)controller didChooseAddress:(NSDictionary *)address
{
    self.addressParameters = [address mutableCopy];
    self.streetLabel.text = self.addressParameters[@"street"];
    self.houseTextField.text = self.addressParameters[@"building"];
    self.stairTextField.text = self.addressParameters[@"staircase"];
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (void)cancelNumberPad
{
    [self.phoneTextField resignFirstResponder];
    [self.houseTextField resignFirstResponder];
    [self.stairTextField resignFirstResponder];
    [self.housingTextField resignFirstResponder];
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
        
        if (textField.text.length == 1 && [string isEqualToString:@""])
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
    _activeTextField = textField;
    if (textField.text.length == 0 && textField == _phoneTextField)
    {
        textField.text = @"+375";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _activeTextField = (UITextField*)textView;
    return YES;
}

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
    NSString *comment = self.commentTextField.text;
    NSString *phone = self.phoneTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
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
    if ([phone length] < 13)
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

    NSMutableDictionary *parameters = [@{@"addressID" : addressID, @"street" : street, @"city" : city, @"code" : code, @"building" : building, @"name" : name, @"phone" : phone, @"comment" : comment} mutableCopy];
    if (_housingTextField.text.length != 0)
    {
        [parameters setObject:_housingTextField.text forKey:@"section"];
    }
    
    if (_stairTextField.text.length != 0)
    {
        [parameters setObject:_stairTextField.text forKey:@"porch"];
    }
    
    _progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progress.labelText = @"Загрузка";
    [[Server sharedServer]sendOrderRequestWithParameters:parameters success:^(id response)
    {
        [_progress hide:YES];
//      OrderVC *controller = [OrderVC storyboardVC];
//      controller.idOrder = response[@"id"];
//      [self.navigationController pushViewController:controller animated:YES];
        StatusBaseVC *statusBaseVC = [StatusBaseVC storyboardVC];
        statusBaseVC.idOrder = response[@"id"];
        statusBaseVC.orderParameters = parameters;
        statusBaseVC.resendRequestBlock = ^ {
            [self.navigationController popToViewController:self animated:YES];
            [self sendOrderRequest];
        };
        [self.navigationController pushViewController:statusBaseVC animated:YES];
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
    self.commentTextField.text = @"Комментарий";
    [self.addressParameters removeAllObjects];
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

#pragma mark - IBActions

- (IBAction)orderButtonPushed
{
    [self sendOrderRequest];
}

- (IBAction)callButtonPushed
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"7500"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)infoButtonPushed
{
    InfoVC *infoVC = [InfoVC storyboardVC];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)searchStreet
{
    SearchPlaceVC *destinationVC = [SearchPlaceVC storyboardVC];
    destinationVC.delegate = self;
    [self.navigationController pushViewController:destinationVC animated:YES];
}

#pragma mark - uikeyboard methods

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    _keyboardHeight = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x,
                                     _scrollView.frame.origin.y,
                                     _scrollView.frame.size.width,
                                     SCREEN_BOUNDS.size.height - _keyboardHeight)];
    [self moveViewWithKeyboard];
    _scrollView.scrollEnabled = NO;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x,
                                     _scrollView.frame.origin.y,
                                     _scrollView.frame.size.width,
                                     SCREEN_BOUNDS.size.height/* + _keyboardHeight*/)];
    [self moveViewWithKeyboard];
    _scrollView.scrollEnabled = YES;
}

- (void)moveViewWithKeyboard
{
//    if (_scrollView.height == SCREEN_BOUNDS.size.height)
//    {
//        [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x,
//                                         _scrollView.frame.origin.y,
//                                         _scrollView.frame.size.width,
//                                         _scrollView.frame.size.height - _keyboardHeight)];
//    }
    
    if (_activeTextField)
    {
        [_scrollView scrollRectToVisible:_activeTextField.superview.frame animated:YES];
    }
    else
    {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

@end
