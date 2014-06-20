//
//  ViewController.m
//  ranter-ios
//
//  Created by Yehonatan Yehudai on 20/6/14.
//  Copyright (c) 2014 Yehontan Yehudai. All rights reserved.
//

#import "ViewController.h"
#import "UILoginVCViewController.h"
#import "AppStartupViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneLoginButton;

- (IBAction)selectedDoneLoginButton;

@property (nonatomic, assign) BOOL isLoggedIn;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if(!self.isLoggedIn)
//    {
//        UILoginVCViewController * login = [[UILoginVCViewController alloc] init];
//        [self presentViewController:login animated:YES completion:^{}];
//    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)selectedDoneLoginButton {
    
    if (true) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        AppStartupViewController *startupVC = [storyboard instantiateViewControllerWithIdentifier:@"AppStartupViewController"];

        [self presentViewController:startupVC animated:NO completion:nil];
        // animate = NO because we don't want to see the mainVC's view
    }
}

@end
