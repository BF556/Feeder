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

// LONG RIFLE BULLETS
isLongRifleBullet = false; // Used for very long rifle bullets
addRamps = true; // Ramps give more angle for better feeding
squareSlotDepth = 1.5; //Depth of square bullet slot

// RIFLE BRASS PLATE OPTIONS
// Use caliber setting for hole length
isRifleBrassPlate = false; // Use with Rifle Brass  
rifleHoleWidth = 12; // Set to brass width

// PLATE OPTIONS
addPivots = false;  // Add pivots for base down brass feeding
addSlides = true;  // Add sliding slots for bullets
addRidges = true;  // Add top ridges for brass plates
ridgeCenter = true; // if false ridges align with far side of hole
ridgeAlternate = true; // Skip every other hole
ridgeHeight = 2.0; // Ridge height in mm
ridgeLength = 25; // Ridge length in mm
ridgeAngle = 0; // Angle the ridges

addBevel = true;  // Add top bevel to holes
bevelSize = 1.5; // Change depth of bevel (1.3 - 1.6)
hole_multiplier=1.6; // Modify the number of holes

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
/*
description=".300 AAC Blackout";
caliber=36;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 9;
collator_plate_d=297;
hole_multiplier=.6;
ridgeAlternate = true;
ridgeAngle = 25;
ridgeLength = 30;
*/


//  ###########################################################
//  #############     Do Not Change Code Below   ##############
//  ###########################################################

// MAIN Routine
difference() {
union(){
                
    collator_plate();

    if(addPivots) {
        for(p=[.01:360/round(360/bullet_caliber/hole_multiplier):359]){pivot(p+15);}
    }  
  
    if(addRidges) {
        if(ridgeAlternate) {
            for(p=[0:360/round(360/bullet_caliber/hole_multiplier)*2:359]){ridges(p+15);}
        } else {
            for(p=[0:360/round(360/bullet_caliber/hole_multiplier/1):359]){ridges(p+15);}
        }
    
}
 
    if(isLongRifleBullet) {
        for(p=[0:360/round(360/bullet_caliber/hole_multiplier):359]){roundedEdge(p+15);}
    }
}

    if(isLongRifleBullet) { 
        for(p=[0:360/round(360/bullet_caliber/hole_multiplier):359]){       squareBuletHole(p+15);}
    }   
    
   
}

//  ###########################################################
module ramps(z) {
    
    z=z-2;
               translate([((collator_plate_d/2)*cos(z-caliber/2-3)),((collator_plate_d/2)*sin(z-caliber/2-3)),(collator_plate_h/2-.1)]) rotate([0,0,z+166])    prism(bullet_caliber, hole_multiplier*5, 3); 
    
}

//  ###########################################################
module squareBuletHole(z) {
    
      //Square
     translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-bullet_caliber/2)*sin(z)),0]) rotate([0,0,z]) 
    cube([bullet_caliber*squareSlotDepth, bullet_caliber, collator_plate_h*2], center=true);
    
     //Bottom Bevel
     translate([((collator_plate_d/2-bullet_caliber/2+2.5)*cos(z)),((collator_plate_d/2-bullet_caliber/2+2.5)*sin(z)),-collator_plate_h/2-(bullet_caliber/14)]) rotate([45,0,z]) 
     cube([bullet_caliber*2+.5, bullet_caliber, bullet_caliber], center=true);

     translate([((collator_plate_d/2-bullet_caliber+3)*cos(z)),((collator_plate_d/2-bullet_caliber+3)*sin(z)),-collator_plate_h/2-(bullet_caliber/14)]) rotate([0,45,z]) 
      cube([bullet_caliber+2, bullet_caliber, bullet_caliber+5], center=true);
    
    // Angled Sliding Slot
     x = z-(bullet_caliber+(caliber/1)-(caliber-hole_multiplier))-2;
     translate([((collator_plate_d/2-(bullet_caliber/2-1.9))*cos(x)),((collator_plate_d/2-(bullet_caliber/2-1.9))*sin(x)),(collator_plate_h/2)+(bullet_caliber/2.5)*bevelSize/bullet_caliber+bullet_caliber+1.2]) rotate([50+hole_multiplier,1,x+7]) cube([bullet_caliber+1,10, 30+caliber*2], center=true);////////////
    
    if(isLongRifleBullet) { 
      y = z-(bullet_caliber/2)-(bullet_caliber/15);
    //translate([((collator_plate_d/2-bullet_caliber/2-30)*cos(y-3)),((collator_plate_d/2-bullet_caliber/2-30)*sin(y-3)),(collator_plate_h/2)+(bullet_caliber/3)*bevelSize]) rotate([0,-75,y])  cube([bullet_caliber+1,9, 40+caliber*2], center=true);
        
        translate([((collator_plate_d/2-bullet_caliber/2-30)*cos(y-2.2)),((collator_plate_d/2-bullet_caliber/2-30)*sin(y-2.2)),(collator_plate_h/2)+(bullet_caliber/3)*bevelSize]) rotate([0,-84,y])  cylinder(d2=bullet_caliber/2, d1=bullet_caliber-0,h=54.1,center=true);
        
        
    }
}

