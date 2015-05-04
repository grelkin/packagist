#
# Cookbook Name:: packagist
# Recipe:: _install
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

# Install/configure something here
git '/opt/packagist' do
  repository 'https://github.com/composer/packagist.git'
  reference 'master'
  action :sync
end

template '/opt/packagist/app/config/parameters.yml' do
  source 'parameters.yml.erb'
  owner 'root'
  group 'root'
  mode '0744'
end

composer_project '/opt/packagist' do
    dev false
    quiet true
    prefer_dist true
    optimize_autoloader true
    action :install
end

execute 'db setup' do
  command 'app/console doctrine:schema:create'
  cwd '/opt/packagist'
  action :run
end

execute 'install assets' do
  command 'app/console assets:install web'
  cwd '/opt/packagist'
  action :run
end

# Configure daily jobs for packgist
# app/console packagist:update --no-debug --env=prod
# app/console packagist:dump --no-debug --env=prod
# app/console packagist:index --no-debug --env=prod

cron_d 'packagist:update' do
  minute  2
  hour    0
  command '/opt/packagist/app/console packagist:update --no-debug --env=prod && /opt/packagist/app/console packagist:dump --no-debug --env=prod && /opt/packagist/app/console packagist:index --no-debug --env=prod'
  user    'root'
end
