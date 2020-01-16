//
//  ChatListViewController.m
//  FixItFaster
//
//  Created by iOS Master on 12/14/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListTableViewCell.h"
#import "ChatViewController.h"
#import "ChatViewController.h"
#import "UploadTableViewCell.h"

@interface ChatListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    FIRDatabaseHandle _refHandle;
    FIRUser *user;
    
    NSString *placeN;
    NSString *timeStamp;
    NSDictionary<NSString*, NSString*> *msg;
    NSString *refKey;
}
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self configureDatabase];
}

- (void)initcell: (NSIndexPath *)indexPath{
    FIRDataSnapshot *snapshot = _uploadInfo[indexPath.row];
    NSDictionary<NSString *, NSString *> *per = snapshot.value;
    placeN = per[@"placeN"];
    timeStamp = per[@"timeStamp"];
    NSLog(@"inside chatlistview initcell");
    NSLog(@"placname is: %@", placeN);
    /* chat msg handling*/
    NSMutableArray *chatArray = per[@"chat"];
    msg = chatArray[chatArray.count-1];
    NSLog(@"chatmesssage is: %@", msg[@"msg"]);
}

- (void)setupView {
    self.chatListTv.tableFooterView = [[UIView alloc] init];
    [self.chatSwitch addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventValueChanged];
}

/* added newly*/
- (void)configureDatabase {
    _uploadInfo = [[NSMutableArray alloc] init];
    self.ref = [[FIRDatabase database] reference];
    user = [FIRAuth auth].currentUser;
 
  _refHandle = [[[self.ref child:@"upload"] child:user.uid] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
      NSLog(@"inside chatlistview database handler");
    [_uploadInfo addObject:snapshot];
    [_chatListTv insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_uploadInfo.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
  }];
}
/* end added */

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        NSLog(@"toogle on");
        [self.chatListTv reloadData];
    } else {
        NSLog(@"toogle off");
       [self.chatListTv reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _uploadInfo.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self initcell:indexPath];
    if(![self.chatSwitch isOn]){
        ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListTVC"];
        
//        FIRDataSnapshot *snapshot = _uploadInfo[indexPath.row];
//        NSDictionary<NSString *, NSString *> *per = snapshot.value;
//        NSString *placeN = per[@"placeN"];
//        NSString *timeStamp = per[@"timeStamp"];
//        cell.placeN.text = placeN;
//        cell.timeStamp.text = timeStamp;
//
//        /* chat msg handling*/
//        NSMutableArray *chatArray = per[@"chat"];
//        NSDictionary *msg = chatArray[chatArray.count-1];
//        NSLog(@"mutable array: %@", msg[@"msg"]);
//        cell.msg.text = msg[@"msg"];
//        /* end chat msg handling*/
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.placeN.text = placeN;
        cell.timeStamp.text = timeStamp;
        NSLog(@"timestamp");
        cell.msg.text = msg[@"msg"];
        NSLog(@"chatlistview text is working");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        UploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadTableViewCell"];
        if (cell == nil){
            //initialize the cell view from the xib file
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"uploadTableCell" owner:self options:nil];
            cell = (UploadTableViewCell *)[nibs objectAtIndex:0];
            
//            FIRDataSnapshot *snapshot = _uploadInfo[indexPath.row];
//            NSDictionary<NSString *, NSString *> *per = snapshot.value;
//            NSString *placeN = per[@"placeN"];
//            NSString *timeStamp = per[@"timeStamp"];
            cell.placeN.text = placeN;
            cell.timeStamp.text = timeStamp;
            
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

/* for getting refKey in firebase */
- (NSString*) getRefKey: (NSIndexPath*) indexPath{
    FIRDataSnapshot *snapshot = _uploadInfo[indexPath.row];
    NSDictionary<NSString *, NSString *> *per = snapshot.value;
    refKey = per[@"refKey"];
    return refKey;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatVC = [mainBoard instantiateViewControllerWithIdentifier:@"ChatVC"];
    chatVC.refKey = [self getRefKey:indexPath];
    [self.navigationController pushViewController:chatVC animated:YES];
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
