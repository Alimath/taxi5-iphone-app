//
//  CarNotFoundVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 26.11.14.
//
//

#import "CarNotFoundVC.h"
#import "StatusBaseVC.h"

@interface CarNotFoundVC ()

@end

@implementation CarNotFoundVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender
{
    [_statusBaseVC cancelButton];
}

- (IBAction)callButton:(id)sender
{
    [_statusBaseVC callButton];
}

- (IBAction)researchCar:(id)sender
{
    [_statusBaseVC callTaxi];
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