//  ###########################################################
module pivot(p){
    cube = 4;
    translate([((collator_plate_d/2-bullet_caliber-1)*cos(p)),((collator_plate_d/2-bullet_caliber-1)*sin(p)),-1]) rotate([0,60,p]) cube ([cube,1.5,cube], center=true);}
    
 //  ###########################################################   
module ridges(p) {

    if(isRifleBrassPlate) { 
        p=p+360/round(360/bullet_caliber/hole_multiplier)/2;
         translate([((collator_plate_d/2-ridgeLength/2-.3)*cos(p)),((collator_plate_d/2-ridgeLength/2-.3)*sin(p)),collator_plate_h/2]) rotate([-ridgeAngle,-90,p]) cube ([ridgeHeight*2,2.5,ridgeLength], center=true); 
        
        } else {
            
        if(ridgeCenter) {
             p=p+360/round(360/bullet_caliber/hole_multiplier)/2;
         translate([((collator_plate_d/2-ridgeLength/2-.3)*cos(p)),((collator_plate_d/2-ridgeLength/2-.3)*sin(p)),collator_plate_h/2]) rotate([-ridgeAngle,-90,p]) cube ([ridgeHeight*2,2.5,ridgeLength], center=true); 
        
        }  else {
            p = p+(bullet_caliber/2)-(bullet_caliber/15)+.5;
            translate([((collator_plate_d/2-ridgeLength/2-.3)*cos(p)),((collator_plate_d/2-ridgeLength/2-.3)*sin(p)),collator_plate_h/2]) rotate([0,-90,p]) cube ([ridgeHeight*2,2.5,ridgeLength], center=true); 
        }
    }
}  

//  ###########################################################
module roundedEdge(p) {

     z = p-(bullet_caliber+(caliber/1.0)+0);
    
    union() {
     difference(){
        union() {

     mf = 2-caliber/15;       
             translate([((collator_plate_d/2-bullet_caliber/2-mf)*cos(z)),((collator_plate_d/2-bullet_caliber/2-mf)*sin(z)),bullet_caliber/2-caliber-3]) rotate([-12,90,z]) cylinder(d=bullet_caliber*4.6,h=bullet_caliber+5.9, center=true);
            
        }

        translate([((collator_plate_d/2-bullet_caliber/2)*cos(z-6.5)),((collator_plate_d/2-bullet_caliber/2)*sin(z-6.5)),bullet_caliber/2-9]) rotate([-15,90,z]) cube ([bullet_caliber*5,bullet_caliber*3+10,bullet_caliber*4],center=true);

      translate([0, 0, -collator_plate_h-10 ]) cylinder(d=collator_plate_d+10,h=collator_plate_h+20, center=true) ;
        
         translate([0, 0, collator_plate_h ])  cylinder(d=collator_plate_d+10,h=collator_plate_h, center=true) ;

    }
      // ##### LONG RIFLE ######
            if(isLongRifleBullet && addRamps) {
           for(z=[0:360/round(360/bullet_caliber/hole_multiplier):359]){ramps(z+15);}
         }
    }
}
    
