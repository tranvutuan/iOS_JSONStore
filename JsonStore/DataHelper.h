//
//  JSONStore+Helper.h
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FetchBusinessFromJSONStore) (void);

@interface DataHelper :NSObject

@property (nonatomic, copy) FetchBusinessFromJSONStore block;
+(DataHelper*)sharedDataHelper;
-(BOOL)isBusinessExisting:(NSString*)businessName;
-(void)createBusinessTableFrom:(NSDictionary *)responseJSON;
-(void)createSummaryTableFrom:(NSDictionary *)responseJSON;
-(void)fetchBusinessFromJSONStore:(NSString*)businessName withCompletion:(void(^)(NSArray *arry))completionBlock;
                                                                              


@end
