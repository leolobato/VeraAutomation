VeraAutomation
==========

This is a basic iOS app for controlling a Vera automation system. It was designed around my personal VeraLite setup and not all parts will work for everyone. The Audio control part only works with a custom Vera plugin that I wrote to talk to my Russound audio units over TCP/IP. I have also added code to ignore certain devices that I don't want shown; modify Exclusions.plist for the devices you want to ignore. The code does a substring match to items in the list.

This is a work in progress. The app works on the iPhone and iPad. I use the app everyday and it works pretty well in my setup.

Setup
==========
This project uses a number of other open source projects and references them using [CocoaPods](http://www.cocoapods.org/). After grabbing the source, switch to the directory and type:

	pod install
	
Then use the VeraAutomation.xcworkspace file when opening the project. If you don't have CocoaPods installed, please see the CocoaPods website for more information.

Feedback
==========
Please contact me directly at <veraautomation@grubysolutions.com> or open a GitHub issue.

Assistance
==========
I'm not a graphic designer and the device cells could use on and off icons. If you have any artistic ability and want to design icons that can be put into the public domain, please let me know. (I want to have the icons in the public domain so that I can keep the source on GitHub without having to deal with licensing issues; if you want a different license for your icons, but are good with them being included in this source, that's fine as well.)


Credits
==========
Icons
------
Thermometer icon by Marco Olgio and is in the public domain.

Light Bulb icon by OCHA Visual Information Unit and is in the public domain.

Radio icon by Camilo Villegas and is in the public domain.

Leaf icon by Arthy.P and is in the public domain.

Cinema icon by Saman Bemel-Benrud and is in the public domain.

Source Code
-
[ActionSheetDelegate](https://github.com/woolsweater/ActionSheetDelegate) by [Joshua Caswell](woolsweatersoft@gmail.com) and is in the public domain.

[AFNetworking](https://github.com/AFNetworking/AFNetworking) by [Mattt Thompson](m@mattt.me)

[HexColors](https://github.com/mRs-/HexColors) by [Marius Landwehr] (marius.landwehr@gmail.com) and [holgersindbaek] (holgersindbaek@gmail.com)

[HTProgressHUD](https://github.com/Hardtack/HTProgressHUD) by [GunWoo Choi](6566gun@gmail.com)

[TSMessages](https://github.com/toursprung/TSMessages) by [Felix Krause](krausefx@gmail.com)

[PDKeychainBindingsController](https://github.com/carlbrown/PDKeychainBindingsController) by [Carl Brown](carlb@pdagent.com)

ToDo
==============
* Fix issues where login prompt comes up on failed connection
* Add in climate control

License
==========
The source code or any portion of it may be used in any application used for non-commercial purposes without payment. However, you must attribute the work to me with something like:

Portions &copy;2013-2014 Scott Gruby. All rights reserved.
	
You must make it clear in your documentation that you are responsible for any application you develop.

If you would like to use the code in a commercial project, please contact me at <licensing@grubysolutions.com>. My terms are pretty reasonable in that I require a copy of whatever your develop (including hardware, if you plan on using it with a piece of hardware other than the VeraLite that I own and you are a hardware manufacturer) and must comply with the terms above.

You may not bundle the application as is (or remove pieces and bundle it) and distribute it.

This license is pretty simple and if you have any questions, please contact me.


See individual projects for licenses for AFNetworking, HexColors, HTProgressHUD, TSMessages, and PDKeychainBindingsController.