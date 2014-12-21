//
//  PayedOrderVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 14.12.14.
//
//

#import "PayedOrderVC.h"
#import "StatusBaseVC.h"
@interface PayedOrderVC ()
@property (nonatomic, weak) IBOutlet UILabel* amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation PayedOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateAmount];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.name;
    self.numberLabel.text = self.number;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAmount:(NSString *)amount {
    _amount = amount;
    [self updateAmount];
}

- (void) updateAmount {
    if(_amount){
        self.amountLabel.text = [NSString stringWithFormat:@"%@ руб.",_amount];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelButton:(id)sender
{
    [self.statusVC cancelButton];
}

@end
