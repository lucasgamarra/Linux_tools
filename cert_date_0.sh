#!/bin/bash
echo "This script will check certificate expiration dates"
echo
echo "Checking RHV-M Certificates..."
echo "=================================================";
ca=`openssl x509 -in /etc/pki/ovirt-engine/ca.pem -noout -enddate| cut -d= -f2`
apache=`openssl x509 -in /etc/pki/ovirt-engine/certs/apache.cer -noout -enddate| cut -d= -f2`
engine=`openssl x509 -in /etc/pki/ovirt-engine/certs/engine.cer -noout -enddate| cut -d= -f2`
qemu=`openssl x509 -in /etc/pki/ovirt-engine/qemu-ca.pem -noout -enddate| cut -d= -f2`
wsp=`openssl x509 -in /etc/pki/ovirt-engine/certs/websocket-proxy.cer -noout -enddate| cut -d= -f2`
jboss=`openssl x509 -in /etc/pki/ovirt-engine/certs/jboss.cer -noout -enddate| cut -d= -f2`
ovn=`openssl x509 -in /etc/pki/ovirt-engine/certs/ovirt-provider-ovn.cer -noout -enddate| cut -d= -f2`
ovnnbd=`openssl x509 -in /etc/pki/ovirt-engine/certs/ovn-ndb.cer -noout -enddate| cut -d= -f2`
ovnsbd=`openssl x509 -in /etc/pki/ovirt-engine/certs/ovn-sdb.cer -noout -enddate| cut -d= -f2`
vmhelper=`openssl x509 -in /etc/pki/ovirt-engine/certs/vmconsole-proxy-helper.cer -noout -enddate| cut -d= -f2`
vmhost=`openssl x509 -in /etc/pki/ovirt-engine/certs/vmconsole-proxy-host.cer -noout -enddate| cut -d= -f2`
vmuser=`openssl x509 -in /etc/pki/ovirt-engine/certs/vmconsole-proxy-user.cer -noout -enddate| cut -d= -f2`



echo "  /etc/pki/ovirt-engine/ca.pem:                          $ca"
echo "  /etc/pki/ovirt-engine/certs/apache.cer:                $apache"
echo "  /etc/pki/ovirt-engine/certs/engine.cer:                $engine"
echo "  /etc/pki/ovirt-engine/qemu-ca.pem                      $qemu"
echo "  /etc/pki/ovirt-engine/certs/websocket-proxy.cer        $wsp"
echo "  /etc/pki/ovirt-engine/certs/jboss.cer                  $jboss"
echo "  /etc/pki/ovirt-engine/certs/ovirt-provider-ovn         $ovn"
echo "  /etc/pki/ovirt-engine/certs/ovn-ndb.cer                $ovnnbd" 
echo "  /etc/pki/ovirt-engine/certs/ovn-sdb.cer                $ovnsbd"
echo "  /etc/pki/ovirt-engine/certs/vmconsole-proxy-helper.cer $vmhelper"
echo "  /etc/pki/ovirt-engine/certs/vmconsole-proxy-host.cer   $vmhost"
echo "  /etc/pki/ovirt-engine/certs/vmconsole-proxy-user.cer   $vmuser"

echo

hosts=`/usr/share/ovirt-engine/dbscripts/engine-psql.sh -t -c "select vds_name from vds;" | xargs`
echo
echo "Checking Host Certificates..."
echo

for i in $hosts;
        do echo "Host: $i";
        echo "=================================================";
        vdsm=`ssh -i  /etc/pki/ovirt-engine/keys/engine_id_rsa root@${i} 'openssl x509 -in /etc/pki/vdsm/certs/vdsmcert.pem -noout -enddate' | cut -d= -f2`
        echo -e "  /etc/pki/vdsm/certs/vdsmcert.pem:              $vdsm";

        spice=`ssh -i  /etc/pki/ovirt-engine/keys/engine_id_rsa root@${i} 'openssl x509 -in /etc/pki/vdsm/libvirt-spice/server-cert.pem -noout -enddate' | cut -d= -f2`
        echo -e "  /etc/pki/vdsm/libvirt-spice/server-cert.pem:   $spice";

        vnc=`ssh -i  /etc/pki/ovirt-engine/keys/engine_id_rsa root@${i} 'openssl x509 -in /etc/pki/vdsm/libvirt-vnc/server-cert.pem -noout -enddate' | cut -d= -f2`
        echo -e "  /etc/pki/vdsm/libvirt-vnc/server-cert.pem:     $vnc";

        libvirt=`ssh -i  /etc/pki/ovirt-engine/keys/engine_id_rsa root@${i} 'openssl x509 -in /etc/pki/libvirt/clientcert.pem -noout -enddate' | cut -d= -f2`
        echo -e "  /etc/pki/libvirt/clientcert.pem:               $libvirt";

	migrate=`ssh -i  /etc/pki/ovirt-engine/keys/engine_id_rsa root@${i} 'openssl x509 -in /etc/pki/vdsm/libvirt-migrate/server-cert.pem -noout -enddate' | cut -d= -f2`
	echo -e "  /etc/pki/vdsm/libvirt-migrate/server-cert.pem: $migrate";

        echo;
        echo;
done
