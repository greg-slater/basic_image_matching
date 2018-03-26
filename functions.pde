
// -------------------------------------------------------//
//                PRE-PROCESSING METHODS                  //
//--------------------------------------------------------//

// EDGE DETECTION - not used
PImage edge_detect(PImage pin) {
  pin.loadPixels();  
  PImage pout = createImage(pin.width, pin.height, RGB);
  pout.loadPixels();

  for (int i = pout.width; i<pout.pixels.length - pout.width; i++) {

    float b0 = brightness(pin.pixels[i] );
    float x1 = brightness(pin.pixels[i-1]);
    float y1 = brightness(pin.pixels[i-pout.width]);

    float xdiff = abs(b0-x1); // measure absolute dif between pixels in x and y direction
    float ydiff = abs(b0-y1);

    float diff = (xdiff+ydiff)/2;
    
    // set to black or white depending on if threshold is passed
    if (diff>45) pout.pixels[i] = color(0);
    else pout.pixels[i] = color(255);
  }
  pout.updatePixels();
  return pout;
}

// BRIGHTNESS MAXIMISATION 
PImage bright_max(PImage pin) {
  pin.loadPixels(); 
  PImage pout = createImage(pin.width, pin.height, RGB);
  pout.loadPixels();

  float min = 256; // set min and max values which will be passed
  float max = 0;

  for (int i = 0; i<pout.pixels.length; i++) {  // find min and max pixel brightness of image

    float pix = brightness(pin.pixels[i]);

    if (pix < min) min = pix;
    if (pix > max) max = pix;
  }
  for (int i = 0; i<pout.pixels.length; i++) { // map pixel brightness from current min max to 0 255

    pout.pixels[i] = color(map(brightness(pin.pixels[i]), min, max, 0, 255));
  }
  pout.updatePixels();
  return pout;
}

// GAUSSIAN SMOOTHING - greyscale
PImage gaussian_edge(PImage pin) {
  pin.loadPixels();  
  PImage pout = createImage(pin.width, pin.height, RGB);
  PImage pout2 = createImage(pin.width, pin.height, RGB);
  pout.loadPixels();
  pout2.loadPixels();

  // horizontal pass
  for (int i = 0; i<pout.pixels.length; i++) {
    if (valid_pixel(i, pout.width, pout.pixels.length) ) {  

      float b1 = brightness(pin.pixels[i-1] ); // read pixel values in x direction
      float b2 = brightness(pin.pixels[i+1] );
      float b0 = brightness(pin.pixels[i] );

      float g = ( (b1*0.27901)+(b0*0.44198)+(b2*0.27901) ); // calculate new pixel values

      pout.pixels[i] = color(g);
    }
  }
  pout.updatePixels();

  pout.loadPixels();

  // vertical pass
  for (int i=0; i<pout2.pixels.length; i++) {

    if (valid_pixel(i, pout2.width, pout2.pixels.length) ) { 

      float b0 = brightness(pout.pixels[i] );  // read pixel values in y direction
      float b1 = brightness(pout.pixels[i - pout2.width] );
      float b2 = brightness(pout.pixels[i + pout2.width] );

      float g = ( (b1*0.27901)+(b0*0.44198)+(b2*0.27901) ); // calculate new pixel values

      pout2.pixels[i] = color(g);
    }
  }

  pout2.updatePixels();
  return pout2;
}

