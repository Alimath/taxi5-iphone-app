//
//  InfoVCViewController.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 23.11.14.
//
//

#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)callButton:(id)sender
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"7500"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
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
