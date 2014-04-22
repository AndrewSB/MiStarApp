//
//  MAGradeCell.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/24/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QBFlatButton.h>

@interface MAGradeCell : UITableViewCell

@property (nonatomic,strong) QBFlatButton  *userStateButton; //Use your button's Class there instead of UIButton

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end