// GAUSSIAN SMOOTHING - RGB
PImage gaussian_edge_rgb(PImage pin) {
  pin.loadPixels();  
  PImage pout = createImage(pin.width, pin.height, RGB);
  PImage pout2 = createImage(pin.width, pin.height, RGB);
  pout.loadPixels();
  pout2.loadPixels();

  // horizontal pass
  for (int i=0; i<pout.pixels.length; i++) {

    if (valid_pixel(i, pout.width, pout.pixels.length) ) {  

      color b0 = color(pin.pixels[i]); // read pixel values in x direction
      color b1 = color(pin.pixels[i-1]);
      color b2 = color(pin.pixels[i+1]);

      PVector v0 = new PVector(b0 >> 16 & 0xFF, b0 >> 8 & 0xFF, b0 & 0xFF); // bit shift RGB values to vectors for each pixel
      PVector v1 = new PVector(b1 >> 16 & 0xFF, b1 >> 8 & 0xFF, b1 & 0xFF);
      PVector v2 = new PVector(b2 >> 16 & 0xFF, b2 >> 8 & 0xFF, b2 & 0xFF);

      float gRed    = ((v1.x * 0.27901) + (v0.x * 0.44198) + (v2.x * 0.27901)); // calculate new RGB values for i pixel
      float gGreen  = ((v1.y * 0.27901) + (v0.y * 0.44198) + (v2.y * 0.27901));
      float gBlue   = ((v1.z * 0.27901) + (v0.z * 0.44198) + (v2.z * 0.27901));

      pout.pixels[i] = color(gRed, gGreen, gBlue); // assign new RGB values
    }
  }
  pout.updatePixels();

  // vertical pass
  for (int i=0; i<pout2.pixels.length; i++) {

    if (valid_pixel(i, pout2.width, pout2.pixels.length) ) { 

      color b0 = color(pout.pixels[i]); // read pixel values in y direction
      color b1 = color(pout.pixels[i - pout2.width]);
      color b2 = color(pout.pixels[i + pout2.width]);

      PVector v0 = new PVector(b0 >> 16 & 0xFF, b0 >> 8 & 0xFF, b0 & 0xFF); // bit shift RGB values to vectors for each pixel
      PVector v1 = new PVector(b1 >> 16 & 0xFF, b1 >> 8 & 0xFF, b1 & 0xFF);
      PVector v2 = new PVector(b2 >> 16 & 0xFF, b2 >> 8 & 0xFF, b2 & 0xFF);

      float gRed    = ((v1.x * 0.27901) + (v0.x * 0.44198) + (v2.x * 0.27901)); // calculate new RGB values for i pixel
      float gGreen  = ((v1.y * 0.27901) + (v0.y * 0.44198) + (v2.y * 0.27901));
      float gBlue   = ((v1.z * 0.27901) + (v0.z * 0.44198) + (v2.z * 0.27901));

      pout2.pixels[i] = color(gRed, gGreen, gBlue); // assign new RGB values
    }
  }
  pout2.updatePixels();
  return pout2;
}

// SAMPLING
PImage sample(PImage pin) {
  pin.loadPixels();
  int h;
  int w;

// logic to add an extra row if height of input image is uneven
  if ( (pin.height)%2==1) {
    w = pin.width/2;
    h = pin.height/2 +1;
  } else {
    w = pin.width/2;
    h = pin.height/2;
  }
  PImage pout = createImage(w, h, RGB);
  pout.loadPixels();

  int poutPixel = 0; // variable to track the pixel id of the image being created
  int rowCount = -1; // variable to track row number of input image

  for (int i = 0; i<pin.pixels.length; i++) {

    if (i % pin.width == 0) rowCount++; // increment row counter at first pixel of each row
    if (rowCount % 2 == 0 && i % 2 == 0) {  // if even row and even pixel copy pixel to output
      pout.pixels[poutPixel] = pin.pixels[i];
      poutPixel++;
    }
  }
  pout.updatePixels();
  return pout;
}

// RESIZING - RGB or greyscale options
PImage resize_rgb(PImage pin, boolean rgb) {

  PImage pout = pin.get();
  
  // loop through smooth and sample 4x until size is 50x38 then re-size to 20x15
  for (int i=0; i<4; i++) {
    if (rgb) {
      pout = gaussian_edge_rgb(pout);
      pout = sample(pout);
    } else {
      pout = gaussian_edge(pout);
      pout = sample(pout);
    }
  }
  pout.resize(20, 15);
  return pout;
}


