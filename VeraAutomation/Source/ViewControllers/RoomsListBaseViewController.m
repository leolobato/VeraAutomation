//
//  RoomsListBaseViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/27/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "RoomsListBaseViewController.h"
#import "RoomBaseViewController.h"
#import "VeraRoom.h"
#import "VeraDevice.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"

@interface RoomsListBaseViewController () <UISplitViewControllerDelegate>
@property (nonatomic, strong) NSArray *rooms;
@end

@implementation RoomsListBaseViewController

- (void) setupRooms
{
	NSMutableArray *rooms = [NSMutableArray array];
	for (VeraRoom *room in [VeraAutomationAppDelegate appDelegate].api.unitInfo.rooms)
	{
		NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room forType:self.deviceType];
		if ([devices count])
		{
			[rooms addObject:room];
		}
	}
	self.rooms = rooms;
	[self.tableView reloadData];
}

- (void) initialUnitInfo:(NSNotification *) notification
{
	[self setupRooms];
}

- (void) unitInfoChanged:(NSNotification *) notification
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		[self.tableView reloadData];
	}
	else
	{
		if ([self.rooms count] == 0)
		{
			[self.tableView reloadData];
		}
	}
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		self.splitViewController.delegate = self;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		self.splitViewController.delegate = self;
	}
	
	[self setupRooms];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitInfoChanged:) name:kDeviceUpdatedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialUnitInfo:) name:kDeviceInfoNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell" forIndexPath:indexPath];
	VeraRoom *room = nil;
	if (indexPath.row < [self.rooms count])
	{
		room = self.rooms[indexPath.row];
	}
	
    cell.textLabel.text = room.name;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		VeraRoom *room = nil;
		if (indexPath != nil && indexPath.row < [self.rooms count])
		{
			room = self.rooms[indexPath.row];
		}
		
		UISplitViewController *split = self.splitViewController;
		if (split)
		{
			if ([split.viewControllers count] == 2)
			{
				id vc = split.viewControllers[1];
				if ([vc isKindOfClass:[UINavigationController class]])
				{
					// VC #1 is the RoomDevicesViewController
					RoomBaseViewController *roomDevicesVC = (RoomBaseViewController *) ((UINavigationController *) vc).topViewController;
					roomDevicesVC.room = room;
					[roomDevicesVC refreshRoom];
				}
			}
		}
	}
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"RoomSegue"])
	{
		VeraRoom *room = nil;
		NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
		if (indexPath.row < [self.rooms count])
		{
			room = self.rooms[indexPath.row];
		}
		
		RoomBaseViewController *vc = segue.destinationViewController;
		vc.room = room;
		if (self.tableView.indexPathForSelectedRow)
		{
			[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
		}
	}
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
	return NO;
}

@end
