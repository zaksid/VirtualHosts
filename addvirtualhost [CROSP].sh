#!/bin/bash
createHtml() {
        if [ $# -ne 2 ]; then
        echo "Provice two arguments, page path as the first and page name as the second argument";
 	else
echo "" > $1
 echo "<HTML>" >> $1
echo "<HEAD>" >> $1
echo "  <TITLE>" >> $1
echo "  $2" >> $1
echo "  </TITLE>" >> $1
echo "</HEAD>" >> $1
echo "" >> $1
echo "<BODY>" >> $1
echo "<h1> GREAT it WORKS, you are on $2 page now .</h1>" >> $1
echo "</BODY>" >> $1
echo "</HTML>" >> $1
fi

}
echo "#--------- Hello, welcome to the super puper script for creating a new virtual host on your PC All rights reserved CROSP 2015 --------#"
echo "Please enter desired host name for instance  brazzers.com "
while [[ $hostname = "" ]]; do
   read hostname
done
hostdir="/var/www/$hostname/public_html"
echo $hostdir
if [ -d "$hostdir" ]; then
  echo "You already have such host name, please try again"
  exit
fi
sudo mkdir -p $hostdir
sudo chown -R $USER:$USER $hostdir
sudo chmod -R 755 /var/www
echo "Please enter your page name, required for test html page"
while [[ $pagename = "" ]]; do
   read pagename
done
testpage=$hostdir/index.html
createHtml $testpage $pagename
hostconf=/etc/apache2/sites-available/$hostname.conf
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$hostname.conf
echo "Please enter your email address"
while [[ $email = "" ]]; do
   read email
done
sudo sed -i "s/webmaster@localhost/$email/g" $hostconf
sudo sed -i "s/.*DocumentRoot.*/ \tDocumentRoot\ \/var\/www\/$hostname\/public_html /g" $hostconf
sudo sed -i "/ServerAdmin*/a \\\tServerName\ $hostname " $hostconf >> /dev/null
sudo sed -i "/ServerAdmin*/a \\\tServerAlias\ www.$hostname " $hostconf >> /dev/null
sudo a2ensite $hostname.conf
sudo sed -i "1i127.0.0.1\t$hostname" /etc/hosts
sudo service apache2 restart
echo "New virtualhost has been just added, please type in browser $hostname, to check if it works. "