// -------------------------------------------------------//
//                  MATCHING METHODS                      //
//--------------------------------------------------------//


// Quick logic explanation.. Each of the matching methods follows the logic below:
//  1. score each image
//  2. record the score of each image in a new array (scoresArray) and a new list (scores)
//  3. sort the list - the best matching image will now be in position 0, worst in 49
//  4. go through the list, using the score to look up the position of that image in the scoresArray, which will match its position in the input array
//  5. record that position in a global array (e.g euclMatchResults), which can be used to draw the original images


// VECTOR EUCLIDIAN MATCHING - RGB
void euclidian_match(PImage _target, PImage [] _imagesSearch) {
  int time = millis();
  float diff_sum = 0; 
  float scoresArray [] = new float[_imagesSearch.length];
  FloatList scores = new FloatList();

  // loop through images in search array
  for (int i=0; i< _imagesSearch.length; i++) { 
    diff_sum = 0;
    PImage p = _target;
    PImage q = _imagesSearch[i];
    p.loadPixels();
    q.loadPixels();

    // loop through pixels in target and search images
    for (int j=0; j<p.pixels.length; j++) {

      color pc = color(p.pixels[j]); // read colour values
      color qc = color(q.pixels[j]);

      PVector pa = new PVector(pc >> 16 & 0xFF, pc >> 8 & 0xFF, pc & 0xFF); // read RGB values into p and q vectors
      PVector qa = new PVector(qc >> 16 & 0xFF, qc >> 8 & 0xFF, qc & 0xFF);

      // Euclidian Distance calc
      float diff = sq(pa.x-qa.x) + sq(pa.y-qa.y) + sq(pa.z-qa.z);
      diff_sum = diff_sum + diff;
    }
    diff_sum = sqrt(diff_sum); // total difference for each image, which is then squared

    scoresArray[i] = diff_sum;  // store score in array - this will record the input order of search images
    scores.append(diff_sum);  // record score in list, which will be sorted and used to match to array above

    // score calculation QA
    //println("i            "+i);
    //println("diff_sum     "+diff_sum);
    //println("scores       "+scoresArray[i]);
    //println();
  }

  scores.sort();
  println(scores);
  println("best match    "+matchIndex(scores.get(0), scoresArray));
  println("second best   "+matchIndex(scores.get(1), scoresArray));
  println("worst         "+matchIndex(scores.get(scores.size()-1), scoresArray));

  // record array indices of search images in order of best match
  // this works through the now ordered score list, and records (in a new array) their original position in the input array
  for (int i=0; i<_imagesSearch.length; i++) {

    euclMatchResults[i] = matchIndex(scores.get(i), scoresArray) +1 ;  // +1 is because orig array has target image at first position
  }
  println("elapsed time: "+(millis()-time)+" milliseconds");
}

