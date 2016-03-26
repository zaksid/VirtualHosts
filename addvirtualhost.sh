#!/bin/bash

createHtml() {
    echo -n "" > $1
    echo "<!DOCTYPE html>" >> $1
    echo "<html lang=\"en\">" >> $1
    echo "<head>" >> $1
    echo "  <meta charset=\"utf-8\">" >> $1
    echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" >> $1
    echo "  <title>Test page</title>" >> $1
    echo "  <link rel=\"stylesheet\" href=\"http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css\">" >> $1
    echo "  <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js\"></script>" >> $1
    echo "  <script src=\"http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js\"></script>" >> $1
    echo "</head>" >> $1
    echo "<body>" >> $1
    echo "  <section class=\"container-fluid\">" >> $1
    echo "  <h1>Works with Bootstrap</h1>" >> $1
    echo "  <button class=\"btn btn-success\"><span class=\"glyphicon glyphicon-ok\"></span> Success</button>" >> $1
    echo "</section>" >> $1
    echo "</body>" >> $1
    echo "</html>" >> $1
}

echo "All rights reserved CROSP 2015. Modified by zaksid 2015"
echo "-------------------------------------------------------"
echo -n "Entre host name i.e. brazzers.com > "

while [[ $hostname = "" ]]; do
   read hostname
done

hostdir="/var/www/$hostname/public_html"

echo "Path created $hostdir"

if [ -d "$hostdir" ]; then
    echo "You already have such host name, please try again"
    exit
fi

sudo mkdir -p $hostdir
sudo chown -R $USER:$USER $hostdir
sudo chmod -R 755 /var/www

testpage=$hostdir/index.html

createHtml $testpage

hostconf=/etc/apache2/sites-available/$hostname.conf
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$hostname.conf

email="thezaksid@gmail.com"
sudo sed -i "s/webmaster@localhost/$email/g" $hostconf
sudo sed -i "s/.*DocumentRoot.*/ \tDocumentRoot\ \/var\/www\/$hostname\/public_html /g" $hostconf
sudo sed -i "/ServerAdmin*/a \\\tServerName\ $hostname" $hostconf >> /dev/null
sudo sed -i "/ServerAdmin*/a \\\tServerAlias\ www.$hostname" $hostconf >> /dev/null
sudo a2ensite $hostname.conf
sudo sed -i "1i127.0.0.1\t$hostname" /etc/hosts

sudo service apache2 restart
echo "New virtualhost has been just added, please type in browser $hostname, to check if it works."
