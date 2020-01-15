//
//  ViewController.m
//  Fix It Faster
//
//  Created by T Y on 12/11/19.
//  Copyright © 2019 T Y. All rights reserved.
//

#import "ViewController.h"
#import "SignUpViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.emailView.layer.cornerRadius = self.emailView.frame.size.height / 2;
    self.pwdView.layer.cornerRadius = self.pwdView.frame.size.height / 2;
    self.loginBt.layer.cornerRadius = self.loginBt.frame.size.height / 2;
    self.registerBt.layer.cornerRadius = self.loginBt.frame.size.height / 2;
    
    [self shadowEffect:self.emailView];
    [self shadowEffect:self.pwdView];
}

- (void)shadowEffect:(UIView*)view {
    [view.layer setShadowColor: [UIColor grayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (IBAction)loginClicked:(id)sender {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC = [mainBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (IBAction)registerClicked:(id)sender {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController *signUpVC = [mainBoard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self.navigationController pushViewController:signUpVC animated:YES];
}


@end
