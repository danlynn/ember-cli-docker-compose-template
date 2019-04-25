
::#Note: Do not rename this script to "server" because 
::# it will conflict with 'ember serve' startup processing.

echo off

docker-compose up %*

