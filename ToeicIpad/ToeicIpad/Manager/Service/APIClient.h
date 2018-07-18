//
//  APIClient.h
//  Test
//
//  Created by DungLM3 on 4/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APICompletedHandler) (NSDictionary *responseData, NSError *error);

@interface APIClient : NSObject

@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) APICompletedHandler completion;

- (void)callMethod:(NSString *)method withParams:(NSDictionary *)params handler:(APICompletedHandler)response;

+ (instancetype)sharedClient;

@end