//  ###########################################################
module collator_plate(){
    difference(){
        //plate
        union() {
            
            
            cylinder(d=collator_plate_d,h=collator_plate_h, center=true) ;

            // Make sure shaft is at least 10mm high
            if(!useHex && !useClutch) {
                translate([0,0,collator_plate_h/2+1])
                cube ([shaft_slot_length+8,shaft_slot_width+8,12-collator_plate_h],              center=true);
                translate([0,0,collator_plate_h/2+1])
                cylinder(d=shaft_hole+8,h=12-collator_plate_h, center=true);
            }
            
             if(useClutch && collator_plate_h<9) {
                  translate([0,0,collator_plate_h/2+1])
                cylinder(d=38,h=12-collator_plate_h, center=true);   
            }
    
            // ### Add Hex Handle ###
            if(useHex && addHexHandle) {
               translate([0,0,collator_plate_h/2+1]) cylinder(d2=22,d1=16,h=hexHandleHeight, $fn=25, center=true); 
                translate([0,0,collator_plate_h/2+hexHandleHeight+1]) cylinder(d=22,h=hexHandleHeight, $fn=25, center=true);          
            }
            // ### End Hex ###
            
       }
        
        translate([0, 25, collator_plate_h/2 -0.99 ]) rotate([0, 0, 0]) letter(description,6,1);
        translate([0, -25, collator_plate_h/2 -0.99 ]) rotate([0, 0, 180]) letter(description,6,1);
        
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

        }} 

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
        translate([0,0,-collator_plate_h/2+5]) cylinder(d1=40, d2=20,h=11, center=true);
        translate([0,0,-collator_plate_h/2+8.5]) cylinder(d=39,h=20, center=false);
 
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
    translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-bullet_caliber/2)*sin(z)),0]) rotate([0,0,z]) cylinder(d=bullet_caliber,h=collator_plate_h*2, center=true);

    //rectangular slot
    translate([((collator_plate_d/2)*cos(z)),((collator_plate_d/2)*sin(z)),0]) rotate([0,0,z]) cube([bullet_caliber, bullet_caliber, collator_plate_h*2], center=true);
   
    //cone
    if(addBevel && !isLongRifleBullet) {
        translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-    bullet_caliber/2)*sin(z)),collator_plate_h/2*bevelSize]) rotate([0,0,z])    cylinder(  d2=bullet_caliber*3, d1=bullet_caliber,h=collator_plate_h*0.7,       center=true);
    }
    
    // Bottom Bevel
    if(!isLongRifleBullet) {
     translate([((collator_plate_d/2-bullet_caliber/2)*cos(z)),((collator_plate_d/2-bullet_caliber/2)*sin(z)),-collator_plate_h/2*1.7]) rotate([0,0,z])         cylinder( d1=bullet_caliber*2, d2=bullet_caliber,h=collator_plate_h*0.9,center=true);
    
    translate([((collator_plate_d/2)*cos(z)),((collator_plate_d/2)*sin(z)),-collator_plate_h/2-(bullet_caliber/7)]) rotate([46,0,z]) cube([bullet_caliber, bullet_caliber, bullet_caliber], center=true);
    }
    
    // Add Slot for rounded edge
     if(isLongRifleBullet) {
           z = z-(bullet_caliber/2)-(bullet_caliber/15);
        translate([((collator_plate_d/2-bullet_caliber/2+.5)*cos(z)),((collator_plate_d/2-bullet_caliber/2+.5)*sin(z)),bullet_caliber/2-4]) rotate([0,90,z]) cube([bullet_caliber*3,bullet_caliber+3, bullet_caliber], center=true);
   
     }
     
     
    //  if(isLongRifleBullet) {
    //       translate([((collator_plate_d/2-25)*cos(z)),((collator_plate_d/2-25)*sin(z)),   (collator_plate_h/2)+(bullet_caliber/5)*bevelSize]) rotate([0,-90,z]) # cylinder(d2=bullet_caliber/2, d1=bullet_caliber+(0),h=40,center=true); 
        
    //}
    
     // Add Sliding slots
     if(addSlides) {
         translate([((collator_plate_d/2-25)*cos(z)),((collator_plate_d/2-25)*sin(z)),   (collator_plate_h/2)+(bullet_caliber/5)*bevelSize]) rotate([0,-90,z]) cylinder(d2=bullet_caliber/2, d1=bullet_caliber+(0),h=40,center=true); 
        
    }

  }

