//
//  UploadViewController.h
//  FixItFaster
//
//  Created by iOS Master on 12/13/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNiceSpinner.h"
#import <MapKit/MapKit.h>
#import "MKDropdownMenu.h"
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface UploadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (strong, nonatomic) IBOutlet MKDropdownMenu *mainDropDown;
@property (strong, nonatomic) IBOutlet MKDropdownMenu *subDropDown;
@property (strong, nonatomic) IBOutlet UIButton *uploadBt;
@property (strong, nonatomic) IBOutlet UILabel *mainCategoryLb;
@property (strong, nonatomic) IBOutlet UILabel *subCategoryLb;
@property (strong, nonatomic) IBOutlet UIButton *cancelBt;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

NS_ASSUME_NONNULL_END
