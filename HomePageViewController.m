//
//  HomePageViewController.m
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//
#include <mach/mach_time.h>

#import "WLClient.h"
#import "DataHelper.h"
#import "JSONStore.h"
#import "AppDelegate.h"
#import "JSONStoreQueryPart.h"
#import "HomePageViewController.h"
#import "BusinessListingViewController.h"
#import "BusinessLocationViewController.h"

static double ticksToNanoseconds = 0.0;

@interface HomePageViewController ()
@property(strong, nonatomic) BusinessLocationViewController *businessLocationViewController;
@property(strong, nonatomic) BusinessListingViewController *viewController;
@property(strong, nonatomic) AppDelegate *appDelegate;
@property(strong, nonatomic) NSArray *businessArr;
@property(strong, nonatomic) NSString *where;
@property(strong, nonatomic) NSString *what;
@property (nonatomic, assign) uint64_t startTime;
@end

@implementation HomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.where = @"Toronto";
    self.viewController = [[BusinessListingViewController alloc] initWithNibName:@"BusinessListingViewController" bundle:nil];
    [self.whatTxtField setDelegate:self];
    [DataHelper sharedDataHelper].block = ^ {
        NSLog(@"TNA8 = %d",[NSThread isMainThread]);
        [[DataHelper sharedDataHelper] fetchBusinessFromJSONStore:self.what withCompletion :^(NSArray *result) {
            self.businessArr = result;
            
            uint64_t endTime = mach_absolute_time();
            uint64_t elapsedTime = endTime - self.startTime;
            double elapsedTimeInNanoseconds = elapsedTime * ticksToNanoseconds;
            NSLog(@"DOWNLOAEDED TIME: %f [ms]", elapsedTimeInNanoseconds/1E6);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSLog(@"TNA9 = %d",[NSThread isMainThread]);
                [self.progressBar setProgress:1 animated:YES];
                self.progressBar.hidden = YES;
                [self.businessTableView reloadData];
            });
        }];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findBusiness:(id)sender {
    self.progressBar.hidden = NO;
    [self.progressBar setProgress:.2 animated:YES];

    self.startTime = mach_absolute_time();
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        mach_timebase_info_data_t timebase;
        mach_timebase_info(&timebase);
        ticksToNanoseconds = (double)timebase.numer / timebase.denom;
    });
    if (self.whatTxtField.text.length == 0)
        return;
    [self.whatTxtField resignFirstResponder];

    self.what = [[self.whatTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];

    if ([[DataHelper sharedDataHelper] isBusinessExisting:self.what]) {
        NSLog(@"%@ EXISTS ",self.whatTxtField.text);
        [DataHelper sharedDataHelper].block();
    }
    else {
        NSLog(@"%@ NOT EXISTS ",self.whatTxtField.text);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.what ofType:@"json"];
        
        if (filePath) {
            NSError* error = nil;
            NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
            NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
            id json = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile options:0 error:&error];
            
            if (!error) {
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    [[DataHelper sharedDataHelper] createSummaryTableFrom:json];
                    [[DataHelper sharedDataHelper] createBusinessTableFrom:json];
                });

            }
        }
    }
}

#pragma mark - UITableViewDataSource + UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businessArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"tableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    NSDictionary *dict = [self.businessArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ AT %@ %@",self.what,[dict valueForKeyPath:@"json.street"],[dict valueForKeyPath:@"json.city"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self getCoorBusinessAt:indexPath];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.whatTxtField resignFirstResponder];
    [self findBusiness:nil];
    return YES;
}
@end
