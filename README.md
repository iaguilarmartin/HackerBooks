# HackerBooks
A book reader for iPhone &amp; iPad. Books are stored in PDF format and provided by a remote JSON file

A very simple universal app that contains three ViewControllers:

* **LibraryViewController**: To display the collection of books inside a UITableViewController. 
* **BookViewController**: To display detailed information of each book.
* **PDFViewController**: A ViewController with a WebView control that displays the PDF file associated with the selected book.

The JSON file that contains the model and the image and PDF files of each book are stored inside the documents directory of the application SandBox in order to download them just once.

## Respuestas a las preguntas planteadas en la práctica:

1. A parte de con **isKindOfClass** ¿En qué otros modos podemos trabajar? ¿is, as?

	*Is funciona igual a isKindOfClass. La diferencia es que el primero funciona con cualquier clase de swift mientras que el segundo solo funciona con clases que hereden de NSObject.*

	*As, sin embargo, en vez de preguntar por el tipo intentaría directamente hacer la conversión devolviendo el objeto en caso de exito o nil si falla. En ambos casos el resultado quedaría empaquetado dentro de un opcional*

2. ¿Donde se guardarían las imagenes y PDFs de los libros?

	*Estos archivos deben guardarse dentro del SandBox de la aplicación. Podrian guardarse en una carpeta temporal como temp o cache o bien en la carpeta documents. La diferencia es que en las primeras los ficheros se borrarian en el caso de que el sistema necesitara más espacio. Yo he optado por la opción de guardarlo en la carpeta documents.*

3. ¿Como se podría persistir la información de los libros favoritos? ¿Hay más de una forma de hacerlo?

	*La información de los libros favoritos podria guardarse en un fichero dentro del SandBox de la app, en el NSUserDefaults como un array o bien usando CoreData. Yo he optado por la opción de NSUserDefaults ya que me parecía lo más rápido y cómodo*

4. ¿Como enviarías información de un Book a Library cuando se ha cambiado su estado de favorito? ¿Se te ocurre más de una forma de hacerlo? ¿Cual te parece la mejor?

	*La mejor forma de notificar a la libreria de que un libro ha cambiado es utilizando el protocolo del delegado. La otra forma de hacerlo es usando una notificación. Lo primero es mejor porque se informa directamente al interesado. Mandar una notificación sería como matar moscas a cañonazos*

5. ¿Explica porque el uso de la función **reloadData** no es una aberracion desde el punto de vista de rendimiento? ¿Habría otra forma de hacerlo? ¿Cuando crees que vale la pena usarlo?

	*La función reloadData no es una aberración porque unicamente cargaría la información de las celdas que están en ese momento visibles en pantalla y como mucho tambien justamente las inmediatas por arriba y por abajo. Tambien se podria hacer utilizando la función reloadSections:withRowAnimation: para recargar la sección de favoritoas. Esto, en mi opinion, sería más acertado en nuestro caso. El reloadData sería más propio cuando los cambios en la tabla se producen en un numero mayor de elementos y de distintas secciones.*

6. Cuando el usario selecciona un nuevo libro el controlador de los PDFs debe ser informado ¿Como lo harías?

	*En este caso no queda más remedio que hacer uso de las notificaciones puesto que desde el controlador de los PDFs no tenemos acceso al controlador de la libreria desde el cual se ha hecho el cambio de selección. Además hay que tener en cuenta que cada controlador solo puede tener un delegado y el controlador de la libreria ya tiene como delegado al controlador de libros*