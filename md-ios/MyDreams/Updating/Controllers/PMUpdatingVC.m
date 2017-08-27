//
//  PMUpdatingVC.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUpdatingVC.h"
#import "PMUpdatingLogic.h"

@interface PMUpdatingVC ()
@property (strong, nonatomic) PMUpdatingLogic *logic;
@end

@implementation PMUpdatingVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];

}

#pragma mark - private

-(IBAction)prepareForUnwindUpdating:(UIStoryboardSegue *)segue {}

@end
