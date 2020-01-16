//
//  UploadTableViewCell.h
//  FixItFaster
//
//  Created by iOS Master on 12/21/19.
//  Copyright © 2019 HR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeN;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

NS_ASSUME_NONNULL_END
