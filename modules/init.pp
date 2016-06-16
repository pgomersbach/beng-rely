# 
 case $hostname {
   /^(sjefkeschelm)/ : {
     notice ( "Cron Job: ${hostname} - Adding 'Daily  Git clone jobe." )
 cron::job { 'Gitclone':
  minute      => '40',
  hour        => '2',
  date        => '*',
  month       => '*',
  weekday     => '*',
  user        => 'root',
  command     => 'env GIT_SSL_NO_VERIFY=true git clone  https://github.com/relybv/beng-rely.git /etc/puppet',
  environment => [ 'MAILTO=root', 'PATH="/usr/bin:/bin"', ],
}  
}
cp -ru ~/beng-rely /var/www/html/
