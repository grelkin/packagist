#
# Cookbook Name:: packagist
# Recipe:: _mysql
#
# Copyright (C) Sebastian Brandt <sebbrandt87+git@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chef_gem 'chef-rewind'
require 'chef/rewind'

# rewind mysql client because we want to use Percona
include_recipe 'mysql::client'
rewind :mysql_client => 'default' do
  action :nothing
end

# activate Percona-Server-shared-51 for php compilation
node.default['percona']['client']['packages'].push('Percona-Server-shared-51')
include_recipe 'percona::client'
# Install php
include_recipe 'php::default'

# Create php-fpm init.d
template '/etc/init.d/php-fpm' do
  source 'init.d.php-fpm.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'php-fpm' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Configure php-fpm
include_recipe 'php-fpm::configure'
# Install/configure composer
include_recipe 'composer::default'
# Install/configure percona mysql server
include_recipe 'percona::server'
# Install/configure solr
include_recipe 'solr::default'
# Install/configure redis
include_recipe 'redisio::default'
include_recipe 'redisio::enable'
# Install git
include_recipe 'git::default'
# Install subversion client
include_recipe 'subversion::default'
# Install crond
include_recipe 'cron::default'
