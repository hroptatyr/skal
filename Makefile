PYTHON = ~/usr/intel/intelpython/python3.9/bin/python

all: .canonical skal.rdf index.html

.canonical: skal.owl.ttl
	rapper -c -i turtle $< \
	&& touch $@

skal.rdf: skal.owl.ttl .canonical
	rapper -i turtle -o rdfxml-abbrev $< \
	| mawk 'NR==2{print "<?xml-stylesheet type=\"text/xsl\" href=\"owl2html.xslt.xml\"?>"}1' \
	> $@.t && mv $@.t $@

index.html: skal.owl.ttl .canonical
	$(PYTHON) -m pylode -c true -o $@ $< \
	|| $(RM) $@
	sed -i 's/ns1:0000/orcid:0000/' $@
