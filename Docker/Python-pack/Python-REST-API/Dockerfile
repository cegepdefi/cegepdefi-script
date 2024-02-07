# la imagen y version que usaremos
FROM python:3.10
# el puerto
EXPOSE 5000
# el directorio de trabajo
WORKDIR /app
# instalar flask
RUN pip install flask
# copiar nuestros archivos en el container (lugar del archivo en pc local, lugar en container donde se copiara)
COPY . .
# executar nuestro archivo python que tiene la app.py REST API
CMD [ "flask", "run", "--host", "0.0.0.0" ]

# executar este archivo en terminal
# 1 → ponerse en el mismo path que este archivo
# ejemplo con includio las commillas por si el path tiene espacios: 
# cd "c:\noSe\LugarDeEsteArchivo"
# 2 → crear el contenedor executando el archivo
# ejemplo : docker build -t DaleUnNombreAlContenedor .
# ejemplo : docker build -t rest-apis-flask-python .