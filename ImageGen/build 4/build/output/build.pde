import hype.*;
import hype.extended.layout.HGridLayout;
import hype.extended.behavior.HOscillator;

import hype.extended.layout.HCircleLayout;
import hype.extended.behavior.HRotate;



int       stageW      = 1440;
int       stageH      = 900;

color     clrBG       = #ffffff;

String    pathDATA    = "../../data/";

// ********************************************************************************************************************

int       numAssets   = 1;

// ********************************************************************************************************************


// XYZ screen positions 



HOscillator[] oscX = new HOscillator[numAssets];
HOscillator[] oscY = new HOscillator[numAssets];


void settings() {
	size(stageW, stageH, P3D);
}



void setup(){
	H.init(this).background(clrBG).autoClear(true).use3D(true);
	setupPosition();


}


void draw() {


	for (int i = 0; i < numAssets; ++i) { 
		pushMatrix();
			translate(stageW/2, stageH/2, 0);
				

				HOscillator _oscX = oscX[i];
				_oscX.nextRaw();

				HOscillator _oscY = oscY[i];
				_oscY.nextRaw();

				strokeWeight(1);
				stroke(#000000,20);
				noFill();

				ellipse(_oscX.curr(), _oscY.curr(), 50, 50);

		
		popMatrix();

	}


	


	strokeWeight(1);
	stroke(#000000);
	noFill();
	line(0, stageH/2, stageW, stageH/2);
	line(stageW/2, 0, stageW/2, stageH);
}




void setupPosition() {
	for (int i = 0; i < numAssets; ++i) {


		oscX[i] = new HOscillator().range(-360, 360).speed( 1 ).freq(1).currentStep(90);
		oscY[i] = new HOscillator().range(-360, 360).speed( 1 ).freq(1).currentStep(0);
	}
}
