//
//  BusinessListingViewController.m
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//
#import "JSONStore.h"
#import "DataHelper.h"
#import "JSONStoreQueryPart.h"
#import "BusinessListingViewController.h"
#import "BusinessLocationViewController.h"


@interface BusinessListingViewController ()
@property(strong, nonatomic) NSArray *businessArr;
@property(strong, nonatomic) JSONStoreCollection *business;
@property(strong, nonatomic) BusinessLocationViewController *businessLocationViewController;
@end

@implementation BusinessListingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.businessArr = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.business = [[JSONStoreCollection alloc] initWithName:@"Business"];
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
    
    self.businessLocationViewController = [[BusinessLocationViewController alloc] initWithNibName:@"BusinessLocationViewController" bundle:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCoorBusinessAt:(NSIndexPath*)indexPath {
    dispatch_queue_t bgQueue = dispatch_queue_create("Background Queue",NULL);
    dispatch_async(bgQueue, ^{
        NSDictionary *dict = [self.businessArr objectAtIndex:indexPath.row];
        self.businessLocationViewController.lattitude = [[dict valueForKeyPath:@"json.latitude"] doubleValue];
        self.businessLocationViewController.longitude = [[dict valueForKeyPath:@"json.longitude"] doubleValue];
        self.businessLocationViewController.location = [NSString stringWithFormat:@"%@,%@",[dict valueForKeyPath:@"json.street"],[dict valueForKeyPath:@"json.prov"]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:self.businessLocationViewController animated:YES];
        });
    });
}



@end
