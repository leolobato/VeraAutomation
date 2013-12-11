//
//  AudioRoomsViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "AudioRoomsViewController.h"
#import "AudioRoomViewController.h"
#import "VeraRoom.h"
#import "VeraDevice.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"

@interface AudioRoomsViewController ()
@property (nonatomic, strong) NSArray *rooms;
@end

@implementation AudioRoomsViewController

- (void) setupRooms
{
	NSMutableArray *rooms = [NSMutableArray array];
	for (VeraRoom *room in [VeraAutomationAppDelegate appDelegate].api.unitInfo.rooms)
	{
		BOOL addRoom = NO;
		NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room];
		
		for (VeraDevice *device in devices)
		{
			if ([device isAudio])
			{
				addRoom = YES;
				break;
			}
		}
		
		if (addRoom)
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
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"AUDIO_TITLE", nil);
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
    // Configure the cell...
    
    return cell;
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
		
		AudioRoomViewController *vc = segue.destinationViewController;
		vc.room = room;
		
	}
}

@end
