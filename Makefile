pack: ansible/files/GeoLite2-City.mmdb
	packer build debian10.json

clean:
	rm -rf output-virtualbox-iso