// VECTOR MANHATTAN MATCHING - RGB
void manhattan_match(PImage _target, PImage [] _imagesSearch) {
  int time = millis();
  float diff_sum = 0;
  float scoresArray [] = new float[_imagesSearch.length];
  FloatList scores = new FloatList();
  
  // loop through images in search array
  for (int i=0; i< _imagesSearch.length; i++) {
    diff_sum = 0;
    PImage p = _target;
    PImage q = _imagesSearch[i];
    p.loadPixels();
    q.loadPixels();

    // loop through pixels in target and search images
    for (int j=0; j<p.pixels.length; j++) {

      color pc = color(p.pixels[j]); // read colour values
      color qc = color(q.pixels[j]);

      PVector pa = new PVector(pc >> 16 & 0xFF, pc >> 8 & 0xFF, pc & 0xFF); // read RGB values into p and q vectors
      PVector qa = new PVector(qc >> 16 & 0xFF, qc >> 8 & 0xFF, qc & 0xFF);

      // Manhattan Distance calc
      float diff = abs(pa.x-qa.x) + abs(pa.y-qa.y) + abs(pa.z-qa.z); // sum all the absolute differences between vector dimensions
      diff_sum = diff_sum + diff; // cumulative addition of difference between pixels
    }

    scoresArray[i] = diff_sum;  // store score in array - this will record the input order of search images
    scores.append(diff_sum);  // record score in list, which will be sorted and used to match to array above

    // score calculation QA
    //println("i            "+i);
    //println("diff_sum     "+diff_sum);
    //println("scores       "+scoresArray[i]);
    //println();
  }

  // score sorting and judging QA
  scores.sort();
  println(scores);
  println("best match    "+matchIndex(scores.get(0), scoresArray));
  println("second best   "+matchIndex(scores.get(1), scoresArray));
  println("worst         "+matchIndex(scores.get(scores.size()-1), scoresArray));

  // record array indices of search images in order of best match
  // this works through the now ordered score list, and records (in a new array) their original position in the input array
  for (int i=0; i<_imagesSearch.length; i++) {

    manMatchResults[i] = matchIndex(scores.get(i), scoresArray) +1 ;  // +1 is because orig array has target image at first position
  }
  println("elapsed time: "+(millis()-time)+" milliseconds");
}

// VECTOR MATCHING - BRIGHTNESS 
void brightness_pixel(PImage _target, PImage [] _imagesSearch) {
  int time = millis();
  float diff_sum = 0;
  float scoresArray [] = new float[_imagesSearch.length];
  FloatList scores = new FloatList();

  // loop through images in search array
  for (int i=0; i< _imagesSearch.length; i++) {
    diff_sum = 0;
    PImage p = _target;
    PImage q = _imagesSearch[i];
    p.loadPixels();
    q.loadPixels();

    // loop through pixels in target and search images
    for (int j=0; j<p.pixels.length; j++) {

      float pb = brightness(p.pixels[j]);
      float qb = brightness(q.pixels[j]);

      float diff = abs(pb-qb);
      diff_sum = diff_sum + diff; // cumulatively record brightness difference between pixels
    }
    scoresArray[i] = diff_sum;  // store score in array to store record the order
    scores.append(diff_sum);  // record score in list, which will be sorted and used to match to array above

    // score calculation QA
    //println("i            "+i);
    //println("diff_sum     "+diff_sum);
    //println("scores       "+scoresArray[i]);
    //println();
  }

  scores.sort();

  // score sorting and judging QA
  println(scores);
  println();
  println("best match    "+matchIndex(scores.get(0), scoresArray));
  println("second best   "+matchIndex(scores.get(1), scoresArray));
  println("worst         "+matchIndex(scores.get(scores.size()-1), scoresArray));

  // record array indices of search images in order of best match
  // this works through the now ordered score list, and records (in a new array) their original position in the input array
  for (int i=0; i<_imagesSearch.length; i++) {

    brightPixResults[i] = matchIndex(scores.get(i), scoresArray) +1 ;  // +1 is because orig array has target image at first position
  }
  println("elapsed time: "+(millis()-time)+" milliseconds");
}

