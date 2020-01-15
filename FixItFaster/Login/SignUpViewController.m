//
//  SignUpViewController.m
//  Fix It Faster
//
//  Created by T Y on 12/11/19.
//  Copyright © 2019 T Y. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)setupView {
    self.emailView.layer.cornerRadius = self.emailView.frame.size.height / 2;
    self.pwdView.layer.cornerRadius = self.pwdView.frame.size.height / 2;
    self.confirmPwdView.layer.cornerRadius = self.pwdView.frame.size.height / 2;

    self.registerBt.layer.cornerRadius = self.registerBt.frame.size.height / 2;
    self.backBt.layer.cornerRadius = self.backBt.frame.size.height / 2;
    
    [self shadowEffect:self.emailView];
    [self shadowEffect:self.pwdView];
    [self shadowEffect:self.confirmPwdView];
}

- (void)shadowEffect:(UIView*)view {
    [view.layer setShadowColor: [UIColor grayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
