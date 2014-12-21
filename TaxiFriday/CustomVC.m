//
//  CustomVC.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 22.11.14.
//
//

#import "CustomVC.h"

@interface CustomVC ()

@end

@implementation CustomVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //change width
    NSLayoutConstraint *constraint = _containerView.constraints[1];
    constraint.constant = SCREEN_BOUNDS.size.width;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
