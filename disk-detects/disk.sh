#!/bin/bash

pci_devices=(`ls -la /dev/disk/by-path/ | grep -E "d[a-z]$" | awk '$0 ~ / pci/ {print $9}'`)
echo ${pci_devices[*]}

for i in ${pci_devices[*]}
do
        disks+=(`ls -la /dev/disk/by-path/${i} | awk '{print substr($0,length($0)-2,3)}'`)
done

echo ${disks[*]}

for x in ${disks[*]}
do
        disk_sizes+=(`lsblk /dev/${x} | awk '$0 ~ / disk/ {print $4}'`)
done

echo ${disk_sizes[*]}

temp="/tmp/profile/temp.xml"
autoyastfile="/tmp/profile/autoinst.xml"
autoyastnewfile="/tmp/profile/modified.xml"

cat <<EOF > ${temp}
<ask>                                                  
    <path>partitioning,0,device</path>
    <dialog config:type="integer">0</dialog>                                                                                                              
    <element config:type="integer">5</element>                                                                                                            
    <frametitle>root disk select</frametitle>                                                                                                                  
    <question>Select root disk device</question>                                                                                                         
    <stage>initial</stage>                                                                                                                                
    <title/>
    <selection config:type="list">
EOF

for index in ${!pci_devices[*]} 
do 
        echo -e "        <entry>" >> ${temp}
        echo -e "            <value>/dev/disk/by-path/${pci_devices[$index]}</value>" >> ${temp}
        printf "             <label>%s /dev/%s %s</label>\n" ${pci_devices[$index]} ${disks[$index]} ${disk_sizes[$index]} >> ${temp}
        echo -e "        </entry>" >> ${temp}
done

cat <<EOF >> ${temp}
    </selection>
    <filename>disk.sh</filename>
    <environment config:type="boolean">true</environment>
</ask>
EOF

cat ${autoyastfile} | sed $'/<\/ask-list>/{e cat /tmp/profile/temp.xml \n}' >> ${autoyastnewfile}
