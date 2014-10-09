//
//  JSONStore+Helper.h
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//
#import "JSONStore.h"
#import "JSONStoreQueryPart.h"
#import <Foundation/Foundation.h>

typedef void (^FetchBusinessFromJSONStore) (void);
typedef void (^ProgressUpdateBlock)(CGFloat persentage);


@interface DataHelper :NSObject
@property (strong, nonatomic) JSONStoreCollection *summary;
@property (strong, nonatomic) JSONStoreCollection *business;
@property (strong, nonatomic) JSONStoreOpenOptions *option;

@property (nonatomic, copy) FetchBusinessFromJSONStore block;
@property (nonatomic, copy) ProgressUpdateBlock progressUpdateBlock;

+(DataHelper*)sharedDataHelper;
-(BOOL)isBusinessExisting:(NSString*)businessName;
-(void)createBusinessTableFrom:(NSDictionary *)responseJSON;
-(void)createSummaryTableFrom:(NSDictionary *)responseJSON;
-(void)fetchBusinessFromJSONStore:(NSString*)businessName withCompletion:(void(^)(NSArray *arry))completionBlock;
                                                                              


@end
