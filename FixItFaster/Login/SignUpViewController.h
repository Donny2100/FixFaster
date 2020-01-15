//
//  SignUpViewController.h
//  Fix It Faster
//
//  Created by T Y on 12/11/19.
//  Copyright © 2019 T Y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *confirmPwdView;

@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTf;
@property (weak, nonatomic) IBOutlet UIButton *registerBt;

@property (weak, nonatomic) IBOutlet UIButton *backBt;

@end

NS_ASSUME_NONNULL_END
