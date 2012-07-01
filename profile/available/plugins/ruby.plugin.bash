cite about-plugin
about-plugin 'Ruby related functions'


pri ()
{
    about 'display information about Ruby classes, modules, or methods, in Preview'
    param '1: Ruby method, module, or class'
    example '$ pri Array'
    group 'base'
    ri -T "${1}" | open -f -a $PREVIEW
}


function remove_gem {
  about 'removes installed gem'
  param '1: installed gem name'
  group 'ruby'

  gem list | grep $1 | awk '{ print $1; }' | xargs sudo gem uninstall
}
