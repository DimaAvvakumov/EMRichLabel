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
    NSString *text = @"<b>С целью снижения стоимости</b> и <a>соблюдения</a> открытости ГСК «ВИС» осуществляет закупку оборудования и материалов на  конкурсной основе при <b>непосредственном</b>  участии представителей заказчика, используя собственную и <a>внешние тендерные</a> площадки.";
    
    CGRect labelFrame = CGRectMake(100.0, 100.0, 400.0, 200.0);
    EMRichLabel *label = [[EMRichLabel alloc] initWithFrame: labelFrame];
    [label setStyleByName: @"default"];
//    [label setFontWithName: @"Arial" andSize: 14.0];
//    [label setLineHeight: 26.0];
    [label setText: text];
    
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