//  ###########################################################    
module rifle_slot(z){
    hfactor = 2 +(bullet_caliber/(1100-(bullet_caliber*10)));
    
      translate([((collator_plate_d/hfactor )*cos(z)),((collator_plate_d/hfactor )*sin(z)),0]) rotate([0,0,z]) cube([rifleHoleWidth*2, bullet_caliber, collator_plate_h*2], center=true);
    
   // translate([((collator_plate_d/hfactor )*cos(z)),((collator_plate_d/hfactor )*sin(z)),-collator_plate_h/2-(rifleHoleWidth/6)]) rotate([0,-45,z])  cube([rifleHoleWidth*3, bullet_caliber, collator_plate_h*2], center=true);
    
     translate([((collator_plate_d/hfactor )*cos(z)),((collator_plate_d/hfactor )*sin(z)),-collator_plate_h/2-(bullet_caliber/5.3)]) rotate([45,0,z]) cube([rifleHoleWidth*2, bullet_caliber,  bullet_caliber], center=true);

    }

//  ###########################################################
module letter(l, letter_size, letter_height) {
    font = "Liberation Sans";
    linear_extrude(height = letter_height) {text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);}
 }
    
//  ###########################################################    
module prism(l, w, h){
       polyhedron(
            points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h], [l/5,w,h]],
            faces=[[0,1,2,3],[6,4,3,2],[0,4,6,1],[0,3,4],[6,2,1]]
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
addSlides = true;
addRidges = true;
addPivots = false;
bevelSize = 1.4;

description="Small Pistol Bullet (#5)";
caliber=9;
collator_plate_h=15; 
hole_multiplier=1.8;

description="Large Pistol Bullet (#7)";
caliber=11.5;
collator_plate_h=15; 
hole_multiplier=1.6;

description="Small Rifle Bullet (#2)";
caliber=5.70;
collator_plate_h=20; 
hole_multiplier=2.1;

description="Large Rifle Bullet (#4)";
caliber=7.82;
collator_plate_h=20; 
hole_multiplier=2.05;

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

description="Large Pistol Brass";
caliber=15.0;
collator_plate_h=8;
addSlides = false;
bevelSize = 1.65;
hole_multiplier=1.28;

description="Small Brass Base Up"; 
caliber=10.5;
collator_plate_h=20; 
addPivots = true; 
addSlides = false;
hole_multiplier=1.7;
bevelSize = 1.65;
ridgeAlternate = false;
ridgeLength = 15;
ridgeAngle = 40;

description="Large Brass Base Up";
caliber=12.5;
collator_plate_h=22; 
addPivots = true;
addSlides = false;
hole_multiplier=1.5;
bevelSize = 1.65;
ridgeAlternate = false;
ridgeLength = 15;
ridgeAngle = 40;

//  ###  RIFLE BRASS SETTINGS  ###
description="Large Rifle Brass";
caliber=54;
collator_plate_h=6;
isRifleBrassPlate = true;
//ridgeAlternate = false;
rifleHoleWidth = 12;
hole_multiplier=.8;

description="Small Rifle Brass";
caliber=46;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 9;
hole_multiplier=1;

description=".45-70 Cases";
caliber=56;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 12;

description=".300 AAC Blackout";
caliber=36;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 9;

description=".300 AAC Blackout MONGO";
caliber=36;
collator_plate_h=6;
isRifleBrassPlate = true;
rifleHoleWidth = 9;
collator_plate_d=297;
hole_multiplier=.6;
ridgeAlternate = true;
ridgeAngle = 25;
ridgeLength = 30;

*/ 
