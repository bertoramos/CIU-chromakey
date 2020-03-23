
PVector rgb2YCbCr(color rgb)
{
  float r, g, b;
  r = red(rgb)/255.0;
  g = green(rgb)/255.0;
  b = blue(rgb)/255.0;
  float kr = 0.5, kg = 0.5, kb = 0.5;
  
  float Y = kr*r + kg*g + kb*b;
  float Pb = 0.5*((b - Y)/(1-kb));
  float Pr = 0.5*((r - Y)/(1 - kr));
  
  return new PVector(Y, Pb, Pr);
}

color YCbCr2rgb(PVector c)
{
  float kr = 0.5, kg = 0.5, kb = 0.5;
  
  float Y, Pb, Pr;
  float r, g, b;
  
  Y = c.x;
  Pb = c.y;
  Pr = c.z;
  
  b = (2*Pb*(1.0 - kb)) + Y;
  r = (2*Pr*(1.0 - kr)) + Y;
  g = (Y - kr*r - kb*b)/kg;
  
  return color(r*255,g*255,b*255);
}

float distanceYCC(color rgb1, color rgb2) {
  PVector ycc1, ycc2;
  ycc1 = rgb2YCbCr(rgb1);
  ycc2 = rgb2YCbCr(rgb2);
  return sq((ycc1.y - ycc2.y)) + sq(ycc1.z - ycc2.z);
}

float distanceHSB(color rgb1, color rgb2) {
  float hue_dist = min(abs(hue(rgb1) - hue(rgb2)), 360-abs(hue(rgb1) - hue(rgb2)));
  float sat_dist = abs(saturation(rgb1) - saturation(rgb2));
  
  return (sq(hue_dist) + sq(sat_dist))/(sq(180) + sq(255));
}
