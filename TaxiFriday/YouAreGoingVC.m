//
//  YouAreGoingVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 14.12.14.
//
//

#import "YouAreGoingVC.h"
#import "StatusBaseVC.h"

@interface YouAreGoingVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation YouAreGoingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.name;
    self.numberLabel.text = self.number;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender
{
    [self.statusVC cancelButton];
}

@end
