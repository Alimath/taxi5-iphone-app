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
    NSDictionary *parameters = @{@"q" : text};
    
    [self GET:@"/api/locator/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
        success(JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)sendOrderRequestWithParameters:(NSDictionary *)parameters
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSError *))failure
{
    NSDictionary *location = @{@"id" : parameters[@"addressID"], @"street" : parameters[@"street"], @"city" : parameters[@"city"], @"code" : parameters[@"code"], @"type" : @"address", @"building" : parameters[@"building"]};
    NSArray *routeArray = @[@{@"name" : parameters[@"street"], @"type" : @"address", @"location" : location}, @{@"location" : @{}}];
    NSDictionary *clientDictionary = @{@"phone" : parameters[@"phone"], @"name" : parameters[@"name"]};
    NSDictionary *requestParameters = @{@"route" : routeArray, @"client" : clientDictionary, @"owner" : @"client"};
    
    [self POST:@"/api/order" parameters:requestParameters success:^(AFHTTPRequestOperation *operation, NSDictionary *JSON) {
        success(JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
