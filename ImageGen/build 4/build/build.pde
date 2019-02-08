
import hype.*;
import hype.extended.behavior.HOscillator;
import hype.extended.colorist.HPixelColorist;

import java.io.File;
import java.io.FilenameFilter;


// color for background
color bg = #ffffff;


// size of sketch
int sketchW = 1440;
int sketchH = 900;

int numOfDrawings = 1;

// setting positions
HOscillator[] oscX;// = new HOscillator[numOfDrawings];
HOscillator[] oscY;// = new HOscillator[numOfDrawings];


// radius
HOscillator[] radiusX;// = new HOscillator[numOfDrawings];
HOscillator[] radiusY;// = new HOscillator[numOfDrawings];

// size
HOscillator[] sizeW;// = new HOscillator[numOfDrawings];
HOscillator[] sizeH;// = new HOscillator[numOfDrawings];

// rotate
HOscillator[] rot;// = new HOscillator[numOfDrawings];

// custom drawings
PShape[] s;

// custom drawings file names
String[] customDrawings;

// set colors
HPixelColorist colors;
String colorPath = "";

String drawPath = "";

String outputPath = "";

// pause or un pause sketch
boolean pause = false;

void settings() {

	size(sketchW, sketchH);
	drawPath = dataPath("drawings");
	colorPath = dataPath("colors");
	outputPath = dataPath("output");

}

void setup() {
	H.init(this).background(bg).autoClear(true).use3D(true);
	setUpNumberOfDrawings(0);
	setUpArraySizes();
	setUpcustomDrawings();
	setPos();
	setRadius();
	setSize();
	setRotate();
	setUpColor();
	
	
	

}

void draw() {

	

	// stroke(0,20);
	// noFill();
	//pushMatrix();

		translate(sketchW/2, sketchH/2);
		for (int i = 0; i < numOfDrawings; i++) {

			HOscillator tempROT = rot[i];
			tempROT.nextRaw();
			float rot = tempROT.curr();
			rotate(rot);

			HOscillator tempX = oscX[i];
			tempX.nextRaw();
			float x = tempX.curr();

			HOscillator tempY = oscY[i];
			tempY.nextRaw();
			float y = tempY.curr();


			// controls radius
			HOscillator tempRX = radiusX[i];
			HOscillator tempRY = radiusY[i];
			tempRX.nextRaw();
			tempRY.nextRaw();
			int rx = (int )tempRX.curr();
			int ry = (int )tempRY.curr();
			
			// controls size
			HOscillator tempSW = sizeW[i];
			HOscillator tempSH = sizeH[i];
			tempSW.nextRaw();
			tempSH.nextRaw();
			int sw = (int )tempSW.curr();
			int sh = (int )tempSH.curr();		

			
			stroke(colors.getColor(x,y),20);
			noFill();
			//ellipse(  x + rx,   y+ ry , sw, sh);
			shape(s[i],  x + rx,   y+ ry , sw, sh);
		}


	//popMatrix();

}


// sets x and y values for objs
void setPos() {

	for (int i = 0; i < numOfDrawings; i++) {

		oscX[i] = new HOscillator().range(-360,360).speed(1).freq(1).currentStep(90);
		oscY[i] = new HOscillator().range(-360,360).speed(1).freq(1).currentStep(0);

	}

}

void setRadius() {
	for (int i = 0; i < numOfDrawings; i++) {

		radiusX[i] = new HOscillator().range(0,100).speed(1).freq(1).currentStep(0);
		radiusY[i] = new HOscillator().range(0,100).speed(1).freq(1).currentStep(0);

	}

}

void setSize() {

	for (int i = 0; i < numOfDrawings; i++) {

		sizeW[i] = new HOscillator().range(1,500).speed(1).freq(1).currentStep(0);
		sizeH[i] = new HOscillator().range(1,500).speed(1).freq(1).currentStep(0);

	}

}


void setRotate() {

	for (int i = 0; i < numOfDrawings; i++) {

		rot[i] = new HOscillator().range(100,500).speed(.01).freq(1).currentStep(0);

	}

}

void setUpArraySizes() {
	// setting positions
	oscX = new HOscillator[numOfDrawings];
	oscY = new HOscillator[numOfDrawings];


	// radius
	radiusX = new HOscillator[numOfDrawings];
	radiusY = new HOscillator[numOfDrawings];

	// size
	sizeW = new HOscillator[numOfDrawings];
	sizeH = new HOscillator[numOfDrawings];

	// rotate
	rot = new HOscillator[numOfDrawings];

	// custom drawings
	s = new PShape[numOfDrawings];

}


void setUpNumberOfDrawings(int levelOfRandom) {
	
	String[] tempFilename = listFileNames(drawPath, ".svg");

	switch (levelOfRandom) {
		case 0 :
			customDrawings = tempFilename.clone();
		break;	

		case 1 :
			//println("tempFilename: "+tempFilename[0]);
			customDrawings = new String[1];
			customDrawings[0] = tempFilename[(int)random(tempFilename.length)];
		break;	

	}


	numOfDrawings = customDrawings.length;



}

void setUpcustomDrawings() {

	for (int i = 0; i < customDrawings.length; i++) {
		s[i] = loadShape(customDrawings[i]);
		s[i].disableStyle();
	}

}



void setUpColor() { 
	String[] tempFilename = listFileNames(colorPath, ".jpg");


	String useThisColorFile = tempFilename[(int)random(tempFilename.length)];


	//println("useThisColorFile: "+useThisColorFile);
	colors = new HPixelColorist(colorPath + "\\" + useThisColorFile);

}


// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir, String ext) {
	
	final String str = ext;
	

	File file = new File(dir);
	if (file.isDirectory()) {
	String names[] = file.list(new FilenameFilter() {
    		@Override
   			public boolean accept(File file, String name) {
        		return name.endsWith(str);
    		}
		});
	return names;
	} else {
	// If it's not a directory
	return null;
	}
}

void keyPressed() {

	if (key == ' ') {
		if(pause) {
			loop();
			pause = false;
		} else {
			noLoop();
			pause = true;
		}

	}

	if (key == 'r') {
		background(bg);
		setUpcustomDrawings();
		setPos();
		setRadius();
		setSize();
		setRotate();
		setUpColor();
	}


	if (key == 's') {
		saveFrame( outputPath + "\\" + "output_" + year() + "_" + day() + "_" + millis() + ".png");
	}

	if (key == 'c') {
		setUpColor();
	}

}

