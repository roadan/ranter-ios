//
//  UIFirstVC.m
//  ranter-ios
//
//  Created by Yaniv Rodenski on 20/6/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "UIFirstVC.h"
#import "CouchbaseLite/CouchbaseLite.h"

@interface UIFirstVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UITextView *rantText;
@property (nonatomic) BOOL usingPopover;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)doRant;
- (IBAction)captureSnapshot;


@end

@implementation UIFirstVC

CBLDatabase * database;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSError* error;
        
        // Creating a manger object
        CBLManager * manager = [CBLManager sharedInstance];
        if (!manager) {
            NSLog(@"Cannot create Manager instance");
            exit(-1);
        }
        

        
        database = [manager
                    databaseNamed:@"ranter"
                    error: &error];
        if (!database) {
            NSLog(@"Cannot create or get Database ranter");
            exit(-1);
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)takeSimulatorSafePhotoWithPopoverFrame:(CGRect)popoverFrame
{
    
    // Prerequisites:
    //
    // Class requires two properties to be defined:

    
    // Load the imagePicker
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    // Set the sourceType to default to the PhotoLibrary and use the ivar to flag that
    // it will be presented in a popover
	
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.usingPopover = YES;
    
    // Check if the camera is available - if it is, reset the sourceType to the camera
    // and indicate that the popover won't be used.
	
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        self.usingPopover = NO;
    }
    
    // Set the sourceType of the imagePicker
	
    [self.imagePicker setSourceType:sourceType];
    
    // Set up the other imagePicker properties
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    
    // If the sourceType isn't the camera, then use the popover to present
    // the imagePicker, with the frame that's been passed into this method
    BOOL mightCrash_TrySnapAnyway = NO;
    if (!mightCrash_TrySnapAnyway || (sourceType != UIImagePickerControllerSourceTypeCamera)) {
        
        // Present a standard imagePicker as a modal view
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else  {
        
        //
        //
        //Next line crashes: AccessibilityBundles/CertUIFramework.axbundle> (not loaded)
    	self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
        //
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:popoverFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // This UIIMagePickerController delegate method is called by the image picker when
    // it's dismissed as a result of choosing an image from the Photo Library,
    // or taking an image with the camera
    
    UIImage *takenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = takenImage;
    [self.imageView reloadInputViews];
    // Do whatever is required with the image here
    // ...
    
    // Get rid of the imagePicker, either by dismissing the popover...
    if (self.usingPopover) {
        
        [self.popover dismissPopoverAnimated:YES];
        
    } else {
        
        // ...or dismissing the modal view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)doRant {
    
    NSDictionary* properties = @{@"type":       @"rant",
                                 @"userName":   self.userName,
                                 @"rantText":   self.rantText.text,
                                 };
    
    CBLDocument* document = [database createDocument];
    NSError* error;
    
    if (![document putProperties: properties error: &error]) {
        NSLog(@"Faild to save document");
    }
    
    NSLog(@"Document written to database ranter with Id = %@", document.documentID);
    
    CBLDocument *retrivedDoc = [database documentWithID:document.documentID];
    
    NSLog(@"retrievedDocument=%@", [retrivedDoc properties]);
    
    // adding a date property. In order to do so we need an NSMutableDictionary
    NSMutableDictionary* updatedProperties = [[retrivedDoc properties] mutableCopy];
    updatedProperties[@"date"] = [NSDate date];
    
    if (![document putProperties: updatedProperties error: &error]) {
        NSLog(@"Faild to save document");
    }
    
}

- (IBAction)captureSnapshot {
    [self takeSimulatorSafePhotoWithPopoverFrame:CGRectMake(0, 0, 320, 320)];
}

@end
