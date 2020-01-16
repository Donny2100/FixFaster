//
//  ChatListViewController.h
//  FixItFaster
//
//  Created by iOS Master on 12/14/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListTableViewCell.h"
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface ChatListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *chatListTv;
@property (weak, nonatomic) IBOutlet UISwitch *chatSwitch;
@property (strong, nonatomic) FIRDatabaseReference *ref; //newly added
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *uploadInfo;// newly added

@end

NS_ASSUME_NONNULL_END
