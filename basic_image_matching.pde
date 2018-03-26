
// Image arrays
PImage imagesOrig [] = new PImage [51]; // All original images
PImage imagesPP [] = new PImage [51]; // Pre-processed images
PImage imagesSearchRGB [] = new PImage [50]; // Image array to use for searching
PImage imagesSearchGS [] = new PImage [50]; // Image array to use for searching
PImage targetRGB;
PImage targetGS;

// Match scoring arrays
int brightPixResults [] = new int [50];
int brightTotResults [] = new int [50];
int brightKernResults [] = new int [50];
int edgeMatchResults [] = new int [50];
int manMatchResults [] = new int [50];
int euclMatchResults [] = new int [50];


void setup() {
  size(1000, 900);
  background(255);
  
  PImage in1 = loadImage("LDN.jpg");  // load target image into first position in Orig array
  imagesOrig[0] = in1;

  for (int i=1; i<imagesOrig.length; i++) {
    PImage in2 = loadImage("Image_" + str(i) + ".jpg"); // load in image and re-size before loading into array
    //in2.resize(100,0);
    imagesOrig[i] = in2;
  }


  // pre processing for RGB matching
  for (int i=0; i<imagesOrig.length; i++) {   // copy original images
    PImage in3 = (imagesOrig[i].get());
    in3 = resize_rgb(in3, true);
    if (i==0) targetRGB = in3;                // insert images into target and search array
    if (i>0) imagesSearchRGB[i-1] = in3;
  }
  
  // pre processing for greyscale matching
  for (int i=0; i<imagesOrig.length; i++) {   // copy original images
    PImage in4 = (imagesOrig[i].get());
    //in3 = bright_max(in3);
    in4 = resize_rgb(in4, false);
    if (i==0) targetGS = in4;                // insert images into target and search array
    if (i>0) imagesSearchGS[i-1] = in4;
  }



 // run all matching functions
  manhattan_match(targetRGB,imagesSearchRGB);
  euclidian_match(targetRGB,imagesSearchRGB);
  brightness_pixel(targetGS,imagesSearchGS);
  brightness_total(targetGS,imagesSearchGS);
  
  fill(0);
  
  // DRAW MATCHING RESULTS
  // note - the second input in the imageM function can be changed to show
  // different results ( 0 = best match, 49 = worst match)
  
  // draw brightness total match results - note 
  text("Approach 1: total image brightness matching",2,15);
  imageT(250,0,20);
  imageM(brightTotResults,0,250,250,20);
  imageM(brightTotResults,1,250,500,20);
  imageM(brightTotResults,49,250,750,20);  

  // draw brightness pixel match results
  text("Approach 2: vector brightness matching",2,235);
  imageT(250,0,240);
  imageM(brightPixResults,0,250,250,240);
  imageM(brightPixResults,1,250,500,240);
  imageM(brightPixResults,49,250,750,240);
  
  // draw manhatten match results
  text("Approach 3: vector rgb manhattan matching",2,455);
  imageT(250,0,460);
  imageM(manMatchResults,0,250,250,460);
  imageM(manMatchResults,1,250,500,460);
  imageM(manMatchResults,49,250,750,460);
  
  // draw euclidian match results
  text("Approach 4: vector rgb euclidian matching",2,675);
  imageT(250,0,680);
  imageM(euclMatchResults,0,250,250,680);
  imageM(euclMatchResults,1,250,500,680);
  imageM(euclMatchResults,49,250,750,680);
  
}