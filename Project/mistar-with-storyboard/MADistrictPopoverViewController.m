//
//  MADistrictPopoverViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 9/21/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MADistrictPopoverViewController.h"
#import "MAURLClickerView.h"

@interface MADistrictPopoverViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet MAURLClickerView *clicker;
@property (weak, nonatomic) IBOutlet UITextField *districtTextField;
@property (strong, nonatomic) NSArray *savedDistricts;

@end

@implementation MADistrictPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"savedDistricts"]) {
        self.savedDistricts = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDistricts"];
    } else {
        self.savedDistricts = [NSArray new];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource methods



@end
