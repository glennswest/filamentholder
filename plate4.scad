// Desktop ball bearing spool holder
// Written by Joe Cabana  3/1/2014
// Added bigger spool sizes 4/8/2014
// You are free to use and/or modify this software for non-comercial
// uses as long as you retain this message. Thanks.

// Print at .25 layer height, 25% infill, 2 extra shells

DoArms = 1;  // Set to non-zero to draw the outer bracket support arms, 0 to draw the rest of the stuff

Show = 0;  // Set to non-zero to show bearings

// Spool dimensions
SpoolCnt = 14;  // Number of spool sizes
SpoolWid = [97,93,89,85,81,77,73,69,65,61,57,53,49,45];  // Width of filament spool the first one must be the biggest, and the last one the smallest.
SpoolSpace = 10;  // Extra space on each side of the spool

// Mounting Latch dimensions
LatchWid = 45;  // Width of latching section

// Bearing mount dimensions
SplShdDia = 30;  // Diameter of spool guiding shoulder
SplShdThk = 2;  // Thickness of spool guiding shoulder
BearShdDia = 11;  // Diameter of bearing mount shoulder
BearShdThk = .25;  // Thickness of bearing mount shoulder
BearInDia = 8;  // Diameter of bearing center hole
BearOutDia = 22;  // Outer diameter of bearing
BearThk = 7;  // Thickness of the bearing
BearWashThk = 2.5;  // Thickness of bearing mounting washers

// Bracket dimensions
LatchOff = 0;  // Offset into bracket of latch slot
InBrkThk = 12;  // Thickness of bracket on back of replicator
OutBrkThk = 8;  // Thickness of bracket on outside
BrkWid = 100; // Width of bracket on back of replicator
InBrkHgt = 90;  // Height of bracket on back or replicator
OutBrkHgt = 30;  // Height of outside bracket
SlotDepth = 3; // Depth of slots to hold outer bracket
SlotWidth = 2; // Width of slots to hold outer bracket
SlotClear = .2;  // Clearance for outer bracket slots
ArmWid = (2 * SplShdThk) + (2 * OutBrkThk) + InBrkThk + SpoolWid[0] + SpoolSpace + SlotWidth + 1;  // Width of outer bracket arms
ArmThk = 3;  // Thickness of outer bracket arms

// Screw hole sizes
ScrewDia = 1.8; // Diameter of screw hole
ScrewClear = 2.3; // Diameter of screw clearance hole


	
	translate([OutBrkHgt/2+5,ArmWid/2-InBrkThk,ArmThk])
		rotate([180,0,0])
			Arm(1);

	




// Routine to draw the outer bracket mounting arm
module Arm(Invert = 0)
{
	SlotBlockWid = SpoolWid[0]-SpoolWid[SpoolCnt-1]+(3*SlotWidth) + 1.5;  // Width of block to hold slots

	difference()
	{
		// Arm
		union()
		{
			cube([OutBrkHgt,ArmWid,ArmThk]);  // Arm
			cube([OutBrkHgt*2,InBrkThk,ArmThk]);  // Extra bracing
			if (Invert)
				translate([0,ArmWid-SlotBlockWid-OutBrkThk-.5,-(SlotDepth-SlotClear)])
					cube([OutBrkHgt,SlotBlockWid,ArmThk+SlotDepth-SlotClear]);  // Outer bracket support
			else
				translate([0,ArmWid-SlotBlockWid-OutBrkThk-.5,0])
					cube([OutBrkHgt,SlotBlockWid,ArmThk+SlotDepth-SlotClear]);  // Outer bracket support
		}

		// Outer bracket slots
		for (cnt = [0 : (SpoolCnt-1)])
			if (Invert)
				translate([SlotWidth-SlotClear,(2*SplShdThk)+OutBrkThk+InBrkThk+SpoolWid[cnt]+SpoolSpace-(SlotWidth+(2*SlotClear)),-(ArmThk+1)])
					cube([OutBrkHgt,SlotWidth+(2*SlotClear),SlotDepth+1]);  // Outer bracket support
			else
				translate([SlotWidth-SlotClear,(2*SplShdThk)+OutBrkThk+InBrkThk+SpoolWid[cnt]+SpoolSpace-(SlotWidth+(2*SlotClear)),ArmThk])
					cube([OutBrkHgt,SlotWidth+(2*SlotClear),SlotDepth+1]);  // Outer bracket support

		// Holes
		translate([OutBrkHgt/2,(ArmWid/4)-5,-1])
			cylinder(ArmThk+2,OutBrkHgt/4,OutBrkHgt/4,$fn=36);
		translate([OutBrkHgt/2,(ArmWid/2.2)-8,-1])
			cylinder(ArmThk+2,OutBrkHgt/4,OutBrkHgt/4,$fn=36);
//		translate([OutBrkHgt/2,ArmWid/1.5,-1])
//			cylinder(ArmThk+2,OutBrkHgt/4,OutBrkHgt/4,$fn=36);

		// Screw holes
		translate([5,InBrkThk/2,-1])
			cylinder(ArmThk+2,ScrewClear/2,ScrewClear/2,$fn=12);
		translate([OutBrkHgt,InBrkThk/2,-1])
			cylinder(ArmThk+2,ScrewClear/2,ScrewClear/2,$fn=12);
		translate([2*OutBrkHgt-5,InBrkThk/2,-1])
			cylinder(ArmThk+2,ScrewClear/2,ScrewClear/2,$fn=12);
		translate([5,ArmWid-OutBrkThk/2,-1])
			cylinder(ArmThk+2,ScrewClear/2,ScrewClear/2,$fn=12);
		translate([OutBrkHgt-5,ArmWid-OutBrkThk/2,-1])
			cylinder(ArmThk+2,ScrewClear/2,ScrewClear/2,$fn=12);
	}
}

