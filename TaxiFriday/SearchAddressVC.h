//
//  SearchAddressVC.h
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import <UIKit/UIKit.h>

@class SearchAddressVC;

@protocol SearchAddressVCDelegate <NSObject>

- (void)searchAddressVC:(SearchAddressVC *)controller didChooseAddress:(NSDictionary *)address;

@end

@interface SearchAddressVC : UIViewController

@property id <SearchAddressVCDelegate> delegate;

@end
