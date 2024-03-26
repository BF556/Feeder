//*** COLLATOR PLATE GENERATOR ***///
//***   (c) AmmoMike83  ***///
//*** Mods by RedLegEd / TylerR  ***///
/*
*** INSTRUCTIONS ***
- download openSCAD http://www.openscad.org/downloads.html
- modify options
- press F5 for preview
- press F6 to render
- press F7 to export to stl
*/

//  ###########################################################
//  ##############   See Examples at bottom   #################
//  ###########################################################

//  ###########################################################
//  ###############     Options to Customize   ################
//  ###########################################################

// PLATE DIAMETER - 179.5mm(Small)/247.5mm(Medium)/297mm(Mongo)
collator_plate_d=179.5; 

// MAIN OPTIONS
description="Large Pistol Bullet (#7)"; //description
caliber=11.5; //ENTER YOUR CALIBER HERE
collator_plate_h=15; //plate height - pistol 15, rifle 18
hole_multiplier=1.6; // Modify the number of holes

// PLATE OPTIONS
addBevel = true;  // Add top bevel to holes
bevelSize = 1.55; // Change depth of bevel (1.3 - 1.6)

// RIFLE BRASS PLATE OPTIONS
// Use caliber setting for hole length
isRifleBrassPlate = false; // Use with Rifle Brass  
rifleHoleWidth = 12; // Set to brass width

// Ridge Options
addRidges = true;  // Add top ridges for brass plates
ridgeCenter = true; // if false ridges align with far side of hole
ridgeAlternate = true; // Skip every other hole
ridgeAlternateNum = 2; // Set how ofter the ridges occur
ridgeHeight = 2.0; // Ridge height in mm
ridgeLength = 15; // Ridge length in mm
ridgeWidth = 2.5; // Ridge width in mm
ridgeAngle = 30; // Angle the ridges
ridgePosition = 0; // Position of the ridges
ridgeInsidePosition = 3; // Inside position of the ridges

// Slide Options
addSlides = false;  // Add sliding slots for bullets
//slideDepth = 1;  // Depth of slides
//slideLength = 50; // Length of slides
//slideSize = 1; // Diameter of slides
//slidePosition = 0;  //Position of slides
//slideAngle = 0;

addSideSlides = true;  // Add sliding slots on the side of hole
slideDepth = 2.0;  // Depth of slides
slideLength = 12; // Length of slides
slideSize = 1.0; // Diameter of slides
slidePosition = -6;  //Position of slides
slideAngle = 10;
slideAngle2 = 0;

// Ramp Options
addRamps = false; // Ramps give more angle for better feeding
rampHeight = 3.0;
rampLength = 7;
rampWidth = 3.5;
rampPosition = .9;
rampAngle = 4.5;
rampTopStart = 0;
rampTopLength = 1;
rampTopWidth = 2;
rampW0 = -.7;
rampW1 = .34;

// Pivot Options
addPivots = false;  // Add pivots for base down brass feeding
pivotPosition = 15;
pivotSize = .6;
pivotHeight = 1.2;
pivotWidth = 1;

// LONG RIFLE BULLETS
isLongRifleBullet = false; // Used for very long rifle bullets
squareSlotDepth = 1.5; //Depth of square bullet slot
roundedEdgeHeight = 4.9;
roundedEdgeWidth = 4.5;
roundedEdgePosition = 0;
roundedEdgeCut = 6.9;
roundedEdgeAngle = 0;
roundedEdgeSlotHeight = 0;

angledSlotHeight = 4.57;
angledSlotWidth = 1.7;
angledSlotLength = 0;
angledSlotPosition = 5.4;
bottomBevelDepth = 1.5;
bottomBevelHeight1 = -1;
bottomBevelHeight2 = 0;

// SHAFT SLIP CLUTCH
useClutch = true;  // Set to true to use slip clutch

// SHAFT OPTIONS (HEX)
useHex = false;  // Set true if using hex shaft
addHexHandle = true; // Adds hex handle to top of plate
hexHandleHeight = 5; // Set height of hex handle
addHexScrewSlot = true;  // Adds slot to shaft for set screw
setScrewOnFlat = true; //  Set screw on corner or flat
hxw=12.4;  // Hex Hole Width

// SHAFT OPTIONS (STANDARD)
shaft_hole=9.5; //shaft hole
shaft_slot_length=28;
shaft_slot_width=4.5;

// Other
$fn=100; //resolution 50-100 is fine
bullet_caliber=caliber+1.0; //caliber in (mm) + 1.0 to 1.5 mm

// ####### Customize Here ########

description="Small Brass Base Up"; 
collator_plate_d=248.0;
caliber=10.5;
collator_plate_h=20; 

addPivots = true;
pivotPosition = 15;
pivotSize = 4.9;
pivotHeight = 1.2;
pivotWidth = 1.4;

addSlides = false;
hole_multiplier=1.1;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 15;
ridgeAngle = 30;
slideDepth = 4.5;
slideLength = 15; 

addSideSlides = true;
slideDepth = 1.0; 
slideLength = 18; 
slideSize = 1.5;
slidePosition = -4.0; 
slideAngle = -15;
slideAngle2 = -6;



