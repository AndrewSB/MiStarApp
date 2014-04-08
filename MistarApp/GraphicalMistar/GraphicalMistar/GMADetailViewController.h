//
//  GMADetailViewController.h
//  GraphicalMistar
//
//  Created by Andrew Breckenridge on 4/6/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMADetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
