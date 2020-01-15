//
//  ChatViewController.h
//  FixItFaster
//
//  Created by iOS Master on 12/14/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBubbleTableView *chatTv;
@property (strong, nonatomic) IBOutlet UITextField *msgTf;
@property (strong, nonatomic) IBOutlet UIButton *sendBt;
@property (strong, nonatomic) IBOutlet UIView *msgView;

@end

NS_ASSUME_NONNULL_END
