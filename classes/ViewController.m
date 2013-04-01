//
//  ViewController.m
//  RichLabel
//
//  Created by Dima Avvakumov on 27.03.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawFirstLabel];
}

- (void) drawFirstLabel {
    CGRect labelFrame = CGRectMake(100.0, 100.0, 400.0, 200.0);
    EMRichLabel *label = [[EMRichLabel alloc] initWithFrame: labelFrame];
    [label setFontWithName: @"Arial" andSize: 14.0];
    [label setLineHeight: 26.0];
    [label setText: @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi."];
    
    // set red first char
    EMRichLabelStyle *style = [[EMRichLabelStyle alloc] init];
    [style setRangeStart: 0];
    [style setRangeLength: 1];
    [style setColor: [UIColor redColor]];
    [style setFontSize: 20.0];
    [label addStyle: style];
    
    EMRichLabelStyle *style2 = [[EMRichLabelStyle alloc] init];
    [style2 setRangeStart: 28];
    [style2 setRangeLength: 28];
    [style2 setColor: [UIColor grayColor]];
    [style2 setFontName: @"Arial-BoldMT"];
    [label addStyle: style2];
    
    [self.view addSubview: label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
