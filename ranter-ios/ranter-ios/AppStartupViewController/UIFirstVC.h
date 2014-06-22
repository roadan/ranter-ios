//
//  UIFirstVC.h
//  ranter-ios
//
//  Created by Yaniv Rodenski on 20/6/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFirstVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSString* userName;
- (IBAction)takePhoto:(id)sender;
@end
