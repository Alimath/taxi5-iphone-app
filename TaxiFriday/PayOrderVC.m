//
//  PayOrderVC.m
//  TaxiFriday
//
//  Created by Sviryd Igor on 12/15/14.
//
//

#import "PayOrderVC.h"
#import "StatusBaseVC.h"

@interface PayOrderVC ()
@property (nonatomic, weak) IBOutlet UILabel* paymentStatus;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation PayOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateStatus];
    
    self.nameLabel.text = self.name;
    self.numberLabel.text = self.number;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateStatus {
    if(!self.isPayed){
        self.paymentStatus.text = @"Не оплачен";
    } else {
        self.paymentStatus.text = @"Ожидает оплаты";
    }
}

- (IBAction)cancelButton:(id)sender
{
    [self.statusVC cancelButton];
}

@end
