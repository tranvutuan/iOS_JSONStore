//
//  ViewController.m
//  JsonStore
//
//  Created by VuTuan Tran on 2014-10-08.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//

#import "ViewController.h"
#import "JSONStore.h"
#import "JSONStoreQueryPart.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[DataHelper sharedDataHelper ] isBusinessExisting:@"metro"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createCollection {
    // Create the collections object that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    // Optional options object.
    JSONStoreOpenOptions* options = [JSONStoreOpenOptions new];
    
    
    [options setUsername:@"localStorage"]; //Optional username, default 'jsonstore'
    [options setPassword:@"123"]; //Optional password, default no password
    
    //
    //    // This object will point to an error if one occurs.
    //    NSError* error = nil;
    //
    //    // Open the collections.
    //    [[JSONStore sharedInstance] openCollections:@[people] withOptions:options error:&error];
    //
    //    // Add data to the collection
    //    NSArray* data = @[ @{@"name" : @"N", @"age": @1},
    //                       @{@"name" : @"M", @"age": @2},
    //                       @{@"name" : @"L", @"age": @3},
    //                       @{@"name" : @"K", @"age": @4},
    //                       @{@"name" : @"I", @"age": @5},
    //                       @{@"name" : @"H", @"age": @6},
    //                       @{@"name" : @"G", @"age": @7},
    //                       @{@"name" : @"F", @"age": @8},
    //                       @{@"name" : @"E", @"age": @9},
    //                       @{@"name" : @"D", @"age": @10},
    //                       @{@"name" : @"C", @"age": @11},
    //                       @{@"name" : @"B", @"age": @12},
    //                       @{@"name" : @"A", @"age": @13},
    //                       ];
    //    [[people addData:data andMarkDirty:YES withOptions:nil error:&error] intValue];
}
-(void)searchCollection {
    // Get the accessor to an already initialized collection.
    NSLog(@"searchCollection");
    
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    JSONStoreOpenOptions* option = [JSONStoreOpenOptions new];
    option.username = @"localStorage";
    option.password = @"123";
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:option error:nil];
    
    JSONStoreCollection* peopleCollection = [[JSONStore sharedInstance] getCollectionWithName:@"people"];
    
    // This object will point to an error if one occurs.
    NSError* error = nil;
    
    // Add additional find options (optional).
    JSONStoreQueryOptions* options = [JSONStoreQueryOptions new];
    [options filterSearchField:@"json"];
    [options sortBySearchFieldDescending:@"age"];
    
    
    // Find all documents that match the query part.
    JSONStoreQueryPart* queryPart = [[JSONStoreQueryPart alloc] init];
    [queryPart searchField:@"age" lessOrEqualThan:@6];
    
    NSArray* results = [peopleCollection findWithQueryParts:@[queryPart]
                                                 andOptions:options
                                                      error:&error];
    
    for (NSDictionary* result in results) {
        NSString* name = [result valueForKeyPath:@"json.name"];
        int age = [[result valueForKeyPath:@"json.age"] intValue];
        NSLog(@"Name: %@, Age: %d", name, age);
    }
}

@end
