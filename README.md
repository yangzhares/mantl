
![image](./mantl-logo-1.png)

# MANTL Packaging.

This branch is used to compile and package software for [http://mantl.io](http://mantl.io).

# Usage

1. Set Bintray paths and credentials:

 ```
 vim group_vars/all/packaging.yml
 ```

2. Deploy and package

 ```
 terraform apply .
 ansible-playbook -i ./plugins/inventory/terraform.py -e @security.yml terraform.sample.yml
 ```

3. ???
4. PROFIT

5. To rerun specific app packaging, use tags:

 ```
 ansible-playbook -t mesos-packaging -i ./plugins/inventory/terraform.py -e @security.yml terraform.sample.yml
 ```

# Overview

The components that make up the packaging framework are:
 * [asteris-packaging](https://github.com/asteris-llc/asteris-packaging) - a docker image with scripts included to compile/package mesos and calico inside a docker container
 * [roles/packaging](https://github.com/CiscoCloud/microservices-infrastructure/tree/tool/packaging/roles/packaging/templates) - templates for marathon tasks that run `asteris-packaging` docker container
 * [group_vars/all/packaging.yml](https://github.com/CiscoCloud/microservices-infrastructure/blob/tool/packaging/group_vars/all/packaging.yml) - mostly bintray variable to be passed to build environments

### Flow
1. `ansible-packaging` docker image is run as marathon task
2. Inside container apropriate repo is cloned, bootstrap and packaging scripts are run
3. Bintray script is run, packages are uploaded
4. Marathon task is terminated from within container


## License

Copyright © 2015 Cisco Systems, Inc.

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) (the "License").

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
