//
//  JSONStore+Helper.m
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//

#import "DataHelper.h"
#import "JSONStore.h"
#import "AppDelegate.h"
#import "JSONStoreQueryPart.h"
static DataHelper *sharedInstance = nil;

@interface DataHelper ()
@property (strong, nonatomic) JSONStoreCollection *summary;
@property (strong, nonatomic) JSONStoreCollection *business;
@property (strong, nonatomic) JSONStoreOpenOptions *option;
@property (strong, nonatomic) AppDelegate *delegate;

@end
@implementation DataHelper
+ (DataHelper *)sharedDataHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
#pragma mark - regular init method
- (id)init {
    self = [super init];
    if (self) {
        self.delegate = [UIApplication sharedApplication].delegate;
        self.summary = [[JSONStoreCollection alloc] initWithName:@"Summary"];
        [self.summary setSearchField:@"where" withType:JSONStore_String];
        [self.summary setSearchField:@"what" withType:JSONStore_String];
        [self.summary setSearchField:@"prov" withType:JSONStore_String];
        
        self.business = [[JSONStoreCollection alloc] initWithName:@"Business"];
        [self.business setSearchField:@"id" withType:JSONStore_String];
        [self.business setSearchField:@"name" withType:JSONStore_String];
        [self.business setSearchField:@"city" withType:JSONStore_String];
        [self.business setSearchField:@"street" withType:JSONStore_String];
        [self.business setSearchField:@"prov" withType:JSONStore_String];
        [self.business setSearchField:@"pcode" withType:JSONStore_String];
        [self.business setSearchField:@"latitude" withType:JSONStore_Number];
        [self.business setSearchField:@"longitude" withType:JSONStore_Number];
        [self.business setSearchField:@"distance" withType:JSONStore_Number];
        
        
        self.option = [JSONStoreOpenOptions new];
        [self.option setUsername:@"jsonStore"]; //Optional username, default 'jsonstore'
        [self.option setPassword:@"123"];
    }
    return self;
}


-(BOOL)isBusinessExisting:(NSString*)businessName {
    [[JSONStore sharedInstance] openCollections:@[self.summary] withOptions:self.option error:nil];
    
    JSONStoreCollection* summaryCollecion = [[JSONStore sharedInstance] getCollectionWithName:@"Summary"];
    NSError* error = nil;
    
    //Build the find options.
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options filterSearchField:@"what"];
    [options sortBySearchFieldDescending:@"what"];
    
    JSONStoreQueryPart* queryPart = [[JSONStoreQueryPart alloc] init];
    [queryPart searchField:@"what" equal:businessName];
    [options setOffset:@0];
    
    //Count using the query part built above.
    NSArray* findWithQueryPartResult = [summaryCollecion findWithQueryParts:@[queryPart] andOptions:options error:&error];
    return findWithQueryPartResult.count > 0 ? 1 : 0;
    return 0;
}
-(void)createSummaryTableFrom:(NSDictionary *)responseJSON {
    /* Add summary to local storage */
    NSError *err = nil;
    [[JSONStore sharedInstance] openCollections:@[self.summary] withOptions:self.option error:&err];
    
    /* Add data to the collection */
    NSArray *data = @[@{@"what" : [responseJSON[@"summary"][@"what"] lowercaseString],
                        @"where": responseJSON[@"summary"][@"where"],
                        @"prov": responseJSON[@"summary"][@"Prov"]},
                      ];
    
    NSNumber * added = [self.summary addData:data andMarkDirty:NO withOptions:nil error:&err];
    NSLog(@" %@ ",added ? @"SUCCESS TO CREATE SUMMARY ENTRY" : @"FAILURE TO CREATE");
}

-(void)createBusinessTableFrom:(NSDictionary *)responseJSON {
    NSArray *businessArr = responseJSON[@"listings"];
    
    [businessArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        /* Add summary to local storage */
        NSError *err = nil;
        [[JSONStore sharedInstance] openCollections:@[self.business] withOptions:self.option error:&err];
        
        /* Add data to the collection */
        NSArray *data = @[@{@"id":dict[@"id"],
                            @"name": dict[@"name"],
                            @"city": dict[@"address"][@"city"],
                            @"street": dict[@"address"][@"street"],
                            @"prov": dict[@"address"][@"prov"],
                            @"pcode": dict[@"address"][@"pcode"],
                            @"latitude": dict[@"geoCode"][@"latitude"],
                            @"longitude": dict[@"geoCode"][@"longitude"],}
                          ];
        
        NSNumber * added = [self.business addData:data andMarkDirty:NO withOptions:nil error:&err];
        NSLog(@" %@ ",added ? @"SUCCESS TO CREATE BUSINESS ENTRY" : @"FAILURE TO CREATE BUSINESS ENTRY");
    }];
    NSLog(@"OUTBLOCK");
    self.block();

}

-(void)fetchBusinessFromJSONStore:(NSString*)businessName withCompletion:(void(^)(NSArray *arry))completionBlock {
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[self.business] withOptions:self.option error:nil];
    
    JSONStoreCollection* businessCollecion = [[JSONStore sharedInstance] getCollectionWithName:@"Business"];
    NSError* error = nil;
    
    //Build the find options.
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options filterSearchField:@"json"];
    
    JSONStoreQueryPart* queryPart = [[JSONStoreQueryPart alloc] init];
    [queryPart searchField:@"name" equal:businessName];
    [options setOffset:@0];
    
    //Count using the query part built above.
    NSArray* findWithQueryPartResult = [businessCollecion findWithQueryParts:@[queryPart] andOptions:options error:&error];
    if (findWithQueryPartResult) {
        NSLog(@"INNERBLOCK");
        completionBlock(findWithQueryPartResult);
    }
}

@end
