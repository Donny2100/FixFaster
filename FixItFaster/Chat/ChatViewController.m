//
//  ChatViewController.m
//  FixItFaster
//
//  Created by iOS Master on 12/14/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import "ChatViewController.h"
#import "IQKeyboardManager.h"
#import "NSBubbleData.h" // addedy by me

@interface ChatViewController () <UIBubbleTableViewDataSource>
{
    NSDictionary<NSString*, NSString*> *chatDic;  // snapshot array from firebase
    NSMutableArray *chatArray;
    NSMutableArray *bubbleData; // for bubble table view
    /* addedy by me*/
    FIRUser *user;
    FIRDatabaseHandle _refHandle;
    int index;
    
}

@end

@implementation ChatViewController

- (void)configureDatabase{
    index = 0;
    chatArray = [[NSMutableArray alloc] init];
    _ref = [[FIRDatabase database] reference];
    user = [FIRAuth auth].currentUser;
    NSLog(@"inside configure database");
    /* for displaying upload image or view */
    [[[[_ref child:@"upload"] child:user.uid] child: _refKey] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
      NSLog(@"reading onetime snapshot working");
      chatDic = snapshot.value;
      NSString *mUrl = chatDic[@"mURL"];
      NSLog(@"Image Url is %@", mUrl);
      NSBubbleData *imageOrVideo = [NSBubbleData dataWithText: mUrl date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeMine];
        imageOrVideo.avatar = nil;
      
      _chatTv.showAvatars = NO;
      bubbleData = [[NSMutableArray alloc]initWithObjects:imageOrVideo, nil];
      
      [_chatTv reloadData];
      // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
      NSLog(@"reading onetime snapshot%@", error.localizedDescription);
    }];
    /* end displaying upload image or video */
    
    _refHandle = [[[[[self.ref child:@"upload"] child:user.uid] child:_refKey] child:@"chat"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
//      [chatArray addObject:snapshot];
        
        NSDictionary<NSString*, NSString*> *per = snapshot.value;
        NSString *chatter = per[@"name"];
        NSString *msg = per[@"msg"];
        NSBubbleData *message;
        if([chatter isEqualToString:@"me"]){
            message = [NSBubbleData dataWithText: msg date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeMine];
            
        }else{
            message = [NSBubbleData dataWithText: msg date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
        }
        index += 1;
        message.avatar = nil;
        [bubbleData addObject:message];
        [_chatTv reloadData];
//      [_chatTv insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:chatArray.count inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  [self initValue]; commented in by me
    [self configureDatabase];
    
    
    /* end adding*/
    
    [self setupView];
  //    // added by me
}

- (void)viewWillAppear:(BOOL)animated {
    //[[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)initValue {
// cometted by me
//    chatArr = [[NSMutableArray alloc] init];
//
//    NSString *msg = self.msgTf.text;
//    NSDate *curDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//
//    NSString *curDateStr = [dateFormatter stringFromDate:curDate];
//
//    for(int i = 0; i < 10; i++) {
//        NSMutableDictionary *msgDict = [[NSMutableDictionary alloc] init];
//        [msgDict setObject:@"This is test message" forKey:@"Message"];
//        [msgDict setObject:curDateStr forKey:@"AddDate"];
//        [chatArr addObject:msgDict];
//    }
// commentted in by me
    
    [self.chatTv reloadData];
    [self.chatTv scrollBubbleViewToBottomAnimated:YES];
}

- (void)setupView {
    self.sendBt.layer.cornerRadius = self.sendBt.frame.size.width / 2;
    [self shadowEffect:self.msgView];
}

- (void)shadowEffect:(UIView*)view {
    [view.layer setShadowColor: [UIColor grayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    return bubbleData.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    return [bubbleData objectAtIndex:row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendBtnClicked:(id)sender {
    NSLog(@"Message send button was clicked");
    FIRDatabaseReference *chatref = [[[[[_ref child:@"upload"] child:user.uid] child:_refKey] child:@"chat"] child:[[NSNumber numberWithInt:index] stringValue]];
//    _refKey = [chatref key];
//    [[chatref child:@"name"] setValue:@"me"];
//    [[chatref child:@"msg"] setValue:self.msgTf.text];
    NSDictionary *newm = @{@"name":@"me", @"msg":self.msgTf.text};
    [chatref setValue:newm];
    NSLog(@"end send button clicked");
    self.msgTf.text = @"";
}
@end
