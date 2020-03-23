
int distance_mode = YCC_DISTANCE_MODE;

float t1, t2, blurval;
float max;

boolean apply_chroma;
boolean apply_blur;

void setup_chroma()
{
  
  t1 = 0.01;
  t2 = 0.04;
  max = 1;
  blurval = 10;
  
  apply_chroma = false;
  apply_blur = false;
}

void draw_chroma(PImage orig_image, PImage bg_img, color key_color)
{
  if(apply_chroma) {
    
    
    PImage result = chroma(orig_image, bg_img, key_color, t1, t2, apply_blur, blurval, distance_mode);
    image(result, 0, 0);
  } else image(orig_image, 0, 0);
  
  if(keyPressed) {
    background(0);
    float offset = 0.01;
    if(Character.toLowerCase(key) == 'a' && 0 <= t1 - offset && t1 - offset <= max && t1 - offset <= t2) t1-=offset;
    //else t1 = 0;
    if(Character.toLowerCase(key) == 'd' && 0 <= t1 + offset && t1 + offset <= max && t1 + offset <= t2) t1+=offset;
    //else t1 = t2;
    if(Character.toLowerCase(key) == 'w' && 0 <= t2 + offset && t2 + offset <= max && t1 <= t2 + offset) t2+=offset;
    //else t2 = max;
    if(Character.toLowerCase(key) == 's' && 0 <= t2 - offset && t2 - offset <= max && t1 <= t2 - offset) t2-=offset;
    //else t2 = t1;
    
    t1 = round(t1*100.0)/100.0;
    t2 = round(t2*100.0)/100.0;
  }
  
  fill(255,255,255);
  textSize(14);
  text("Threshold 1 = " + t1 + "         - A    D +\nThreshold 2 = " + t2 + "         - W    S +", 10, height-30);
  
  fill(key_color);
  rect(10, height-80, 20, 20);
  fill(255);
  text("KEYCOLOR [Press left button to select key color]", 40, height - 65);
  
  text("Apply blur [Press B]", 10, height - 100);
  text("LEFT/RIGHT Change background \nUP/DOWN Change foreground", width-260, height - 100);
  text("Toggle webcam [Enter]", width-260, height - 50);
  
  if(distance_mode == YCC_DISTANCE_MODE) fill(255, 0, 0);
  text("[1 - YCC mode]", width-260, height-10);
  fill(255);
  
  if(distance_mode == HSB_DISTANCE_MODE) fill(255, 0, 0);
  text("[2 - HSB mode]", width - 150, height-10);
  fill(255);
}

void keyPressed_chroma()
{
  if(key == ' ') apply_chroma = !apply_chroma;
  if(Character.toLowerCase(key) == 'b') apply_blur = !apply_blur;
  
  if(key == '1')
  {
    distance_mode = YCC_DISTANCE_MODE;
  }
  if(key == '2')
  {
    distance_mode = HSB_DISTANCE_MODE;
  }
}

void mousePressed_chroma()
{
  
}
