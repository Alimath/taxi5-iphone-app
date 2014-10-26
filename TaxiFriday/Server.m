//
//  Server.m
//  TaxiFriday
//
//  Created by Stasevich Yauhen on 10/25/14.
//
//

#import "Server.h"

NSString *const ServerAddress = @"http://taxi5.by";

@implementation Server

+ (Server *)sharedServer
{
    static Server *server;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        server = [[Server alloc] initWithBaseURL:[NSURL URLWithString:ServerAddress]];
        server.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return server;
}

#pragma mark - Get Addresses

- (void)getAddressesWithText:(NSString *)text
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSError *))failure
{
    //NSString *urlRequest = [NSString stringWithFormat:@"/api/locator/search?q=%@", text];
    NSDictionary *parameters = @{@"q" : text};
    
    [self GET:@"/api/locator/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
        success(JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
