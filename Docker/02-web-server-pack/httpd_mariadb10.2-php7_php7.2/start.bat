@ECHO OFF
docker run --name myXampp -p 41061:22 -p 8082:80 -d -v ".server-data":/www -v ".server-conf":/opt/lampp/apache2/conf.d tomsik68/xampp:8
pause