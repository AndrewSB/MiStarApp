//
//  MACustonNavigationController.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MACustonNavigationController.h"

@implementation MACustonNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	if([[self.viewControllers lastObject] class] == [MAController class]){
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 1.00];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                               forView:self.view cache:NO];
        
		UIViewController *viewController = [super popViewControllerAnimated:NO];
        
		[UIView commitAnimations];
        NSLog(@"if");
		return viewController;
	} else {
        NSLog(@"else");
        [self setNavigationBarHidden:YES animated:YES];
		return [super popViewControllerAnimated:YES];
	}
}
@end
