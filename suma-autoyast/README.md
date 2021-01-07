# How to create autoyast file using SUMA existing Channels

So if you want to autoinstall a SLES or SLES-for-SAP OS with autoyast and you don't have internet access nor SMT/RMT but you use SUSE Manager then you could use existing channels in SUSE Manager to add them as add_on_products

```
<add_on_products config:type="list">
      <listentry>
        <ask_on_error config:type="boolean">true</ask_on_error>
        <media_url>http://$redhat_management_server/ks/dist/child/$channel_prefix-sle-product-sles_sap15-sp2-updates-x86_64/$distrotree</media_url>
        <name>SLE-Product-SLES_SAP15-SP2-Pool for x86_64</name>
        <product>SUSE Linux Enterprise Server for SAP Applications 15 SP2 x86_64</product>
        <product_dir>/</product_dir>
      </listentry>
      <listentry>
      ...
      </listentry>
</add_on_products>
```

## Magic:

The magic is no-magic.
The prerequisite is you have to use SUSE Manager and cobbler which is a component within SUSE Manager.

The snippet above shows there is a media_url that has some variables.
```http://$redhat_management_server/ks/dist/child/$channel_prefix-sle-product-sles_sap15-sp2-updates-x86_64/$distrotree```

__$redhat_management_server__ - is a built-in variable in SUSE Manager and cobbler. This refers to your SUSE Manager hostname, mostly FQDN. If your SUSE Manager FQDN is not resolvable you can replace it with the IP address of your suse manager host.

__$channel_prefix__ - is just a variable that I use to prefix the label with any additional name. This is optional.
__$distrotree__ - is mandatory and important. This is also a variable and points to the distribution you should have created before hand. In the UI of SUSE Manager -> Systems -> Autoinstallation -> Profiles -> YOUR_PROFILE_NAME -> variables set the var which the value is the name of your distribution: ```distrotree=sles15sp2_x86_64``` 

Once the autoyast xml is created the url will be resolved by cobbler and variables will be resolved through real values as example below:

```<media_url>http://bjsuma.bo2go.home/ks/dist/child/mysap15sp2-dev-sle-product-sles_sap15-sp2-updates-x86_64/sles15sp2_x86_64</media_url>```





