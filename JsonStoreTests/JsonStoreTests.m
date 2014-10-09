//
//  JsonStoreTests.m
//  JsonStoreTests
//
//  Created by VuTuan Tran on 2014-10-08.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//
#import "DataHelper.h"
#import <XCTest/XCTest.h>

@interface JsonStoreTests : XCTestCase
@property (nonatomic) id json;
@property (strong, nonatomic) NSError *err;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSNumber *openSummaryCollection;
@property (strong, nonatomic) NSNumber *openBusinessCollection;

@end

@implementation JsonStoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [DataHelper sharedDataHelper];
    
    self.filePath = [[NSBundle mainBundle] pathForResource:@"metro" ofType:@"json"];
    self.err = nil;
    
    if (self.filePath) {
        NSURL *localFileURL = [NSURL fileURLWithPath:self.filePath];
        NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
        self.json = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile options:0 error:nil];
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.


    [super tearDown];
}

- (void)testDataHelperSington
{
    XCTAssertNotNil([DataHelper sharedDataHelper], @"DataHelperSington exists");
}

- (void)testCollectionSummary
{
    NSError *err = nil;
    [[JSONStore sharedInstance] openCollections:@[[DataHelper sharedDataHelper].summary]
                                    withOptions:[DataHelper sharedDataHelper].option
                                          error:&err
     ];
    
    /* Add data to the collection */
    NSArray *data = @[@{@"what" : [self.json[@"summary"][@"what"] lowercaseString],
                        @"where": self.json[@"summary"][@"where"],
                        @"prov": self.json[@"summary"][@"Prov"]},
                      ];
    self.openSummaryCollection = [[DataHelper sharedDataHelper].summary addData:data andMarkDirty:NO withOptions:nil error:&err];
    XCTAssertNotNil(self.openSummaryCollection);
    XCTAssertTrue(data.count == 1);

}
- (void)testCollectionBusiness
{
    NSArray *businessArr = self.json[@"listings"];
    
    [businessArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        /* Add summary to local storage */
        NSError *err = nil;
        [[JSONStore sharedInstance] openCollections:@[[DataHelper sharedDataHelper].business]
                                            withOptions:[DataHelper sharedDataHelper].option
                                                    error:&err
         ];
        
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
        
       self.openBusinessCollection = [[DataHelper sharedDataHelper].business addData:data andMarkDirty:NO withOptions:nil error:&err];
        XCTAssertNotNil(self.openBusinessCollection);
        XCTAssertTrue(data.count == 1);
    
    }];
}
-(void)testFetchBusiness {
    [[JSONStore sharedInstance] openCollections:@[[DataHelper sharedDataHelper].business] withOptions:[DataHelper sharedDataHelper].option error:nil];
    
    JSONStoreCollection* businessCollecion = [[JSONStore sharedInstance] getCollectionWithName:@"Business"];
    NSError* error = nil;
    
    //Build the find options.
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options filterSearchField:@"json"];
    
    JSONStoreQueryPart* queryPart = [[JSONStoreQueryPart alloc] init];
    [queryPart searchField:@"name" equal:@"metro"];
    [options setOffset:@0];
    
    //Count using the query part built above.
    NSArray* findWithQueryPartResult = [businessCollecion findWithQueryParts:@[queryPart] andOptions:options error:&error];
    XCTAssertTrue(findWithQueryPartResult.count != 1);

}

@end
