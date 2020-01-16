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

@import Firebase;

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
    self.emailTf.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
        if([self.emailTf.text length]>8){

            NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];

            if ([emailTest evaluateWithObject:self.emailTf.text] == NO){

                UIAlertController * alert = [UIAlertController
                                alertControllerWithTitle:@"Enter the Valid Mail id"
                                                 message:@"Please Enter Valid Email Address."
                                          preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                    self.emailTf.text = @"";
                                            }];

                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
             UIAlertController * alert = [UIAlertController
                             alertControllerWithTitle:@"Enter the Valid Mail id"
                                              message:@"Please Enter Valid Email Address."
                                       preferredStyle:UIAlertControllerStyleAlert];



             UIAlertAction* yesButton = [UIAlertAction
                                 actionWithTitle:@"Okay"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             self.emailTf.text = @"";
                                         }];

             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];
        }
}

- (void)shadowEffect:(UIView*)view {
    [view.layer setShadowColor: [UIColor grayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (void)refreshAllFields{
    self.emailTf.text = @"";
    self.pwdTf.text = @"";
}

- (IBAction)loginClicked:(id)sender {
    
    if([self.emailTf.text length] < 1 || [self.pwdTf.text length] < 1  ){
        UIAlertController * alert = [UIAlertController
                        alertControllerWithTitle:@"Invalid Email or Password"
                                         message:@"Please Enter Valid Email Address and Password."
                                  preferredStyle:UIAlertControllerStyleAlert];



        UIAlertAction* yesButton = [UIAlertAction
                            actionWithTitle:@"Okay"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
            [self refreshAllFields];
                                    }];

        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else{
        self.loginBt.enabled = NO;
        [[FIRAuth auth] signInWithEmail:self.emailTf.text
                               password:self.pwdTf.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
            if(error.localizedDescription == NULL){  // login success
                UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainViewController *mainVC = [mainBoard instantiateViewControllerWithIdentifier:@"MainVC"];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
            else{
                UIAlertController * alert = [UIAlertController
                                alertControllerWithTitle:@""
                                                 message:@"Email and Password is not correct."
                                          preferredStyle:UIAlertControllerStyleAlert];



                UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Okay"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                    [self refreshAllFields];
                                            }];

                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
                self.loginBt.enabled = YES;
            }
          
        }];
    }
    

}

- (IBAction)registerClicked:(id)sender {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController *signUpVC = [mainBoard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self.navigationController pushViewController:signUpVC animated:YES];
}


@end