//  ###########################################################
//  #############     Do Not Change Code Below   ##############
//  ###########################################################

// MAIN Routine  
//collator_plate();

union(){
    difference() {
        union(){
            collator_plate();
            if(addRidges && ridgeAlternate) {
                for(p=[0:360/round(360/bullet_caliber/hole_multiplier)*ridgeAlternateNum:359]){ridges(p+15);} 
            }
            for(z=[0:360/round(360/bullet_caliber/hole_multiplier):359]){
                if(addRidges && !ridgeAlternate) {ridges(z+15);} 
                if(isLongRifleBullet) {roundedEdge(z+15);}
                if(addRamps) {ramps(z+15);}
            }   
        }
        if(isLongRifleBullet) {
            for(z=[0:360/round(360/bullet_caliber/hole_multiplier):359]){
                squareBuletHole(z+15);
            }
        }
    }   
    if(addPivots) {
        for(z=[0:360/round(360/bullet_caliber/hole_multiplier):359]){
            pivot(z+pivotPosition);
        }
    }
}


//  ###########################################################
module ramps(z) {
    
    z=z-rampPosition;
    
    translate([((collator_plate_d/2)*cos(z-caliber/2-3)),((collator_plate_d/2)*sin(z-caliber/2-3)),(collator_plate_h/2)]) 
        rotate([0,0,z+166+rampAngle])    
        prism(rampLength, rampWidth, rampHeight); 
    
}

//  ###########################################################
module squareBuletHole(z) {

      //Square
     translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-bullet_caliber/2)*sin(z)),0]) rotate([0,0,z]) 
        cube([bullet_caliber*squareSlotDepth, bullet_caliber, collator_plate_h*3], center=true);
    
     //Bottom Bevel
     translate([((collator_plate_d/2-bullet_caliber/2+2.4)*cos(z)),((collator_plate_d/2-bullet_caliber/2+2.4)*sin(z)),-collator_plate_h/2+bottomBevelHeight1]) rotate([45,0,z]) 
        cube([bullet_caliber*bottomBevelDepth, bullet_caliber, bullet_caliber], center=true);

 //Bottom Bevel
   //  translate([((collator_plate_d/2-bullet_caliber/2+2.4)*cos(z)),((collator_plate_d/2-bullet_caliber/2+2.4)*sin(z)),-collator_plate_h/2]) rotate([45,0,z*1.5]) 
    //    cube([bullet_caliber*bottomBevelDepth, bullet_caliber, bullet_caliber], center=true);

//translate([((collator_plate_d/2-bullet_caliber+3)*cos(z)),((collator_plate_d/2-bullet_caliber+3)*sin(z)),-collator_plate_h/2-(bullet_caliber/20)]) rotate([0,45,z])


     translate([((collator_plate_d/2-bullet_caliber+3)*cos(z)),((collator_plate_d/2-bullet_caliber+3)*sin(z)),-collator_plate_h/2+bottomBevelHeight2]) rotate([0,45,z]) 
       cube([bullet_caliber+.5, bullet_caliber-.1, bullet_caliber+5], center=true);
    
    // Angled Sliding Slot
     //x = z-(bullet_caliber+(caliber/1)-(caliber-hole_multiplier))-2;
    x = z + angledSlotPosition ;
     translate([((collator_plate_d/2-(bullet_caliber/2-2.0))*cos(x)),((collator_plate_d/2-(bullet_caliber/2-2.0))*sin(x)),(collator_plate_h/2)+(bullet_caliber/2.5)*bevelSize/bullet_caliber+bullet_caliber+angledSlotHeight]) rotate([40+hole_multiplier,-1,x+5])
        cube([bullet_caliber+angledSlotWidth,10, 30+caliber+angledSlotLength*2], center=true);////////////

    // Add slide slot
      if(addSlides) {
        
        p = z + slidePosition;     
        translate([((collator_plate_d/2-bullet_caliber/2-25)*cos(p)),((             collator_plate_d/2-bullet_caliber/2-25)*sin(p)),collator_plate_h/2-slideDepth+5])    rotate([0,-90+slideAngle,p-slideAngle2])
         
        cylinder(d2=bullet_caliber/2, d1=bullet_caliber+slideSize,h=slideLength,center=true);

    }
          
}
//  ###########################################################
module roundedEdge(p) {

