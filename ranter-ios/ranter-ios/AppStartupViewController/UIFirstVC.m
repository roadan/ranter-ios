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
NSString * documentId;

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
    
    documentId = document.documentID;
    CBLDocument* retrivedDoc = [database documentWithID:document.documentID];
    
    NSLog(@"retrievedDocument=%@", [retrivedDoc properties]);
    
    // adding a date property. In order to do so we need an NSMutableDictionary
    NSMutableDictionary* updatedProperties = [[retrivedDoc properties] mutableCopy];
    updatedProperties[@"date"] = [NSDate date];
    
    if (![document putProperties: updatedProperties error: &error]) {
        NSLog(@"Faild to save document");
    }

//    // updating a ducument via the update method
//    CBLDocument* retrivedDoc = [database documentWithID: document.documentID];
//    if (![retrivedDoc update: ^BOOL(CBLUnsavedRevision *newRev) {
//        newRev[@"date"] = [NSDate date];
//        return YES;
//    } error: &error]) {
//         NSLog(@"Error updating the document");
//    }
    
//    // deleting a document
//    CBLDocument* retrivedDoc = [database documentWithID: document.documentID];
//    
//    [retrivedDoc deleteDocument: &error];
    
}

- (IBAction)captureSnapshot {
    [self takeSimulatorSafePhotoWithPopoverFrame:CGRectMake(0, 0, 320, 320)];
}

- (IBAction)takePhoto:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc]
                                    initWithTitle:@"Error"
                                    message:@"Device has no camera"
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CBLDocument* document = [database documentWithID:documentId];
    CBLUnsavedRevision* newRev = [document.currentRevision createRevision];
    NSData* imageData = UIImageJPEGRepresentation(chosenImage, 0.75);
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString* fileName = [NSString stringWithFormat:@"IMG_%@.jpg",[dateFormater stringFromDate:[NSDate date]]];

    
    [newRev setAttachmentNamed: fileName
               withContentType: @"image/jpeg"
                       content: imageData];
    // (You could also update newRev.properties while you're here)
    NSError* error;
    assert([newRev save: &error]);
    
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
