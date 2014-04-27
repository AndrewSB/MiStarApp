//
//  MANavController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MANavController.h"

@interface MANavController () 

@end

@implementation MANavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHidden:YES animated:YES];
    
    MAViewController *vc = [[MAViewController alloc] init];
    [self pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
