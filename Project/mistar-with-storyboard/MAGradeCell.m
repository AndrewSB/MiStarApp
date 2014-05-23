//
//  MAGradeCell.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/24/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAGradeCell.h"

@implementation MAGradeCell

- (id)initWithReuseID:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)prepareForReuse
{
    
    [self.userStateButton removeFromSuperview];
    self.userStateButton = nil;
    self.textLabel.text = nil;
    self.imageView.image = nil;
    [super prepareForReuse];
}

/*
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated
 {
 [super setSelected:selected animated:animated];
 
 // Configure the view for the selected state
 }*/

@end
