
final int YCC_DISTANCE_MODE = 0;
final int HSB_DISTANCE_MODE = 1;

PImage getMask(PImage in_img, float t1, float t2, color key_color, int mode)
{
  PImage mask = createImage(in_img.width, in_img.height, ARGB);

  in_img.loadPixels();
  mask.loadPixels();


  for (int i = 0; i < in_img.pixels.length; i++)
  {
    float dist;
    switch(mode) {
      case YCC_DISTANCE_MODE:
        dist = distanceYCC(in_img.pixels[i], key_color);
        break;
      case HSB_DISTANCE_MODE:
        dist = distanceHSB(in_img.pixels[i], key_color);
        break;
      default:
        dist = distanceYCC(in_img.pixels[i], key_color);
        break;
    }
    //println(dist);
    if (dist >= t2) mask.pixels[i] = color(255, 255, 255);
    else if (dist <= t1) mask.pixels[i] = color(0, 0, 0);
    else if (t1 < dist && dist < t2)
    {
      float grad = (sq(dist) - sq(t1))/(sq(t2) - sq(t1));
      mask.pixels[i] = color(grad*255, grad*255, grad*255);
    }
  }
  mask.updatePixels();

  return mask;
}

float alphac(float c) {
  return c/255.0;
}

PImage maskImage(PImage background, PImage original, PImage mask) {
  PImage res = createImage(original.width, original.height, ARGB);

  PImage bg = background.get(0, 0, original.width, original.height);

  res.loadPixels();
  background.loadPixels();
  original.loadPixels();
  mask.loadPixels();

  for (int i = 0; i < original.pixels.length; i++)
  {
    float m = red(mask.pixels[i])/255.0; // bw color

    color orig_color = original.pixels[i];
    color bg_color = bg.pixels[i];

    float red = m * alphac(red(orig_color)) + (1-m)*alphac(red(bg_color));
    float green = m * alphac(green(orig_color)) + (1-m)*alphac(green(bg_color));
    float blue = m * alphac(blue(orig_color)) + (1-m)*alphac(blue(bg_color));

    res.pixels[i] = color(red*255.0, green*255.0, blue*255.0);
  }

  res.updatePixels();

  return res;
}


PImage gaussianBlur(PImage img, float blur)
{
  Mat m = toMat(img);
  m = fix(m);
  
  // Blur only accept odd dimensions
  float h = img.height % 2 == 1 ? img.height : img.height + 1;
  float w = img.width % 2 == 1 ? img.width : img.width + 1;
  Imgproc.GaussianBlur(m, m, new Size(h, w), blur);
  return toPImage(m);
}

PImage chroma(PImage original, PImage background, color key_color, float t1, float t2, boolean apply_blur, float blur, int mode)
{
  PImage mask = getMask(original, t1, t2, key_color, mode);
  if(apply_blur) {
    mask = gaussianBlur(mask, blur);
  }
  PImage chromed = maskImage(background, original, mask);
  return chromed;
}
