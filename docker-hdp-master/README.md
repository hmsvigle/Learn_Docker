# docker-hdp

These containers are not pushed to DockerHub, thus you'll need to build them locally:
```
docker-compose -f examples/compose/single-container.yml build
or 
docker-compose -f examples/compose/multi-container.yml build
```

A successful build looks like:
```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hdp/node            latest              cacb20b1b0d3        15 seconds ago      7.682 GB
hdp/ambari-server   latest              b0fad41dd49c        15 minutes ago      2.492 GB
hdp/postgres        latest              ad42250d5c8b        23 minutes ago      320.2 MB
centos              7                   cf2c3ece5e41        3 weeks ago         223.6 MB
postgres            latest              7ee9d2061970        6 weeks ago         275.3 MB
```

## Running HDP 3.0:
To run 3 containers (postgres, ambari-server, and a "single container HDP cluster"):
```
$ docker-compose -f examples/compose/single-container.yml up
or 
$ docker-compose -f examples/compose/single-container.yml up
```

After a minute or so, you can access Ambari's Web UI at localhost:8080. Default User/PW is admin/admin.

## Using Ambari Blueprints:
To snapshot your cluster's configuration into a blueprint:

Create a cluster manually & download the respective blueprint from the cluster. Then next time use the same blueprint to build the similar cluster with curl command 

curl --user admin:admin -H 'X-Requested-By:admin' localhost:8080/api/v1/clusters/dev?format=blueprint > examples/blueprints/single-container.json 
```

There are additional blueprints for common test-beds in examples/blueprints, including Hive-LLAP and HBase-Phoenix.

##Notes:
1. Ambari db has been pre-created in the postgres database running at postgres.dev. To configure them in Ambari, set Postgres as the DB type and change the Database URL to point at postgres.dev (as depicted in screenshot below) and leave everything else as the default options. The password for the dbs are all "dev":

2. The "node" container can be used for master, worker, or both types of services. The ambari-agent is configured to register with ambari-server.dev automatically, thus no SSH key setup is necessary. Use dn0.dev (and master0.dev if using multi-container):

3. Yum packages for all HDP services have been pre-installed in the "node" container. This lets cluster install take place much faster at the expense of a spurious warning from Ambari during Host-Checks.

4. All Ambari and HDP repositories are downloaded at buildtime. The versions and URLs are specified in .env in the project's root

5. Docker for Linux is more restrictive about "su" use, which Ambari relies on heavily, thus examples/compose/single-container.yml and multi-container.yml images are marked "privileged:true". Read up on the implications.

##Helpful Hints:
If you HDFS having issues starting up/not leaving SafeMode, it's probably because docker-compose is re-using containers from a previous run.

To start with fresh containers, before each run do:
```
docker-compose -f examples/compose/multi-container.yml rm
Going to remove compose_ambari-server.dev_1, compose_dn0.dev_1, compose_master0.dev_1, compose_postgres.dev_1
Are you sure? [yN] y
Removing compose_ambari-server.dev_1 ... done
Removing compose_dn0.dev_1 ... done
Removing compose_master0.dev_1 ... done
Removing compose_postgres.dev_1 ... done
```
