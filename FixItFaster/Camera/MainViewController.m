//
//  MainViewController.m
//  Fix It Faster
//
//  Created by T Y on 12/11/19.
//  Copyright © 2019 T Y. All rights reserved.
//

#import "MainViewController.h"
#import "ImageViewController.h"
#import "VideoViewController.h"
#import "UploadViewController.h"
#import "ChatListViewController.h"

@interface MainViewController () {
    int uploadType;
    UIImage *uploadImage;
    NSURL *uploadVideoUrl;
}
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *chatButton;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIImageView *uploadIv;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // ----- initialize camera -------- //
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh position:LLCameraPositionRear videoEnabled:YES];
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.camera.fixOrientationAfterCapture = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        NSLog(@"Device changed.");
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(screenRect.size.width / 2 - 35.0f, screenRect.size.height - 15.0f - 70.0f, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.snapButton addGestureRecognizer:longPress];
    
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(screenRect.size.width / 2 - 18.0f, 5.0f, 16.0f + 20.0f, 24.0f + 20.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash.png"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {
        // button to toggle camera positions
        self.switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.switchButton.frame = CGRectMake(screenRect.size.width - 49.0f - 5.0f, 5.0f, 29.0f + 20.0f, 22.0f + 20.0f);
        self.switchButton.tintColor = [UIColor whiteColor];
        [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
        self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.switchButton];
    }
    
    self.chatButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.chatButton.frame = CGRectMake(12.0f, screenRect.size.height - 67.0f, 60.0f, 60.0f);
    self.chatButton.tintColor = [UIColor whiteColor];
    [self.chatButton setImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
    self.chatButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.chatButton addTarget:self action:@selector(chatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatButton];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.uploadButton.frame = CGRectMake(screenRect.size.width - 72.0f, screenRect.size.height - 67.0f - 64, 60.0f, 60.0f);
    self.uploadButton.tintColor = [UIColor whiteColor];
    [self.uploadButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    self.uploadButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.uploadButton addTarget:self action:@selector(uploadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.uploadButton];
    
    self.uploadIv = [[UIImageView alloc] init];
    self.uploadIv.frame = CGRectMake(screenRect.size.width - 72.0f, screenRect.size.height - 67.0f, 60.0f, 60.0f);
    [self.uploadIv setContentMode:UIViewContentModeScaleAspectFill];
    self.uploadIv.clipsToBounds = YES;
    self.uploadIv.layer.cornerRadius = 10;
    [self.uploadIv setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewTapped:)];
    [self.uploadIv addGestureRecognizer:tapGesture];
    [self.view addSubview:self.uploadIv];
    
    [self.uploadButton setHidden:YES];
    [self.uploadIv setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.camera start];
}

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)chatButtonPressed:(UIButton *)button {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatListViewController *chatListVC = [mainBoard instantiateViewControllerWithIdentifier:@"ChatListVC"];
    [self.navigationController pushViewController:chatListVC animated:YES];
}

- (void)uploadButtonPressed:(UIButton *)button {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UploadViewController *uploadVC = [mainBoard instantiateViewControllerWithIdentifier:@"UploadVC"];
    [self.navigationController pushViewController:uploadVC animated:YES];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)flashButtonPressed:(UIButton *)button {
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            uploadType = 0;
            uploadImage = image;
            [self showPreview];
            [self.camera start];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan) {
        if(!self.camera.isRecording) {
            self.flashButton.hidden = YES;
            self.switchButton.hidden = YES;
            
            self.snapButton.layer.borderColor = [UIColor redColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            
            // start recording
            NSURL *outputURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test1"] URLByAppendingPathExtension:@"mov"];
            [self.camera startRecordingWithOutputUrl:outputURL];
        }
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.flashButton.hidden = NO;
        self.switchButton.hidden = NO;
        
        self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        NSLog(@"video capturing ended");
        
        [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
            if(!error) {
                uploadType = 1;
                uploadVideoUrl = outputFileUrl;
                [self showPreview];
                [self.camera start];
            }
        }];
    }
}

- (void)previewTapped:(UIGestureRecognizer *)gesture {
    if(uploadType == 0) {
        ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:uploadImage];
                 [self.navigationController pushViewController:imageVC animated:YES];
    } else {
        VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:uploadVideoUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showPreview {
    [self.uploadIv setHidden:NO];
    [self.uploadButton setHidden:NO];
    
    if(uploadType == 0) {
        [self.uploadIv setImage:uploadImage];
    } else {
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:uploadVideoUrl options:nil];
        AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
        UIImage* image = [UIImage imageWithCGImage:cgImage];
        
        [self.uploadIv setImage:image];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
