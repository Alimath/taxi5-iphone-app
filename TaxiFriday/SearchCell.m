//
//  SearchCell.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/26/14.
//
//

#import "SearchCell.h"

@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor grayColor];
    

}

+ (CGFloat)height
{
    return 50.0;
}

@end
