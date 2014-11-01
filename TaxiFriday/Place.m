//
//  Place.m
//  TaxiFriday
//
//  Created by Valik Kuchinsky on 01.11.14.
//
//

#import "Place.h"

@implementation Place

+ (NSArray*)objectsWithArray:(NSArray*)source
{
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in source)
    {
        Place *newPlace = [[Place alloc] initWithDictionary:dict];
        [array addObject:newPlace];
    }
    return array;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    _street = dict[@"street"];
    _building = dict[@"building"];
    _name = dict[@"name"];
    _city = dict[@"city"];
    _addressID = [dict[@"id"] integerValue];
    _code = dict[@"code"];
    return self;
}

@end
