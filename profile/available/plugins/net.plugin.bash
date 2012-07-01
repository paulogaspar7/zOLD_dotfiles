cite about-plugin
about-plugin 'Network tools'

ips ()
{
    about '(local?) ip addresses for this computer'
    group 'net'
	echo '(local?) ip addresses for this computer:'
    ifconfig | grep "inet " | awk '{ print $2 }'
}

down4me ()
{
    about 'checks whether a website is down for you, or everybody'
    param '1: website url'
    example '$ down4me http://www.google.com'
    group 'net'
    curl -s "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
}


ipout ()
{
    about 'Your ip address, as seen outside by the Internet'
    group 'net'
    res=$(dig +short myip.opendns.com @resolver1.opendns.com)
    echo -e "Your ip address, as seen outside by the Internet: ${echo_bold_red} $res ${echo_normal}"
}

