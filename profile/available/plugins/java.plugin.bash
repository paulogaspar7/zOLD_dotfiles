cite about-plugin
about-plugin 'Java and JAR helper functions'


function jadall {
	about 'decompiles all subdirectories of current directory using JAD'
	group 'java'

	jad -o -r -sjava -d_jadout './**/*.class'
	$EDITOR _jadout
}


function jar_manifest {
  about "extracts the specified JAR file's MANIFEST file and prints it to stdout"
  group 'java'
  param '1: JAR file to extract the MANIFEST from'
  example 'jar_manifest lib/foo.jar'

  unzip -c $1 META-INF/MANIFEST.MF
}
