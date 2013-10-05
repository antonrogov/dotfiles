function devise-slim() {
  rails generate devise:views -e erb
  for i in `find app/views/devise -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done
  for i in `find app/views/devise -name '*.haml'` ; do haml2slim $i ${i%haml}slim ; rm $i ; done
}