// BRIGHTNESS MATCHING - total
void brightness_total(PImage _target, PImage [] _imagesSearch) {
  int time = millis();
  float diff_sum = 0;
  float scoresArray [] = new float[_imagesSearch.length];
  FloatList scores = new FloatList();

  // loop through images in search array
  for (int i=0; i< _imagesSearch.length; i++) {
    float tBright = 0;
    float sBright = 0;
    PImage p = _target;
    PImage q = _imagesSearch[i];
    p.loadPixels();
    q.loadPixels();

    // loop through pixels in target and search images
    for (int j=0; j<p.pixels.length; j++) {

      tBright = tBright + brightness(p.pixels[j]);
      sBright = sBright + brightness(q.pixels[j]);
    }
    diff_sum = abs(tBright - sBright); // calculate difference in total brightness between images
    scoresArray[i] = diff_sum;  // store score in array to record the order
    scores.append(diff_sum);  // store score in a list, which will be sorted and used to match to array above and return their original index

    // score calculation QA
    //println("i            "+i);
    //println("diff_sum     "+diff_sum);
    //println("scores       "+scoresArray[i]);
    //println();
  }
  scores.sort();

  // score sorting and judging QA
  println(scores);
  println();
  println("best match    "+matchIndex(scores.get(0), scoresArray));
  println("second best   "+matchIndex(scores.get(1), scoresArray));
  println("worst         "+matchIndex(scores.get(scores.size()-1), scoresArray));

  // record array indices of search images in order of best match
  // this works through the now ordered score list, and records (in a new array) their original position in the input array
  for (int i=0; i<_imagesSearch.length; i++) {

    brightTotResults[i] = matchIndex(scores.get(i), scoresArray) +1 ;  // +1 is because orig array has target image at first position
  }
  println("elapsed time: "+(millis()-time)+" milliseconds");
}

// EDGE MATCHING - not used
void edge_match(PImage _target, PImage [] _imagesSearch) {

  float diff_sum = 0;
  float scoresArray [] = new float[_imagesSearch.length];

  FloatList scores = new FloatList();

  for (int i=0; i< _imagesSearch.length; i++) {
    diff_sum = 0;
    PImage p = _target;
    PImage q = _imagesSearch[i];
    p.loadPixels();
    q.loadPixels();

    for (int j=0; j<p.pixels.length; j++) {

      float pc = red(p.pixels[j]);  // because p and q are already greyscale images red/green/blue will all be the same value so any can be used
      float qc = red(q.pixels[j]);

      float diff = abs(pc-qc);
      diff_sum = diff_sum + diff;
    }
    scoresArray[i] = diff_sum;  // store score in array to store record the order
    scores.append(diff_sum);  // record score in list, which will be sorted and used to match to array above

    // score calculation QA
    //println("i            "+i);
    //println("diff_sum     "+diff_sum);
    //println("scores       "+scoresArray[i]);
    //println();
  }

  scores.sort();

  // score sorting and judging QA
  println(scores);
  println();
  println("best match    "+matchIndex(scores.get(0), scoresArray));
  println("second best   "+matchIndex(scores.get(1), scoresArray));
  println("worst         "+matchIndex(scores.get(scores.size()-1), scoresArray));

  // store best and worst image results
  // works by taking the first and last 3 scores from the sorted scores list
  // and using matchIndex method to find their original index from the scoresArray, which is then stored in a global array
  for (int i=0; i<_imagesSearch.length; i++) {

    edgeMatchResults[i] = matchIndex(scores.get(i), scoresArray) +1 ;  // first three of scores list, +1 is because of the target image in the imagesOrig array
    //if (i>=3) brightPixResults[i] = matchIndex(scores.get(scores.size()-(i-2)), scoresArray) +1 ;  // last three of scores list
  }

  println(edgeMatchResults);
}

// -------------------------------------------------------//
//                     OTHER METHODS                      //
//--------------------------------------------------------//

// Method to test whether an image pixel is an edge pixel or not
// used in process to run a basix 3x3 kernel pass where edge pixels are ignored

boolean valid_pixel(int i, int pWidth, int pLength) {

  boolean validP;

  if ( (i < pWidth) || (i%pWidth == 0) || (i%pWidth == pWidth-1) || (i >= pLength-pWidth) ) {
    validP = false;
  } else { 
    validP = true;
  }
  return validP;
}


