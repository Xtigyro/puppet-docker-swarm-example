# Using Puppet and HashiCorp Consul to Launch a Docker Swarm Cluster

[Docker Swarm](https://docs.docker.com/swarm/) is part of the official
Docker orchestration effort, and allows for managing containers across a
fleet of hosts rather than just on a single host.

The [Puppet Docker module](https://forge.puppetlabs.com/garethr/docker)
supports installing and managing Docker, and running individual Docker
containers. Given Swarm is packaged as containers, that means we can
install a Swarm cluster using Puppet.

Swarm supports a number of [discovery
backends](http://docs.docker.com/swarm/discovery/). For this example
I'll be using [Consul](https://www.consul.io/), again all managed by
Puppet.

## Usage

    vagrant up --provider virtualbox

This will launch 2 virtual machines, install Consul and register a
cluster, install Docker and Swarm and then establish the swarm.

You can access the swarm using a Docker client, either from you local
machine or from one of the virtual machines. For instance:

    docker -H tcp://10.20.3.11:3000 info

If you don't have Docker installed locally you can run the above command
from one of the virtual machines using:

    vagrant ssh swarm-1 -c "docker -H tcp://localhost:3000 info"

This should print something like:

    Containers: 5
    Running: 5
    Paused: 0
    Stopped: 0
    Images: 4
    Server Version: swarm/1.2.9
    Role: primary
    Strategy: spread
    Filters: health, port, containerslots, dependency, affinity, constraint, whitelist
    Nodes: 2
    swarm-1: 10.20.3.11:2375
    └ ID: LBE4:VBSS:MLT3:S2BG:P7BP:H2I3:E2NM:DTNR:Z3V5:VZG7:H6G2:KFIW|10.20.3.11:2375
    └ Status: Healthy
    └ Containers: 3 (3 Running, 0 Paused, 0 Stopped)
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 1.01 GiB
    └ Labels: kernelversion=4.15.0-48-generic, operatingsystem=Ubuntu 18.04.2 LTS, ostype=linux, storagedriver=overlay2
    └ UpdatedAt: 2019-05-12T17:38:13Z
    └ ServerVersion: 18.09.6
    swarm-2: 10.20.3.12:2375
    └ ID: RVWC:SZWS:GDUP:3AQ3:DN4O:P3JB:RIXZ:7MLY:HJFB:JDVL:GITS:TQDZ|10.20.3.12:2375
    └ Status: Healthy
    └ Containers: 2 (2 Running, 0 Paused, 0 Stopped)
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 1.01 GiB
    └ Labels: kernelversion=4.15.0-48-generic, operatingsystem=Ubuntu 18.04.2 LTS, ostype=linux, storagedriver=overlay2
    └ UpdatedAt: 2019-05-12T17:37:44Z
    └ ServerVersion: 18.09.6
    Plugins:
    Volume: 
    Network: 
    Log: 
    Swarm: 
    NodeID: 
    Is Manager: false
    Node Address: 
    Kernel Version: 4.15.0-48-generic
    Operating System: linux
    Architecture: amd64
    CPUs: 4
    Total Memory: 2.021GiB
    Name: 008d3394a360
    Docker Root Dir: 
    Debug Mode (client): false
    Debug Mode (server): false
    Experimental: false
    Live Restore Enabled: false


## Growing the cluster

We can also automatically scale the cluster by launching additional
virtual machines.

    INSTANCES=4 vagrant up --provider virtualbox

This will give us a total of 4 virtual machines, 2 new ones and the 2
existing machines we already launched. Once the machines have launched,
you should be able to run the above commands again - this time you'll get
something like:

    Containers: 9
    Running: 9
    Paused: 0
    Stopped: 0
    Images: 8
    Server Version: swarm/1.2.9
    Role: primary
    Strategy: spread
    Filters: health, port, containerslots, dependency, affinity, constraint, whitelist
    Nodes: 4
    swarm-1: 10.20.3.11:2375
    └ ID: LBE4:VBSS:MLT3:S2BG:P7BP:H2I3:E2NM:DTNR:Z3V5:VZG7:H6G2:KFIW|10.20.3.11:2375
    └ Status: Healthy
    └ Containers: 3 (3 Running, 0 Paused, 0 Stopped)
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 1.01 GiB
    └ Labels: kernelversion=4.15.0-48-generic, operatingsystem=Ubuntu 18.04.2 LTS, ostype=linux, storagedriver=overlay2
    └ UpdatedAt: 2019-05-12T17:46:50Z
    └ ServerVersion: 18.09.6
    swarm-2: 10.20.3.12:2375
    └ ID: RVWC:SZWS:GDUP:3AQ3:DN4O:P3JB:RIXZ:7MLY:HJFB:JDVL:GITS:TQDZ|10.20.3.12:2375
    └ Status: Healthy
    └ Containers: 2 (2 Running, 0 Paused, 0 Stopped)
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 1.01 GiB
    └ Labels: kernelversion=4.15.0-48-generic, operatingsystem=Ubuntu 18.04.2 LTS, ostype=linux, storagedriver=overlay2
    └ UpdatedAt: 2019-05-12T17:46:40Z
    └ ServerVersion: 18.09.6
    swarm-3: 10.20.3.13:2375
    └ ID: JHQY:UWZB:4GDJ:7D46:W7AK:FIDO:O6YD:2W77:JYZF:NH5T:DNUV:BPNH|10.20.3.13:2375
    └ Status: Healthy
    └ Containers: 2 (2 Running, 0 Paused, 0 Stopped)
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 1.01 GiB
    └ Labels: kernelversion=4.15.0-48-generic, operatingsystem=Ubuntu 18.04.2 LTS, ostype=linux, storagedriver=overlay2
    └ UpdatedAt: 2019-05-12T17:46:34Z
    └ ServerVersion: 18.09.6
    swarm-4: 10.20.3.14:2375
    └ ID: 5GG4:FSNF:LLHZ:KMWI:5YDX:FG3F:4WHR:KJ7X:SILJ:3VRT:DG3K:RK2L|10.20.3.14:2375
    └ Status: Healthy
    └ Containers: 2 (2 Running, 0 Paused, 0 Stopped)
    └ Reserved CPUs: 0 / 2
    └ Reserved Memory: 0 B / 1.01 GiB
    └ Labels: kernelversion=4.15.0-48-generic, operatingsystem=Ubuntu 18.04.2 LTS, ostype=linux, storagedriver=overlay2
    └ UpdatedAt: 2019-05-12T17:47:15Z
    └ ServerVersion: 18.09.6
    Plugins:
    Volume: 
    Network: 
    Log: 
    Swarm: 
    NodeID: 
    Is Manager: false
    Node Address: 
    Kernel Version: 4.15.0-48-generic
    Operating System: linux
    Architecture: amd64
    CPUs: 8
    Total Memory: 4.041GiB
    Name: 008d3394a360
    Docker Root Dir: 
    Debug Mode (client): false
    Debug Mode (server): false
    Experimental: false
    Live Restore Enabled: false



## The Tour

Quick recap on Consul API - create two new services:

    # docker run -d -p 8080:8080 --name="hello" mrbarker/python-flask-hello
    # docker run -d -p 8081:8080 -p 8443:8443 --name="hello2" mrbarker/python-flask-hello

    # docker logs registrator

This demonstrates the automatic registration of services into Consul. The
following shows the registration and the subsequent DNS requests.

    # curl localhost:8500/v1/catalog/services
    {"consul":[],"python-flask-hello":[],"python-flask-hello-8080":[],"python-flask-hello-8443":[],"swarm":[]}

    # curl localhost:8500/v1/catalog/nodes
    [{"Node":"swarm-1","Address":"10.20.3.11"}]

Check DNS by appending .service.consul to the service names:

    # dig python-flask-hello-8443.service.consul +short
    172.17.0.5
    # dig python-flask-hello-8443.service.consul -t srv +short
    1 1 8443 swarm-1.node.dc1.consul.
    # dig python-flask-hello-8443.service.consul -t srv +short

Reverse DNS - (XXX double check long vs. short name returned):

    # dig swarm-1.node.dc1.consul +short
    10.20.3.11
    # dig -x 10.20.3.11 +short
    swarm-1.


## Implementation details

The example uses the Docker module to launch the Swarm containers. 

First, we run the main Swarm container on all hosts:

```puppet
::docker::run { 'swarm':
  image   => 'swarm',
  command => "join --addr=${facts['networking']['interfaces']['enp0s8']['ip']}:2375 consul://${facts['networking']['interfaces']['enp0s8']['ip']}:8500/swarm_nodes",
}
```

Then, on one host we run the Swarm Manager:

```puppet
::docker::run { 'swarm-manager':
  image   => 'swarm',
  ports   => '3000:2375',
  command => "manage consul://${facts['networking']['interfaces']['enp0s8']['ip']}:8500/swarm_nodes",
  require => Docker::Run['swarm'],
}
```

Consul is managed by the excellent [Consul module](https://github.com/solarkennedy) from [Kyle
Anderson](https://github.com/solarkennedy). Much of the Consul configuration is in the hiera data, for example:

```yaml
consul::config_hash:
  data_dir: '/opt/consul'
  client_addr: '0.0.0.0'
  bind_addr: "%{networking.interfaces.enp0s8.ip}"
```
