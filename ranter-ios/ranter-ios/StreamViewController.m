//
//  StreamViewController.m
//  ranter-ios
//
//  Created by roadan on 6/22/14.
//  Copyright (c) 2014 Yehontan Yehudai. All rights reserved.
//

#import "StreamViewController.h"
#import "CouchbaseLite/CouchbaseLite.h"

@interface StreamViewController ()

@end

@implementation StreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSError* error;
        
        // Creating a manger object
        CBLManager * manager = [CBLManager sharedInstance];
        if (!manager) {
            NSLog(@"Cannot create Manager instance");
            exit(-1);
        }
        
        
        
        CBLDatabase* database = [manager
                    databaseNamed:@"ranter"
                    error: &error];
        if (!database) {
            NSLog(@"Cannot create or get Database ranter");
            exit(-1);
        }
        
        CBLView* streamView = [database viewNamed: @"stream"];
        [streamView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: @"rant"] &&
                doc[@"userName"] &&
                ![doc[@"userName"] isEqualToString: self.userName]) {
                emit(doc[@"date"],nil);
            }
        }) version: @"1"];
        
        CBLQuery* query = [[database viewNamed: @"stream"] createQuery];
        query.descending = YES;
        query.limit = 10;
        
        CBLQueryEnumerator* result = [query run: &error];
        
        for (CBLQueryRow* row in result) {
            NSString* docId = row.documentID;
        }
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

@end