     z = p-(bullet_caliber+(caliber/1.0))+roundedEdgePosition;

difference(){
  union() {

     mf = 2-caliber/15;    
       
     translate([((collator_plate_d/2-bullet_caliber/2-mf)*cos(z)),((collator_plate_d/2-bullet_caliber/2-mf)*sin(z)),bullet_caliber/2-caliber+roundedEdgeHeight]) rotate([-6.5+roundedEdgeAngle,90,z])
       cylinder(d=bullet_caliber*roundedEdgeDia,h=bullet_caliber+roundedEdgeWidth, center=true);
     
   // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
      //rectangular add
      x = p-bullet_caliber/2;
      moveOut = .05;
      
        //Square
   //  translate([((collator_plate_d/2-bullet_caliber/2-moveOut)*cos(x)),((collator_plate_d/2-bullet_caliber/2-moveOut)*sin(x)),-collator_plate_h/2]) rotate([0,0,x])  cube([bullet_caliber-.4, bullet_caliber+1, collator_plate_h], center=true);
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      
   // translate([((collator_plate_d/2)*cos(x)),((collator_plate_d/2)*sin(x)),0]) rotate([0,0,x])  cube([bullet_caliber, bullet_caliber, collator_plate_h*2], center=true);
      
      
    // translate([((collator_plate_d/2-bullet_caliber/2)*cos(p-bullet_caliber/2)),((collator_plate_d/2-bullet_caliber/2)*sin(p-bullet_caliber/2)),bullet_caliber/2-5]) rotate([0,0,p])   cube ([bullet_caliber,bullet_caliber,bullet_caliber+5],center=true);
            
  }

     translate([((collator_plate_d/2-bullet_caliber/2)*cos(z-roundedEdgeCut)),((collator_plate_d/2-bullet_caliber/2)*sin(z-roundedEdgeCut)),bullet_caliber/2-9]) rotate([-15,90,z])
        cube ([bullet_caliber*5,bullet_caliber*3+10.0,bullet_caliber*4],center=true);

     translate([0, 0, -collator_plate_h-10 ])
        cylinder(d=collator_plate_d+10,h=collator_plate_h+20, center=true) ;
        
     translate([0, 0, collator_plate_h ])
        cylinder(d=collator_plate_d+10,h=collator_plate_h, center=true) ;
}

}

//  ###########################################################
module pivot(p){
    cube = pivotSize;
    translate([((collator_plate_d/2-bullet_caliber-2)*cos(p)),((collator_plate_d/2-bullet_caliber-2)*sin(p)),+pivotHeight]) rotate([0,55,p])
        cube ([cube,pivotWidth,cube], center=true);}
    
 //  ###########################################################   
module ridges(p) {

    assign(ridgePos2 = (addRamps) ? rampLength+1 : 3) 

    if(isRifleBrassPlate) { 
        p=p+360/round(360/bullet_caliber/hole_multiplier)/2;
        translate([((collator_plate_d/2-ridgeLength/2-12)*cos(p)),((collator_plate_d/2-ridgeLength/2-12)*sin(p)),collator_plate_h/2]) rotate([-ridgeAngle,-90,p])
            cube ([ridgeHeight*2,ridgeWidth,ridgeLength], center=true); 
        
    } else {
            
        if(ridgeCenter) {
            p=p+(360/round(360/bullet_caliber/hole_multiplier)/2)+ridgePosition;
            translate([((collator_plate_d/2-ridgeLength/2-ridgeInsidePosition)*cos(p)),((collator_plate_d/2-ridgeLength/2-ridgeInsidePosition)*sin(p)),collator_plate_h/2]) rotate([-ridgeAngle,-90,p])
                cube ([ridgeHeight*2,ridgeWidth,ridgeLength], center=true); 
        
        }  else {
            p = p+(bullet_caliber/2)-(bullet_caliber/15)+ridgePosition;
            translate([((collator_plate_d/2-ridgeLength/2-.3)*cos(p)),((collator_plate_d/2-ridgeLength/2-.3)*sin(p)),collator_plate_h/2]) rotate([-ridgeAngle,-90,p])
                cube ([ridgeHeight*2,ridgeWidth,ridgeLength], center=true); 
        }
    }
}  

    
//  ###########################################################
module collator_plate(){
    
 difference(){
        //plate
         
     union() { // #####  Open Union  #####   
 
            cylinder(d=collator_plate_d,h=collator_plate_h, center=true) ;

            // Make sure shaft is at least 10mm high
            if(!useHex && !useClutch) {
                translate([0,0,collator_plate_h/2+1])
                cube ([shaft_slot_length+8,shaft_slot_width+8,12-collator_plate_h],center=true);
                translate([0,0,collator_plate_h/2+1])
                cylinder(d=shaft_hole+8,h=12-collator_plate_h, center=true);
            }
            
             if(useClutch && collator_plate_h<9) {
                translate([0,0,collator_plate_h/2+1])
                    cylinder(d=38,h=12-collator_plate_h, center=true);   
            }
    
            // ### Add Hex Handle ###
            if(useHex && addHexHandle) {
               translate([0,0,collator_plate_h/2+1]) 
                    cylinder(d2=22,d1=16,h=hexHandleHeight, $fn=25, center=true); 
                
                translate([0,0,collator_plate_h/2+hexHandleHeight+1]) 
                    cylinder(d=22,h=hexHandleHeight, $fn=25, center=true);          
            }

         
    } // #####  Close Union  #####  
       
 // #####  Open Difference  #####     
        translate([0, 25, collator_plate_h/2 -0.99 ]) 
            rotate([0, 0, 0]) letter(description,6,1);
        translate([0, -25, collator_plate_h/2 -0.99 ]) 
            rotate([0, 0, 180]) letter(description,6,1);
        
        if(useHex) {
            center_hole_hex();
        } else {
            center_hole(shaft_hole); 
            center_slot();
        }

        //bullet holes caliber
        if(isRifleBrassPlate) {
            for(z=[0:360/round(360/bullet_caliber/hole_multiplier):359]){rifle_slot(z+15);}
        } else {
            for(z=[0:360/round(360/bullet_caliber/hole_multiplier):359]){bullet_slot(z+15);}
        }

  } // #####  Close Difference  #####     
} 

