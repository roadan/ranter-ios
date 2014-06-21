//
//  UILoginVC.m
//  ranter-ios
//
//  Created by Yaniv Rodenski on 20/6/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "UILoginVC.h"
#import "UIFirstVC.h"

@interface UILoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneLoginButton;

- (IBAction)selectedDoneLoginButton;

@property (nonatomic, assign) BOOL isLoggedIn;

@end

@implementation UILoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isLoggedIn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectedDoneLoginButton {
    
    if (self.isLoggedIn) {


        UIFirstVC * viewController = [[UIFirstVC alloc] initWithNibName:@"UIFirstVC" bundle:[NSBundle mainBundle]];
        viewController.userName = self.userName.text;
        [self presentViewController:viewController animated:YES completion:nil];
        

        // animate = NO because we don't want to see the mainVC's view
    }
}


@end
