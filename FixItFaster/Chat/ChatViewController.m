//
//  ChatViewController.m
//  FixItFaster
//
//  Created by iOS Master on 12/14/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import "ChatViewController.h"
#import "IQKeyboardManager.h"

@interface ChatViewController () <UIBubbleTableViewDataSource>
{
    NSMutableArray *chatArr;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    //[[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)initValue {
    chatArr = [[NSMutableArray alloc] init];
    
    NSString *msg = self.msgTf.text;
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSString *curDateStr = [dateFormatter stringFromDate:curDate];
    
    for(int i = 0; i < 10; i++) {
        NSMutableDictionary *msgDict = [[NSMutableDictionary alloc] init];
        [msgDict setObject:@"This is test message" forKey:@"Message"];
        [msgDict setObject:curDateStr forKey:@"AddDate"];
        [chatArr addObject:msgDict];
    }
    
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
    return chatArr.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    NSDictionary *dict = [chatArr objectAtIndex:row];
    NSString *contentStr = [dict objectForKey:@"Message"];
    NSString *dateStr = [dict objectForKey:@"AddDate"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *chatDate = [dateFormatter dateFromString:dateStr];
    
    NSBubbleData *sayBubble;
    sayBubble = [NSBubbleData dataWithText:contentStr date:chatDate type:BubbleTypeMine];
 
    [sayBubble.view setTag:row];
    return sayBubble;
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