// DRAW RESULTS
// takes in input array (the results array for a matching run) and an index position in that array ( e.g. 0 = best )
// and then uses size and location inputs to draw a copy from the original image array with a nice dynamic overlay
void imageM(int [] input, int index, int xSize, int x, int y) {

  int position = index+1;

  PImage output = imagesOrig[input[index]].get();  // make copy of image from original and resize
  output.resize(xSize, 0);
  image(output, x, y);

  fill(255, 150);  // draw white background for text box
  stroke(0);
  rect(x, y, output.width/1.6, output.height/10);

  fill(0);  // draw text to describe image position
  textSize(output.height/15);
  text("Match "+position+": Image_"+input[index]+".jpg", x+5, y+14);

  noFill();  // draw black image outline
  stroke(3);
  rect(x, y, output.width, output.height);
}

// DRAW RESULTS
// simply draws the target image with the same overlay used above
PImage imageT(int xSize, int x, int y) {

  PImage output = imagesOrig[0].get();  // make copy of image from original and resize
  output.resize(xSize, 0);
  image(output, x, y);

  fill(255, 150);  // draw white background for text box
  stroke(0);
  rect(x, y, output.width/4, output.height/10);

  fill(0);  // draw text to describe image position
  textSize(output.height/15);
  text("Target", x+5, y+14);

  noFill();  // draw black image outline
  stroke(3);
  rect(x, y, output.width, output.height);

  return output;
}

// Method to search an array for a value and return the index - used to find original index value of best match from scores list
// Note, index is initially set to -1 so if there is no match when used there will be an array out of bounds error
// Also only works on assumption there will only be one match in array, which should true in use cases here

int matchIndex(float target, float [] array) {

  int index = -1;
  for (int i=0; i<array.length; i++) {

    if (target == array[i]) {
      index = i;
    }
  } 
  return index;
}


/*
void brightness_kernel(PImage _target, PImage [] _imagesSearch) {

  float diff_sum = 0;
  float scoresArray [] = new float[_imagesSearch.length];

  FloatList scores = new FloatList();

  for (int i=0; i< _imagesSearch.length; i++) {
    diff_sum = 0;
    PImage p = _target;
    PImage q = _imagesSearch[i];
    p.loadPixels();
    q.loadPixels();

    for (int j=0; j<p.pixels.length; j++) {

      if (valid_pixel(j, p.width, p.pixels.length)) {

        float pTotal = 0;
        float qTotal = 0;
        int pixKey = j-p.width-1;

        for (int k=0; k<3; j++) {
          for (int l=0; l<3; k++) {

            pTotal = pTotal + brightness(p.pixels[pixKey + l]);
            qTotal = qTotal + brightness(q.pixels[pixKey + l]);
          }
          pixKey = pixKey+p.width;
        }  

        float pKernAvg = pTotal/9;
        float qKernAvg = qTotal/9;

        float diff = abs(pKernAvg-qKernAvg);
        diff_sum = diff_sum + diff;
      }
    }
    scoresArray[i] = diff_sum;  // store score in array to store record the order
    scores.append(diff_sum);  // record score in list, which will be sorted and used to match to array above

    // score calculation QA
    println("i            "+i);
    println("diff_sum     "+diff_sum);
    println("scores       "+scoresArray[i]);
    println();
  }

  scores.sort();

  // score sorting and judging QA
  println(scores);
  println();
  println("best match    "+matchIndex(scores.get(0), scoresArray));
  println("second best   "+matchIndex(scores.get(1), scoresArray));
  println("worst         "+matchIndex(scores.get(scores.size()-1), scoresArray));

  // store best and worst image results
  // works by taking the first and last 3 scores from the sorted scores list
  // and using matchIndex method to find their original index from the scoresArray, which is then stored in a global array
  for (int i=0; i<_imagesSearch.length; i++) {

    brightKernResults[i] = matchIndex(scores.get(i), scoresArray) +1 ;  // first three of scores list, +1 is because of the target image in the imagesOrig array
    //if (i>=3) brightPixResults[i] = matchIndex(scores.get(scores.size()-(i-2)), scoresArray) +1 ;  // last three of scores list
  }

  println(brightKernResults);
}
*/