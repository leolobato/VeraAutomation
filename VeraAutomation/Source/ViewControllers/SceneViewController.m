//
//  SceneViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/27/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "SceneViewController.h"
#import "VeraScene.h"
#import "SceneCell.h"

@interface SceneViewController ()
@property (nonatomic, strong) NSArray *devices;
@end

@implementation SceneViewController
- (void)viewDidLoad
{
	self.deviceType = VeraDeviceTypeScene;
    [super viewDidLoad];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	SceneCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SceneCell" forIndexPath:indexPath];
	VeraScene *scene = nil;
	if (indexPath.row < [self.devices count])
	{
		scene = self.devices[indexPath.row];
	}
	
	cell.scene = scene;
	[cell setupCell];
	return cell;
}

@end
