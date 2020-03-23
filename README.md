
## Captura y procesamiento de imagen y vídeo

<center><img src="croma.gif" width="640" height="600" alt="Croma"/></center>


###### Alberto Ramos Sánchez

En esta práctica se ha desarrollado el prototipo de un croma, donde se puede seleccionar un color de fondo y tiene dos modos: uno de ejemplo con videos y otro utilizando la webcam.

### Manual de uso

- Botón izquierdo para seleccionar el color clave.
- A - D : cambiar *threshold* 1.
- W - S : cambiar *threshold* 2.
- Flecha izquierda - derecha : cambiar *background*.
- Flecha superior - inferior : cambiar *foreground*.
- b : Aplicar *blur filter*.
- Enter : encender/apagar webcam

### Técnica chroma key

La técnica de [chroma key](https://es.wikipedia.org/wiki/Croma) o clave de color, consiste en la sustitución de un color en un área de una imagen por otra imagen o vídeo. El color (*color key*) que va a ser sustituido es elegido por el usuario

### Implementación

Para la implementación de está técnica utilizamos dos imagenes: una de fondo, que sustituirá a la imagen original con un fondo de color uniforme (vídeos de prueba o la imagen de la webcam).

Para detectar el color uniforme en una imagen, creamos una máscara, que diferenciará entre los píxeles que se tomarán de la imagen original y los que se tomarán de la imagen de fondo. Esto se decide según la distancia a la que estén los colores al color elegido como clave.

![Fórmula de Creación de imagen](https://latex.codecogs.com/gif.latex?P_%7Bfinal%7D%28j%2Ck%29%3Dm%28j%2Ck%29*P_%7Boriginal%7D%28j%2Ck%29&plus;%281-m%28j%2Ck%29%29*P_%7Bscene%7D%28j%2Ck%29)

Como vemos las zonas donde la máscara es blanca, tomamos el color de la imagen original, y donde es negra la de fondo (donde estarán los colores cercanos al color clave).

#### Creación de la máscara

Para crear la cáscara, aplicamos la siguiente ecuación:

![Máscara](https://latex.codecogs.com/gif.latex?m%28j%2Ck%29%3D%5Cleft%5C%7B%5Cbegin%7Bmatrix%7D%201%20%26%20if%20d%28j%2Ck%29%3Et_2%20%5C%5C%200%20%26%20if%20d%28j%2Ck%29%3Ct_1%20%5C%5C%20%5Cfrac%7Bd%5E2%20%28j%2Ck%29-t_1%5E2%7D%7Bt_2%5E2-t_1%5E2%7D%20%26%20if%20t_1%3Cd%28j%2Ck%29%3Ct_2%20%5Cend%7Bmatrix%7D%5Cright.)

Los valores *t1* y *t2*, son dos umbrales elegidos a mano por el usuario.

##### Distancia entre colores en el espacio de color YCrCb

Para medir las distancias entre colores, es necesario la transformación desde el espacio RGB a otro que si acepte distancias euclídeas. Como processing no posee funciones para la transformación del espacio RGB a YCrCb, aplicamos la transformación utilizando las siguientes ecuaciones:

![RGB2YCC](https://wikimedia.org/api/rest_v1/media/math/render/svg/9a12261ec13667ed8503c2febbbc3600c869a34e)

La transformación inversa es trivial.

Finalmente, la distancia entre dos colores en YCbCr está definida por:

![Distancia YCC](https://latex.codecogs.com/gif.latex?d%5E2%28j%2Ck%29%20%3D%20%28Cb%28j%2Ck%29%20-%20Cb_%7Bref%7D%28j%2Ck%29%29%5E2%20&plus;%20%28Cr%28j%2Ck%29%20-%20Cr_%7Bref%7D%28j%2Ck%29%29%5E2)

 > __*Todas estás ecuaciones requieren que sean adaptadas al rango rgb 0-255 que utiliza Processing*__

##### Distancia entre colores en el espacio de color HSV

Buscando una mejora, pasamos a otro espacio de colores donde medir las distancias :*HSV*. La utilización de este espacio de colores supone una mejora frente a YCbCr, pues soluciona ciertos errores producidos con reflejos y colores blancos.

Processing permite la transformación mediante las funciones *hue, saturation y brightness*. La medida de distancia entre colores es solo aplicada a la saturación y matiz, pues considerando que el valor está al 100% podemos diferenciar los colores. Para medir las distancias, hay que considerar que el matiz tiene un valor angular, donde los 0º y 359º son cercanos.
La distancia, entre matices de dos colores, por tanto viene definida por:

![Distacia hue](https://latex.codecogs.com/gif.latex?dist_%7Bhue%7D%20%3D%20min%5C%7B%7Chue_%7Bcolor1%7D%20-%20hue_%7Bcolor2%7D%7C%2C%20360%5E%7B%5Ccirc%7D%20-%20%7Chue_%7Bcolor1%7D%20-%20hue_%7Bcolor2%7D%7C%20%5C%7D)

La distancia entre saturaciones, al no ser circular, se calcula como:

![Distancia saturation](https://latex.codecogs.com/gif.latex?dist_%7Bsaturation%7D%20%3D%20%7Csaturation_%7Bcolor_1%7D%20-%20saturation_%7Bcolor_2%7D%7C)

Finalmente, combinamos ambas distancias, teniendo en cuenta que el máximo de la distancia entre *hue* va a ser 180º y la de saturación 255:

![Distancia HSV](https://latex.codecogs.com/gif.latex?%5Cfrac%7Bdist_%7Bhue%7D%5E2%20&plus;%20dist_%7Bsaturation%7D%5E2%7D%7B180%5E2%20&plus;%20255%5E2%7D)

HSB mode             |  YCbCr mode
:-------------------------:|:-------------------------:
![hsb](hsb.gif)  |  ![ycc](ycc.gif)

##### Mejora de la máscara de selección

Para mejorar el resultado del croma, se le puede aplicar un filtro gaussiano, para difuminar las transiciones de negro a blanco. Aunque, el procesamiento con opencv realentiza el programa y, por lo tanto, no podemos percibir su efecto correctamente.


### Referencias

- Chroma key: https://en.wikipedia.org/wiki/Chroma_key
- Run MATLAB Image Processing Algorithms on Raspberry Pi and NVIDIA Jetson : https://www.mathworks.com/company/newsletters/articles/run-matlab-image-processing-algorithms-on-raspberry-pi-and-nvidia-jetson.html
- YCbCr color model : https://es.wikipedia.org/wiki/YCbCr
- HSV color model : https://en.wikipedia.org/wiki/HSL_and_HSV


- Videos : https://www.pexels.com
- OpenCV cv::Mat <==> Processing PImage Converter Functions : https://gist.github.com/Spaxe/3543f0005e9f8f3c4dc5
