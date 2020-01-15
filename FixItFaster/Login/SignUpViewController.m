//
//  SignUpViewController.m
//  Fix It Faster
//
//  Created by T Y on 12/11/19.
//  Copyright © 2019 T Y. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;

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
    self.emailTf.delegate = self;
//    self.confirmPwdTf.delegate = self;
    [self.pwdTf addTarget: self action:@selector(pwdDone:) forControlEvents:UIControlEventEditingDidEnd];
    
}

- (void)pwdDone: (UITextField *)textField{
    NSLog(@"Password validation");
    if ([textField.text length] < 6){
        UIAlertController * alert = [UIAlertController
                        alertControllerWithTitle:@"Password not strong enough"
                                         message:@"Please Enter More than 6 Letters"
                                  preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* yesButton = [UIAlertAction
                            actionWithTitle:@"Okay"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
            self.emailTf.text = @"";
                                    }];

        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        textField.text = @"";
    }
}

- (BOOL)passwordConfirm{
    if([self.pwdTf.text isEqualToString:self.confirmPwdTf.text]){
        return TRUE;
    }
    return FALSE;
}

- (void)refreshAllFields{
    self.emailTf.text = @"";
    self.pwdTf.text = @"";
    self.confirmPwdTf.text = @"";
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

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerBtnClicked:(id)sender {
    printf("Register button clicked");
    NSString *email = self.emailTf.text;
    NSString *password = self.pwdTf.text;
    NSString *confirmPwd = self.confirmPwdTf.text;
    
    if([email length] < 1 || [password length] < 1 && [confirmPwd length] < 1 || ![self passwordConfirm]){
        [self refreshAllFields];
        UIAlertController * alert = [UIAlertController
                        alertControllerWithTitle:@"Invalid Email or Password"
                                         message:@"Please Enter Valid Email and Password."
                                  preferredStyle:UIAlertControllerStyleAlert];



        UIAlertAction* yesButton = [UIAlertAction
                            actionWithTitle:@"Okay"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];

        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    
    
    }
    

    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                     NSLog(@"test output %@", error.localizedDescription);
                        if(error.localizedDescription == NULL){
                            UIAlertController * alert = [UIAlertController
                                            alertControllerWithTitle:@""
                                                             message:@"Registered Successfully."
                                                      preferredStyle:UIAlertControllerStyleAlert];

                            UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"Okay"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                self.emailTf.text = @"";
                                                        }];

                            [alert addAction:yesButton];
                            [self presentViewController:alert animated:YES completion:nil];
                            [self refreshAllFields];
                        }
                        else{
                            UIAlertController * alert = [UIAlertController
                                            alertControllerWithTitle:@"Existing Account"
                                                             message:@"Please Use Different Email Address."
                                                      preferredStyle:UIAlertControllerStyleAlert];

                            UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"Okay"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                [self refreshAllFields];
                                                        }];

                            [alert addAction:yesButton];
                            [self presentViewController:alert animated:YES completion:nil];
                            [self refreshAllFields];
                        }
        
                    
    }];
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