//  ###########################################################
module center_hole_hex(){
    hxh=collator_plate_h+30;
    if(addHexScrewSlot) {
        if(setScrewOnFlat) {
            translate([0,2,0]) rotate([0,0,0])  cube([4,hxw,hxh],center = true);
        } else {
             translate([-1,2,0]) rotate([0,0,30])  cube([4,hxw,hxh],center = true);
        }
    }
    translate([0,0,5]) hull(){
    cube([hxw/1.7,hxw,hxh],center = true);
    rotate([0,0,120])cube([hxw/1.7,hxw,hxh],center = true);
    rotate([0,0,240])cube([hxw/1.7,hxw,hxh],center = true);}
    }

//  ###########################################################
module center_hole(d){
    if(useClutch) {
         cylinder(d=32,h=collator_plate_h*2+10, center=true);
        //translate([0,0,-collator_plate_h/2-1])  cylinder(d=39,h=10, center=true);
        translate([0,0,-collator_plate_h/2+5])
            cylinder(d1=40, d2=20,h=11, center=true);
        translate([0,0,-collator_plate_h/2+8.5])
            cylinder(d=39,h=20, center=false);
 
     } else {
          cylinder(d=d,h=collator_plate_h*2+10, center=true);
     }
}
   

//  ###########################################################    
module center_slot(){
    if(!useClutch) {
        cube ([shaft_slot_length,shaft_slot_width,collator_plate_h*2+10], center=true);
    }
}

//  ###########################################################
module bullet_slot(z){
    //slot
    translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-bullet_caliber/2)*sin(z)),0]) rotate([0,0,z]) 
        cylinder(d=bullet_caliber,h=collator_plate_h*2, center=true);

    //rectangular slot
    translate([((collator_plate_d/2)*cos(z)),((collator_plate_d/2)*sin(z)),0]) rotate([0,0,z]) 
        cube([bullet_caliber, bullet_caliber, collator_plate_h*2], center=true);
   
    //cone
    if(addBevel && !isLongRifleBullet) {
        translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-    bullet_caliber/2)*sin(z)),collator_plate_h/2*bevelSize]) rotate([0,0,z])    
            cylinder(  d2=bullet_caliber*3, d1=bullet_caliber,h=collator_plate_h*0.7,       center=true);
    }
    
    // Bottom Bevel
    if(!isLongRifleBullet) {
        translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-bullet_caliber/2)*sin(z)),-collator_plate_h/2*1.7]) rotate([0,0,z])
            cylinder( d1=bullet_caliber*2, d2=bullet_caliber,h=collator_plate_h*0.9,center=true);
    
        translate([((collator_plate_d/2)*cos(z)),((collator_plate_d/2)*sin(z)),-collator_plate_h/2-(bullet_caliber/7)]) rotate([46,0,z]) 
            cube([bullet_caliber, bullet_caliber, bullet_caliber], center=true);
    }
    
    // Add Slot for rounded edge
     if(isLongRifleBullet) {

        p=z-((bullet_caliber)/2);
        z = z-(bullet_caliber/2)-(bullet_caliber/15);
         
        translate([((collator_plate_d/2-bullet_caliber/2+.5)*cos(p)),((collator_plate_d/2-bullet_caliber/2+.5)*sin(p)),roundedEdgeSlotHeight]) rotate([0,90,p]) 
        cube([collator_plate_h,bullet_caliber+3, bullet_caliber], center=true);

     }

     // Add Sliding slots
     if(addSlides && !isLongRifleBullet) {
        
        p = z + slidePosition;     
        translate([((collator_plate_d/2-bullet_caliber/2-25)*cos(p)),((             collator_plate_d/2-bullet_caliber/2-25)*sin(p)),collator_plate_h/2-slideDepth+5])    rotate([0,-90+slideAngle,p-slidePosition])
         
        cylinder(d2=bullet_caliber/2, d1=bullet_caliber+slideSize,h=slideLength,center=true);

    }

    // Add Side Sliding slots
     if(addSideSlides) {
       
        p = z + slidePosition;     
        translate([((collator_plate_d/2-bullet_caliber/2)*cos(p)),((collator_plate_d/2-bullet_caliber/2)*sin(p)),collator_plate_h/2-slideDepth+5]) 
         
        rotate([75+slideAngle,slideAngle2,p])
       cylinder(d2=bullet_caliber/2, d1=bullet_caliber+slideSize,h=slideLength,center=true);

     }

  }

//  ###########################################################    
module rifle_slot(z){
   // hfactor = 1.99 +(bullet_caliber/(1100-(bullet_caliber*10)));
    rifleHoleWidth = rifleHoleWidth+1.5;
    
