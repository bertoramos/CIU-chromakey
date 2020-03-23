
import cvimage.*;
import org.opencv.core.*;
import org.opencv.imgproc.*;

import java.nio.*;
import java.awt.image.*;

//Copia unsigned byte Mat a color CVImage
void cpMat2CVImage(Mat in_mat,CVImage out_img, int img_width, int img_height)
{ 
  byte[] data8 = new byte[img_width*img_height];
  
  out_img.loadPixels();
  in_mat.get(0, 0, data8);
  
  // Cada columna
  for (int x = 0; x < img_width; x++) {
    // Cada fila
    for (int y = 0; y < img_height; y++) {
      // Posición en el vector 1D
      int loc = x + y * img_width;
      //Conversión del valor a unsigned basado en 
      //https://stackoverflow.com/questions/4266756/can-we-make-unsigned-byte-in-java
      int val = data8[loc] & 0xFF;
      //Copia a CVImage
      out_img.pixels[loc] = color(val);
    }
  }
  out_img.updatePixels();
}

// Convert PImage (ARGB) to Mat (CvType = CV_8UC4)
Mat toMat(PImage image) {
  int w = image.width;
  int h = image.height;
  
  Mat mat = new Mat(h, w, CvType.CV_8UC4);
  byte[] data8 = new byte[w*h*4];
  int[] data32 = new int[w*h];
  arrayCopy(image.pixels, data32);
  
  ByteBuffer bBuf = ByteBuffer.allocate(w*h*4);
  IntBuffer iBuf = bBuf.asIntBuffer();
  iBuf.put(data32);
  bBuf.get(data8);
  mat.put(0, 0, data8);
  
  return mat;
}

Mat fix(Mat mat) {
  /*
    Fix mat transformation error
  */
  Mat m2 = new Mat();
  Imgproc.cvtColor(mat, m2, Imgproc.COLOR_BGR2BGRA);
  return m2;
}

// Convert Mat (CvType=CV_8UC4) to PImage (ARGB)
PImage toPImage(Mat mat) {
  int w = mat.width();
  int h = mat.height();
  
  PImage image = createImage(w, h, ARGB);
  byte[] data8 = new byte[w*h*4];
  int[] data32 = new int[w*h];
  mat.get(0, 0, data8);
  ByteBuffer.wrap(data8).asIntBuffer().get(data32);
  arrayCopy(data32, image.pixels);
  
  return image;
}
