//
//  OrderRejectedVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 14.12.14.
//
//

#import "OrderRejectedVC.h"

@interface OrderRejectedVC ()
@property (nonatomic, weak) IBOutlet UILabel* reasonLabel;
@property (nonatomic, weak) IBOutlet UILabel* reasonTitleLabel;
@end

@implementation OrderRejectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(closeController) withObject:nil afterDelay:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setReasonMessage:(NSString *)reasonMessage {
    _reasonMessage = reasonMessage;
    [self updateInterface];
}

- (void) updateInterface {
    if(_reasonMessage){
        self.reasonLabel.hidden = NO;
        self.reasonTitleLabel.hidden = NO;
        self.reasonLabel.text = _reasonMessage;
    } else {
        self.reasonLabel.hidden = YES;
        self.reasonTitleLabel.hidden = YES;
    }
}

- (void) closeController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButton:(id)sender
{
    [self closeController];
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
