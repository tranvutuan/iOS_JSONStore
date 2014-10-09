//
//  HomePageViewController.h
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HomePageViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *businessTableView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UITextField *whatTxtField;
@end