     translate([((collator_plate_d/2-rifleHoleWidth/2-1)*cos(z)),((collator_plate_d/2-rifleHoleWidth/2-1)*sin(z)),0]) rotate([0,0,z]) cube([rifleHoleWidth, bullet_caliber, collator_plate_h*2], center=true);
    
     translate([((collator_plate_d/2-rifleHoleWidth/2)*cos(z)),((collator_plate_d/2-rifleHoleWidth/2)*sin(z)),-collator_plate_h*2+bottomBevelHeight1]) rotate([45,0,z]) cube([rifleHoleWidth+1.95, bullet_caliber,  bullet_caliber], center=true);


     translate([((collator_plate_d/2-rifleHoleWidth/2-1)*cos(z)),((collator_plate_d/2-rifleHoleWidth/2-1)*sin(z)),-collator_plate_h+bottomBevelHeight2]) rotate([0,45,z]) cube([rifleHoleWidth, bullet_caliber-.1, collator_plate_h*4], center=true);
    
    
   // translate([((collator_plate_d/hfactor )*cos(z)),((collator_plate_d/hfactor )*sin(z)),-collator_plate_h/2-(rifleHoleWidth/6)]) rotate([0,-45,z])  cube([rifleHoleWidth*3, bullet_caliber, collator_plate_h*2], center=true);
    
   //  translate([((collator_plate_d/hfactor+.1 )*cos(z)),((collator_plate_d/hfactor+.1 )*sin(z)),-collator_plate_h/2-(bullet_caliber/5.3)]) rotate([45,0,z]) cube([rifleHoleWidth, bullet_caliber,  bullet_caliber], center=true);

    }

//  ###########################################################
module letter(l, letter_size, letter_height) {
    font = "Liberation Sans";
    linear_extrude(height = letter_height) {text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);}
 }
    
//  ###########################################################    
module prism(l, w, h){
    
    rStart = w-rampTopStart;
    rEnd = rStart-rampTopLength;
    
    polyhedron(
        points=[
    [.3,rampW0,0], //0
    [l,0,0], //1
    [l,w,0], //2
    [.3,w+rampW1,0], //3 
    [0,rEnd,h], //4
    [rampTopWidth,rEnd,h], //5
    [rampTopWidth,rStart+rampW1-.4,h], //6
    [0,rStart+rampW1-.4,h]], //7
    
       // faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
        faces=[[0,1,2,3],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0],[7,6,5,4]]
    );
    
  }  
  
  
