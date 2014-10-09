//
//  BusinessListingViewController.h
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessListingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *listingTableView;
@property (strong, nonatomic) NSString *businessName;

@end
