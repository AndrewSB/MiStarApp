//
//  MADistrictPopoverViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 9/21/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MADistrictPopoverViewController.h"
#import "MAURLClickerView.h"

@interface MADistrictPopoverViewController ()

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
    
    self.clicker
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