// Routine to draw the outside bracket
module OutBracket(Show = 0)
{
	difference()
	{
		union()
		{
			difference()
			{
				// Outside plate
				cube([OutBrkHgt,BrkWid,OutBrkThk]);
		
				// Hole in center
				translate([5,SplShdDia,-1])
					cube([OutBrkHgt-10,BrkWid-2*SplShdDia,OutBrkThk+2]);
			}
				// Bearing mounts
			translate([OutBrkHgt-SplShdDia/2,SplShdDia/2,0])
				BearingMnt(Show,OutBrkThk);
			translate([OutBrkHgt-SplShdDia/2,BrkWid-SplShdDia/2,0])
				BearingMnt(Show,OutBrkThk);
		}
		
		// Cut down for slots
		translate([-1,0,SlotWidth])
			cube([OutBrkHgt+2,SlotDepth,OutBrkThk+SplShdThk]);
		translate([-1,BrkWid-SlotDepth,SlotWidth])
			cube([OutBrkHgt+2,SlotDepth,OutBrkThk+SplShdThk]);
		translate([-1,BrkWid-SlotDepth,-1])
			cube([SlotWidth+1,SlotDepth,OutBrkThk+SplShdThk+2]);
		translate([-1,0,-1])
			cube([SlotWidth+1,SlotDepth,OutBrkThk+SplShdThk+2]);

		// Trim for clearance
		translate([-1,SlotClear-SlotDepth,-1])
			cube([OutBrkHgt+1,SlotDepth,OutBrkThk+SplShdThk+2]);
		translate([-1,BrkWid-SlotClear,-1])
			cube([OutBrkHgt+1,SlotDepth,OutBrkThk+SplShdThk+2]);
	}
}

// Routine to draw the end plate
module EndPlate()
{
	difference()
	{
		// Outside plate
		cube([OutBrkHgt,BrkWid,OutBrkThk]);

		// Holes
		translate([OutBrkHgt/2,BrkWid/4,-1])
			cylinder(OutBrkThk+2,OutBrkHgt/3,OutBrkHgt/3,$fn=36);
		translate([OutBrkHgt/2,BrkWid/2,-1])
			cylinder(OutBrkThk+2,OutBrkHgt/3,OutBrkHgt/3,$fn=36);
		translate([OutBrkHgt/2,BrkWid-BrkWid/4,-1])
			cylinder(OutBrkThk+2,OutBrkHgt/3,OutBrkHgt/3,$fn=36);

		// Screw holes
		translate([5,0,OutBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([OutBrkHgt-5,0,OutBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([5,BrkWid,OutBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([OutBrkHgt-5,BrkWid,OutBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
	}
}

// Routine to draw the bearing washer
module BearWash()
{
	difference()
	{
		// Washer
		cylinder(BearWashThk,BearShdDia/2,BearShdDia/2,$fn=36);
		// Hole for screw
		cylinder(BearWashThk*3,ScrewClear/2,ScrewClear/2,true,$fn=12);
	}
}

// Routine to draw back mounting bracket
module BackBracket()
{
	difference()
	{
		// Back plate
		cube([InBrkHgt,BrkWid,InBrkThk]);


		// Chop top corners
		rotate([0,0,45])
			cube([BrkWid/3,BrkWid/3,InBrkHgt*3],true);
		translate([0,BrkWid,0])
			rotate([0,0,45])
				cube([BrkWid/3,BrkWid/3,InBrkHgt*3],true);

		// Hole in center
		translate([LatchOff+10,5,-1])
			difference()
			{
				cube([InBrkHgt-(LatchOff+10)-SplShdDia/4,BrkWid-10,InBrkThk+2]);
				rotate([0,0,45])
					cube([LatchWid/2,LatchWid/2,InBrkHgt*3],true);
				translate([0,BrkWid-10,0])
					rotate([0,0,45])
						cube([LatchWid/2,LatchWid/2,InBrkHgt*3],true);
			}

		// Screw holes
		translate([InBrkHgt-5,0,InBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([InBrkHgt-OutBrkHgt,0,InBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([InBrkHgt-(2*OutBrkHgt-5),0,InBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([InBrkHgt-5,BrkWid,InBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([InBrkHgt-OutBrkHgt,BrkWid,InBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
		translate([InBrkHgt-(2*OutBrkHgt-5),BrkWid,InBrkThk/2])
			rotate([90,0,0])
				cylinder(20,ScrewDia/2,ScrewDia/2,true,$fn=8);
	}
}

// Routine to draw he bearing mount
module BearingMnt(Show = 0,BrkThk = 1)
{
	difference()
	{
		union()
		{
			// Shoulder to keep spool off of bracket
			cylinder(BrkThk+SplShdThk,SplShdDia/2,SplShdDia/2,$fn=36);
			// Shoulder to keep bearing from rubbing
			cylinder(BrkThk+BearShdThk+SplShdThk,BearShdDia/2,BearShdDia/2,$fn=36);
			// Mounting shaft
			cylinder(BrkThk+BearThk+BearShdThk+SplShdThk,BearInDia/2,BearInDia/2,$fn=12);
		}

		// Screw hole
		cylinder(50,ScrewDia/2,ScrewDia/2,true,$fn8);
	}

	if (Show)  // Show the bearing if needed
	{
		translate([0,0,BearShdThk+SplShdThk])
			color("Blue",.5)
				difference()
				{
					// Bearing minus the hole
					cylinder(BrkThk+BearThk,BearOutDia/2,BearOutDia/2,$fn=36);
					translate([0,0,-1])
						cylinder(BearThk+2,BearInDia/2,BearInDia/2,$fn=36);
				}
	}
}