//  ###########################################################
//  ###############          Examples          ################
//  ###########################################################
/*
description="9 mm";
caliber=9.0; 
collator_plate_h=13;

description=".40";
caliber=10.2;
collator_plate_h=13;

description=".45ACP";
caliber=11.50;
collator_plate_h=13;

description=".50";
caliber=12.7;
collator_plate_h=13;

description=".223";
caliber=5.69;
collator_plate_h=20;

description=".308";
caliber=7.82;
collator_plate_h=20;

//  ### BULLET SETTINGS  ###
description="Large Pistol Bullet (#7)";
collator_plate_d=179.5; 
caliber=12;
collator_plate_h=15; 
hole_multiplier=1.4;
ridgeAngle = 30;
ridgeInsidePosition = 18;
ridgeAlternateNum = 2.9;
addSideSlides = true;
slideDepth = 1.5; 
slideLength = 13; 
slideSize = 1.2;
slidePosition = -4.5; 
slideAngle = -25;
slideAngle2 = -8;

description="Small Pistol Bullet (#5)";
caliber=9;
collator_plate_h=15; 
hole_multiplier=1.8;
ridgeAngle = 30;
slideDepth = 4.0;
slideLength = 15;

description="Small Rifle Bullet (#2)";
caliber=6;
collator_plate_h=20; 
hole_multiplier=2.1;
ridgeAngle = 30;
addSideSlides = true;
slideDepth = 2.5;
slideLength = 10;

collator_plate_d=247.5; 
description="Small Rifle Bullet (#2)";
caliber=6;
collator_plate_h=20; 
hole_multiplier=2.0;
ridgeAngle = 30;
addSideSlides = true;
slideDepth = 2.1;
slideLength = 10;

description="Large Rifle Bullet (#4)";
caliber=7.82;
collator_plate_h=20; 
hole_multiplier=2.05;
ridgeAngle = 30;
slideDepth = 3.2;
slideLength = 15;

description="Long Rifle Bullet (#11)";
caliber=7.82;
collator_plate_h=22;
isLongRifleBullet = true;
squareSlotDepth = 1.4;
addSlides = false;
addRamps = true;
addRidges = true;
ridgeAlternate = false;
ridgeCenter = false;
ridgeHeight = 3.0;
ridgeLength = 10;
hole_multiplier= 3;
angledSlotHeight = 1.2;
slideLength = 54.1;

rampHeight = 4;
rampLength = 3.5;
rampPosition = 1.3;
rampAngle = 4.5;
roundedEdgeHeight = 4.5;

//  ### PISTOL BRASS SETTINGS  ###
addSlides = false;
addRidges = true;
addPivots = false;
bevelSize = 1.6;

description="Small Pistol Brass";
caliber=12.0;
collator_plate_h=8;
addSlides = false;
bevelSize = 1.65;
hole_multiplier=1.5;
addSideSlides = false;
ridgeAngle = 30;

description="Large Pistol Brass";
caliber=15.0;
collator_plate_h=8;
addSlides = false;
bevelSize = 1.65;
hole_multiplier=1.28;
addSideSlides = false;
ridgeAngle = 30;

description="Small Brass Base Up"; 
caliber=10.5;
collator_plate_h=20; 
addPivots = true; 
addSlides = false;
hole_multiplier=1.7;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 15;
ridgeAngle = 30;
slideDepth = 4.5;
slideLength = 15; 

description="Large Brass Base Up";
caliber=12.5;
collator_plate_h=22; 
addPivots = true;
addSlides = false;
hole_multiplier=1.5;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 15;
ridgeAngle = 30;
slideDepth = 5.6;
slideLength = 15; 

//  ###  RIFLE BRASS SETTINGS  ###
description="Large Rifle Brass";
caliber=54;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 12;
hole_multiplier=.8;
ridgeAngle = 0;

description="Small Rifle Brass";
caliber=46;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 9;
hole_multiplier=1;
ridgeAngle = 0;

description=".45-70 Cases";
caliber=56;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 12;
ridgeAngle = 0;

description=".300 AAC Blackout";
caliber=36;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 9;
hole_multiplier=1;
ridgeAngle = 0;

// ###############  MONGO  ################
description=".300 AAC Blackout";
collator_plate_d=297; 
caliber=36;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 7.72;
collator_plate_d=297;
hole_multiplier=.56;
ridgeAlternate = true;
ridgeLength = 25;
ridgeAngle = 0;
bottomBevelHeight1 = 1.6;
bottomBevelHeight2 = 1.3;

description="Small Rifle Brass";
collator_plate_d=297; 
caliber=46;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 8.39;
collator_plate_d=297;
hole_multiplier=.56;
ridgeAlternate = true;
ridgeLength = 25;
ridgeAngle = 0;
bottomBevelHeight1 = -.4;
bottomBevelHeight2 = 1.3;

description="Large Rifle Brass";
collator_plate_d=297; 
caliber=54;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 12.1;
collator_plate_d=297;
hole_multiplier=.56;
ridgeAlternate = true;
ridgeLength = 25;
ridgeAngle = 0;
bottomBevelHeight1 = -1.8;
bottomBevelHeight2 = 1;

description="Small Pistol Brass";
collator_plate_d=297; 
caliber=12.0;
collator_plate_h=8;
collator_plate_d=297;
addSlides = false;
bevelSize = 1.65;
hole_multiplier=1;
addSideSlides = false;
ridgeAngle = 30;
ridgeLength = 20;
bottomBevelHeight1 = -.5;
bottomBevelHeight2 = 1.2;

description="Large Pistol Brass";
collator_plate_d=297; 
caliber=15.0;
collator_plate_h=8;
collator_plate_d=297;
addSlides = false;
bevelSize = 1.65;
hole_multiplier=.8;
addSideSlides = false;
ridgeAngle = 30;
ridgeLength = 20;

description="Large Brass Base Up";
collator_plate_d=297; 
caliber=12.5;
collator_plate_h=22; 
addPivots = true;
addSlides = false;
hole_multiplier=1.1;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 20;
ridgeAngle = 30;
slideDepth = 6.5;
slideLength = 30;

description="Small Brass Base Up";
collator_plate_d=297; 
caliber=10.5;
collator_plate_h=20; 
addPivots = true;
addSlides = false;
hole_multiplier=1.1;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 20;
ridgeAngle = 30;
slideDepth = 5.6;
slideLength = 30;

#############  300mm  ###############
description="Small Rifle Brass";
collator_plate_d=247.5;
caliber=46;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 8.79;
hole_multiplier=.65;
ridgeLength = 20;
ridgeAngle = 0;
bottomBevelHeight1 = -.4;
bottomBevelHeight2 = 1.2;

description="Large Rifle Brass";
collator_plate_d=247.5;
caliber=54;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 12.65;
hole_multiplier=.65;
ridgeLength = 20;
ridgeAngle = 0;
bottomBevelHeight1 = -1.6;
bottomBevelHeight2 = 1.0;

description="Small Pistol Bullet (#5)";
collator_plate_d=247.5; 
caliber=9;
collator_plate_h=15; 
hole_multiplier=1.2;
ridgeAngle = 30;
ridgeInsidePosition = 12;
ridgeAlternateNum = 3;

addSideSlides = true;
slideDepth = .8; 
slideLength = 18; 
slideSize = .3;
slidePosition = -3.5; 
slideAngle = -30;
slideAngle2 = -6;

description="Large Pistol Bullet (#7)";
collator_plate_d=247.5; 
caliber=12;
collator_plate_h=15; 
hole_multiplier=1.2;
ridgeAngle = 30;
ridgeInsidePosition = 18;
ridgeAlternateNum = 2.9;

addSideSlides = true;
slideDepth = 1.5; 
slideLength = 18; 
slideSize = 1.5;
slidePosition = -4.0; 
slideAngle = -20;
slideAngle2 = -6;

description="Small Brass Base Up"; 
collator_plate_d=248.0;
caliber=10.5;
collator_plate_h=20; 

addPivots = true;
pivotPosition = 15;
pivotSize = 4.9;
pivotHeight = 1.2;

addSlides = false;
hole_multiplier=1.2;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 15;
ridgeAngle = 30;
slideDepth = 4.5;
slideLength = 15; 

addSideSlides = true;
slideDepth = 1.0; 
slideLength = 18; 
slideSize = 1.5;
slidePosition = -4.0; 
slideAngle = -15;
slideAngle2 = -6;

description="Large Brass Base Up"; 
collator_plate_d=248.0;
caliber=12.5;
collator_plate_h=22; 

addPivots = true;
pivotPosition = 15;
pivotSize = 4.9;
pivotHeight = 1.2;
pivotWidth = 1.4;

addSlides = false;
hole_multiplier=1.1;
bevelSize = 1.65;
ridgeAlternate = true;
ridgeLength = 15;
ridgeAngle = 30;
slideDepth = 4.5;
slideLength = 15; 

addSideSlides = true;
slideDepth = 1.0; 
slideLength = 18; 
slideSize = 1.5;
slidePosition = -4.0; 
slideAngle = -15;
slideAngle2 = -6;

################################################
#########   200mm Rifle Bullet .223   ##########
################################################

description="Rifle Bullet (#2)";
collator_plate_d=180.0;
caliber=5.3;
collator_plate_h=14;
hole_multiplier= 1.8;

addRidges = true;
ridgeAlternate = true;
ridgeAlternateNum = 8;
ridgeHeight = 4; 
ridgeLength = 7; 
ridgeWidth = 2.0;
ridgeAngle = 0;
ridgePosition = -1.8; 
ridgeInsidePosition = 4;

addSlides = false;
addSideSlides = false;
slideLength = 46;
slideDepth = 2; 
slidePosition = -4.5;
slideSize = 2;
slideAngle = 0;
slideAngle2 = 0;

addPivots = true;
pivotPosition = 15;
pivotSize = 2.4;
pivotHeight = 1.2;

addRamps = true;
rampHeight = 7.0;
rampLength = 8;
rampWidth = 7.21;
rampPosition = -1.36;
rampAngle = 5.5;
rampTopStart = 0;
rampTopLength = 1;
rampTopWidth = 1;
rampW0 = -.22;
rampW1 = .56;

isLongRifleBullet = true;
squareSlotDepth = 1.2;
roundedEdgeDia = 4.77;
roundedEdgePosition = .1;
roundedEdgeHeight = -1.1;
roundedEdgeWidth = 4.3;
roundedEdgeCut = 4.9;

angledSlotHeight = 15;
angledSlotWidth = 2.6;
angledSlotPosition = 5.0;

bottomBevelDepth = 1.9;
bottomBevelHeight1 = -.8;
bottomBevelHeight2 = -.6;


################################################
#########   200mm Rifle Bullet .300   ##########
################################################
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
description="Rifle Bullet (#11)";
collator_plate_d=179.5;
caliber=7.0;
collator_plate_h=22;
hole_multiplier= 2.2;

addSlides = false;
addSideSlides = false;
slideLength = 44;
slidePosition = -6;
slideDepth = 1.2; 
slideSize = 2.0;
slideAngle = 0;
slideAngle2 = 0;

addRidges = true;
ridgeCenter = true;
ridgeAlternate = true; 
ridgeAlternateNum = 3.8;
ridgeHeight = 6.0; 
ridgeLength = 10; 
ridgeWidth = 3.0;
ridgeAngle = 3; 
ridgePosition = -5.05; 
ridgeInsidePosition = 4;

addPivots = true;
pivotPosition = 15;
pivotSize = 2.1;
pivotHeight = 2;

addRamps = true;
rampHeight = 10.0;
rampLength = 8;
rampWidth = 11.92;
rampPosition = .688;
rampAngle = 4;
rampTopStart = 0;
rampTopLength = 1;
rampW0 = -1.04;
rampW1 = .99;

isLongRifleBullet = true;
squareSlotDepth = 1.2;
roundedEdgeDia = 4.5;
roundedEdgePosition = .5;
roundedEdgeHeight = 0;
roundedEdgeWidth = 5.9;
roundedEdgeAngle = -5.0;
roundedEdgeCut = 5.15;
roundedEdgeSlotHeight = 4;

angledSlotHeight = 15;
angledSlotWidth = 1.7;
angledSlotPosition = 9.3;
angledSlotLength = -2;

bottomBevelHeight1 = -.6;
bottomBevelHeight2 = -0;

########################################
######  300mm Rifle Bullet .223   ######
########################################

description="Rifle Bullet (#2)";
collator_plate_d=248.0;
caliber=5.3;
collator_plate_h=14;
hole_multiplier= 1.5;

addRidges = true;
ridgeAlternate = true;
ridgeAlternateNum = 8;
ridgeHeight = 4.0; 
ridgeLength = 8; 
ridgeWidth = 2.5;
ridgeAngle = 0;
ridgePosition = -1.4; 
ridgeInsidePosition = 3.2;

addSlides = false;
addSideSlides = false;
slideLength = 46;
slideDepth = 2; 
slidePosition = -3.2;
slideSize = 1.8;
slideAngle = 0;
slideAngle2 = 0;

addPivots = true;
pivotPosition = 15;
pivotSize = 2.4;
pivotHeight = 1.2;
pivotWidth = 1;

addRamps = true;
rampHeight = 8.0;
rampLength = 7;
rampWidth = 9.69;
rampTopStart = 0;
rampTopLength = 1;
rampTopWidth = 1;
rampPosition = -2.24;
rampAngle = 4.5;
rampW0 = -.67;
rampW1 = .27;

isLongRifleBullet = true;
squareSlotDepth = 1.2;
roundedEdgeDia = 4.70;
roundedEdgePosition = 3.35;
roundedEdgeHeight = -1.2;
roundedEdgeWidth = 4.2;
roundedEdgeCut = 4.6;

angledSlotHeight = 12;
angledSlotWidth = 2.66;
angledSlotPosition = 2.2;
angledSlotLength = 2.5;

bottomBevelDepth = 1.95;
bottomBevelHeight1 = -.9;
bottomBevelHeight2 = -.8;

################################################
#########   300mm Rifle Bullet .300   ##########
################################################

description="Rifle Bullet (#11)";
collator_plate_d=248.0;
caliber=7.0;
collator_plate_h=22;
hole_multiplier= 1.50;

addRidges = true;
ridgeCenter = true;
ridgeAlternate = true; 
ridgeAlternateNum = 5;
ridgeHeight = 6.0; 
ridgeLength = 10; 
ridgeWidth = 3.0;
ridgeAngle = 0; 
ridgePosition = -2.4; 
ridgeInsidePosition = 4.8;

addSlides = false;
addSideSlides = false;
slideLength = 40;
slideDepth = 2; 
slidePosition = -3.2;
slideSize = 1.8;
slideAngle = 0;
slideAngle2 = 0;

addPivots = true;
pivotPosition = 15;
pivotSize = 3.5;
pivotHeight = 1.2;

addRamps = true;
rampHeight = 10.0;
rampLength = 12.0;
rampWidth = 11.25;
rampTopStart = 0;
rampTopLength = 2;
rampPosition = -1.88;
rampAngle = 3.5;
rampW0 = -1.35;
rampW1 = .70;

isLongRifleBullet = true;
squareSlotDepth = 1;
roundedEdgeDia = 4.1;
roundedEdgePosition = 5.5;
roundedEdgeHeight = 2;
roundedEdgeWidth = 3.92;
roundedEdgeCut = 5.95;
roundedEdgeAngle = .5;
roundedEdgeSlotHeight = collator_plate_h/2;

angledSlotHeight = 20;
angledSlotWidth = 2.85;
angledSlotLength = 6;
angledSlotPosition = 5.4;

bottomBevelHeight1 = -.8;
bottomBevelHeight2 = -2;

################################################
#########   300mm Rifle Bullet .338   ##########
################################################

description="Rifle Bullet (#12)";
collator_plate_d=248.0;
caliber=8.0;
collator_plate_h=25;
hole_multiplier= 1.70;

addRidges = true;
ridgeCenter = true;
ridgeAlternate = true; 
ridgeAlternateNum = 4;
ridgeHeight = 8.0; 
ridgeLength = 12; 
ridgeWidth = 3.0;
ridgeAngle = 0; 
ridgePosition = -2.5; 
ridgeInsidePosition = 7;

addSlides = false;
addSideSlides = false;
slideLength = 40;
slideDepth = 2; 
slidePosition = -3.2;
slideSize = 1.8;
slideAngle = 0;
slideAngle2 = 0;

addPivots = true;
pivotPosition = 15;
pivotSize = 3.9;
pivotHeight = 7;
pivotWidth = 2.5;

addRamps = true;
rampHeight = 14.0;
rampLength = 15.0;
rampWidth = 15.92;
rampTopStart = 0;
rampTopLength = 5;
rampTopWidth = 3;
rampPosition = -2.06;
rampAngle = 2;
rampW0 = -1.46;
rampW1 = 1.29;

isLongRifleBullet = true;
squareSlotDepth = 1.1;
roundedEdgeDia = 4.5;
roundedEdgePosition = 5.19;
roundedEdgeHeight = 3;
roundedEdgeWidth = 4.53;
roundedEdgeCut = 5.15;
roundedEdgeAngle = -.9;
roundedEdgeSlotHeight = collator_plate_h/2;

angledSlotHeight = 20;
angledSlotWidth = 2.85;
angledSlotLength = 6;
angledSlotPosition = 5.4;

bottomBevelHeight1 = -.6;
bottomBevelHeight2 = -2.3;

*/ 
